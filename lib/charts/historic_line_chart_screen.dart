import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/utils/database_methods.dart';
import 'package:jagdverband_scraper/utils/utils.dart';
import 'package:jagdverband_scraper/widgets/chart_legend.dart';
import 'package:jagdverband_scraper/widgets/chip_selector_modal.dart';
import 'package:jagdverband_scraper/models/filter_chip_data.dart';
import 'package:jagdverband_scraper/widgets/no_data_found.dart';
import 'package:jagdverband_scraper/widgets/value_selector_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kill_entry.dart';
import '../widgets/chart_app_bar.dart';

class HistoricLineChartScreen extends StatefulWidget {
  const HistoricLineChartScreen({Key? key}) : super(key: key);

  @override
  State<HistoricLineChartScreen> createState() =>
      _HistoricLineChartScreenState();
}

class _HistoricLineChartScreenState extends State<HistoricLineChartScreen> {
  late RangeValues years;
  int _minYear = 2000;
  int _maxYear = 2022;
  int maxDisplayValue = 0;
  int maxValue = 0;

  List<Map<String, Object?>> res = [];
  List<FilterChipData> lineChips = [];
  List<ChartItem> chartItems = [];

  bool _isLoading = true;
  bool _showDots = false;
  bool _showGrid = false;
  int _barWidth = 2;

  Map<String, String> groupBy = {
    'key': 'Wildarten',
    'value': 'wildart',
  };

  List<Map<String, String>> groupBys = baseGroupBys.toList();

  showPerson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showPerson = prefs.getBool('showPerson') ?? false;
    if (showPerson) {
      groupBys.addAll(
        [
          {
            'key': 'Erleger',
            'value': 'erleger',
          },
          {
            'key': 'Begleiter',
            'value': 'begleiter',
          },
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getConfig();
  }

  getConfig() async {
    await showPerson();
    await getYearList();
    await getData();
    resetChips();
  }

  getYearList() async {
    try {
      Database db = await SqliteDB().db;

      List<Map<String, Object?>> res = await db.rawQuery("""
      SELECT
      min(year) AS MIN_YEAR,
      max(year) AS MAX_YEAR
      FROM Kill
      """);
      _minYear = res.first['MIN_YEAR'] as int;
      _maxYear = res.first['MAX_YEAR'] as int;
    } catch (e) {
      print('Error getting years! ${e.toString()}');
      _minYear = 2000;
      _maxYear = DateTime.now().year;
    }
    years = RangeValues(_minYear.toDouble(), _maxYear.toDouble());
  }

  getData() async {
    Database db = await SqliteDB().db;

    List<Map<String, Object?>> res = await db.rawQuery("""
    SELECT
    year AS Jahr,
    COUNT(*) AS Anzahl,
    ${groupBy['value']} AS Gruppierung
    FROM Kill
    WHERE year >= ${years.start.toInt()} AND year <= ${years.end.toInt()}
    GROUP BY ${groupBy['value']}, year   
    ORDER BY year ASC
    """);
    // Get largest value

    this.res = res;

    if (mounted) setState(() => _isLoading = false);
  }

  void resetChips() {
    Set<String> gruppierungen =
        res.map((e) => e['Gruppierung'] as String).toSet();

    lineChips = [];
    for (int i = 0; i < gruppierungen.length; i++) {
      String g = gruppierungen.elementAt(i);
      Color c = groupBy['value'] == 'wildart'
          ? KillEntry.getColorFromWildart(g)
          : Colors.primaries[i % Colors.primaries.length];

      lineChips.add(FilterChipData(label: g, color: c));
    }
  }

  List<LineChartBarData> buildLines(List<Map<String, Object?>> res) {
    List<LineChartBarData> lines = [];
    chartItems = [];
    // Hole einzelne gruppierungen (z.b. alle individuellen Wildarten und zeichne daraus dann eine Linie mit allen existierenden Werten)

    List<FilterChipData> selectedChips =
        lineChips.where((e) => e.isSelected).toList();

    maxDisplayValue = 0;
    maxValue = 0;

    for (int i = 0; i < selectedChips.length; i++) {
      String g = selectedChips.elementAt(i).label;
      Color c = selectedChips.elementAt(i).color;

      Iterable values = res.where((element) => element['Gruppierung'] == g);

      List<FlSpot> spots = List.generate(values.length, (index) {
        int year = values.elementAt(index)['Jahr'] as int;
        int anzahl = values.elementAt(index)['Anzahl'] as int;
        if (anzahl > maxValue) maxValue = anzahl;

        return FlSpot(year.toDouble(), anzahl.toDouble());
      });

      chartItems.add(ChartItem(label: g, value: 0, color: c));
      lines.add(
        LineChartBarData(
          barWidth: _barWidth.toDouble(),
          isStrokeCapRound: true,
          dotData: FlDotData(show: _showDots),
          spots: spots,
          color: c,
          isCurved: true,
        ),
      );
    }

    maxDisplayValue =
        ((maxValue) % 5 == 0 ? maxValue : 5 - maxValue % 5 + maxValue);

    return lines;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: rehwildFarbe));
    }

    Size size = MediaQuery.of(context).size;

    Iterable<FilterChipData> selectedLineChips =
        lineChips.where((element) => element.isSelected);

    var lines = buildLines(res);

    return Scaffold(
      appBar: ChartAppBar(title: Text(groupBy['key'] as String), actions: [
        IconButton(
            onPressed: () => setState(() => _barWidth = _barWidth % 4 + 1),
            icon: const Icon(Icons.line_axis_rounded)),
        IconButton(
            onPressed: () => setState(() => _showGrid = !_showGrid),
            icon: Icon(
                _showGrid ? Icons.grid_off_outlined : Icons.grid_on_outlined)),
        IconButton(
          onPressed: () => setState(() => _showDots = !_showDots),
          icon: Icon(_showDots ? Icons.circle_outlined : Icons.linear_scale),
        ),
      ]),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.035),
            child: Text(
              years.start == years.end
                  ? '${years.start.toInt()}'
                  : '${years.start.toInt()} - ${years.end.toInt()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: size.height * 0.04,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.033),
            child: SliderTheme(
              data: SliderThemeData(
                activeTickMarkColor: primaryColor,
                thumbColor: rehwildFarbe,
                activeTrackColor: rehwildFarbe.withAlpha(180),
                inactiveTrackColor: rehwildFarbe.withOpacity(0.2),
                trackHeight: size.height * 0.01,
                valueIndicatorColor: rehwildFarbe,
                valueIndicatorTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  //color: ,
                ),
              ),
              child: RangeSlider(
                values: years,
                labels: RangeLabels(years.start.toInt().toString(),
                    years.end.toInt().toString()),
                min: _minYear.toDouble(),
                max: _maxYear.toDouble(),
                divisions: _maxYear - _minYear == 0 ? 1 : _maxYear - _minYear,
                onChanged: (RangeValues values) async {
                  years = values;
                  await getData();
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ActionChip(
                  avatar: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.pets_rounded,
                      color: nichtBekanntFarbe,
                      size: 18,
                    ),
                  ),
                  backgroundColor: nichtBekanntFarbe.withOpacity(0.25),
                  labelStyle: const TextStyle(color: nichtBekanntFarbe),
                  label: const Text('Anzeige'),
                  onPressed: () async {
                    await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return ValueSelectorModal<String>(
                            items: List.generate(
                              groupBys.length,
                              (index) =>
                                  groupBys.elementAt(index)['key'] as String,
                            ),
                            selectedItem: groupBy['key'] as String,
                            padding: false,
                            onSelect: (selected) async {
                              if (groupBy !=
                                  groupBys.firstWhere((element) =>
                                      element['key'] as String == selected)) {
                                groupBy = groupBys.firstWhere((element) =>
                                    element['key'] as String == selected);
                                await getData();
                                resetChips();
                                setState(() {});
                              }
                            },
                          );
                        });
                  },
                ),
              ),
              Expanded(
                child: ActionChip(
                    avatar: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.filter_alt_rounded,
                        color: protokollFarbe,
                        size: 18,
                      ),
                    ),
                    backgroundColor: protokollFarbe.withOpacity(0.25),
                    labelStyle: const TextStyle(color: protokollFarbe),
                    label: Text(groupBy['key'] as String),
                    onPressed: () async {
                      await showMaterialModalBottomSheet(
                          context: context,
                          shape: modalShape,
                          builder: (BuildContext context) {
                            return ChipSelectorModal(
                              title: groupBy['key'] as String,
                              chips: lineChips,
                            );
                          });
                      if (mounted) setState(() {});
                    }),
              ),
            ],
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: rehwildFarbe))
              : lines.isEmpty
                  ? const NoDataFoundWidget()
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: size.height * 0.5,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: size.width * 0.03,
                          left: size.width * 0.005,
                          top: size.height * 0.01,
                          bottom: size.height * 0.01,
                        ),
                        child: LineChart(
                          swapAnimationDuration:
                              const Duration(milliseconds: 350), // Optional
                          swapAnimationCurve: Curves.decelerate, // Optional
                          LineChartData(
                            lineBarsData: lines,
                            //alignment: BarChartAlignment.spaceEvenly,
                            maxY: maxDisplayValue.toDouble() +
                                (maxDisplayValue * 0.05),
                            minY: 0,
                            // Try to create better padding
                            minX:
                                years.start - (0.5 / (years.end - years.start)),
                            maxX: years.end + (0.5 / (years.end - years.start)),
                            clipData: FlClipData.all(),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: _showGrid),
                            titlesData: FlTitlesData(
                              rightTitles: AxisTitles(
                                  // sideTitles: SideTitles(
                                  //   reservedSize: 38,
                                  //   showTitles: true,
                                  //   getTitlesWidget: (value, meta) => Container(),
                                  // ),
                                  ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 38,
                                  interval: maxDisplayValue / 4,
                                  getTitlesWidget: (value, meta) {
                                    if (value > maxDisplayValue || value == 0) {
                                      return Container();
                                    }

                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(value.toInt().toString()),
                                    );
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 1 != 0) {
                                      return Container(); // Only show actual years
                                    }
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                          (value.toInt() % 100).toString()),
                                    );
                                  },
                                ),
                              ),
                            ),
                            lineTouchData: LineTouchData(
                              touchSpotThreshold:
                                  size.width * 0.35 / (years.end - years.start),
                            ),
                          ),
                        ),
                      ),
                    ),
          ChartLegend(items: chartItems),
        ],
      ),
    );
  }
}
