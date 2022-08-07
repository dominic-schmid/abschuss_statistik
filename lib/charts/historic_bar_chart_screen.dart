import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/utils/database_methods.dart';
import 'package:jagdverband_scraper/utils/utils.dart';
import 'package:jagdverband_scraper/widgets/no_data_found.dart';
import 'package:jagdverband_scraper/widgets/value_selector_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kill_entry.dart';
import '../widgets/chart_app_bar.dart';
import '../widgets/chart_legend.dart';
import '../widgets/chip_selector_modal.dart';
import '../models/filter_chip_data.dart';

class HistoricBarChartScreen extends StatefulWidget {
  const HistoricBarChartScreen({Key? key}) : super(key: key);

  @override
  State<HistoricBarChartScreen> createState() => _HistoricBarChartScreenState();
}

class _HistoricBarChartScreenState extends State<HistoricBarChartScreen> {
  late RangeValues years;
  int _minYear = 2000;
  int _maxYear = 2022;
  int maxDisplayValue = 0;
  int maxValue = 0;
  bool _asc = true;
  bool _showLegend = false;

  int touchedIndex = -1;

  List<Map<String, Object?>> res = [];
  List<ChartItem> chartItems = [];
  List<FilterChipData> filterChips = [];
  List<BarChartGroupData> groupData = [];

  bool _isLoading = true;

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
    String sorting = _asc ? 'ASC' : 'DESC';

    List<Map<String, Object?>> res = await db.rawQuery("""
    SELECT
    COUNT(*) AS Anzahl,
    ${groupBy['value']} AS Gruppierung
    FROM Kill
    WHERE year >= ${years.start.toInt()} AND year <= ${years.end.toInt()}
    GROUP BY ${groupBy['value']}    
    ORDER BY Anzahl $sorting
    """);
    // Get largest value

    this.res = res;

    if (mounted) setState(() => _isLoading = false);
  }

  void resetChips() {
    Set<String> gruppierungen =
        res.map((e) => e['Gruppierung'] as String).toSet();

    filterChips = [];
    for (int i = 0; i < gruppierungen.length; i++) {
      String g = gruppierungen.elementAt(i);
      Color c = groupBy['value'] == 'wildart'
          ? KillEntry.getColorFromWildart(g)
          : Colors.primaries[i % Colors.primaries.length];

      filterChips.add(FilterChipData(label: g, color: c));
    }

    rebuildMaxValue();
  }

  List<BarChartGroupData> buildGroupData() {
    Size size = MediaQuery.of(context).size;

    chartItems = [];

    Iterable<String> selectedLabels =
        filterChips.where((e) => e.isSelected).map((e) => e.label);

    var toBuild = res
        .where((e) => selectedLabels.contains(e['Gruppierung'] as String))
        .toList();

    for (int i = 0; i < toBuild.length; i++) {
      String label = toBuild.elementAt(i)['Gruppierung'] as String;
      double value = (toBuild.elementAt(i)['Anzahl'] as int).toDouble();

      Color c = groupBy['value'] == 'wildart'
          ? KillEntry.getColorFromWildart(label)
          : Colors.primaries[i % Colors.primaries.length];

      chartItems.add(ChartItem(label: label, value: value, color: c));
    }

    rebuildMaxValue();

    return chartItems.map((e) {
      int index = chartItems.indexOf(e);
      bool isTouched = index == touchedIndex;
      return BarChartGroupData(
        x: index,
        showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: e.value,
            color: e.color,
            width: size.width / (2.5 * chartItems.length),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            borderSide: isTouched
                ? BorderSide(
                    color: Theme.of(context).textTheme.headline1!.color ??
                        Colors.yellow,
                    width: size.width * 0.005,
                  )
                : const BorderSide(color: Colors.white, width: 0),
          )
        ],
      );
    }).toList();
  }

  void rebuildMaxValue() {
    maxDisplayValue = 0;
    int maxValue = 0;

    for (ChartItem e in chartItems) {
      if (e.value > maxValue) maxValue = e.value.toInt(); // Get largest value
    }

    maxDisplayValue =
        ((maxValue) % 5 == 0 ? maxValue : 5 - maxValue % 5 + maxValue);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: rehwildFarbe));
    }

    Size size = MediaQuery.of(context).size;

    groupData.clear();
    groupData.addAll(buildGroupData());

    return Scaffold(
      appBar: ChartAppBar(title: Text(groupBy['key'] as String), actions: [
        IconButton(
          onPressed: () => setState(() => _showLegend = !_showLegend),
          icon: const Icon(Icons.legend_toggle_rounded),
        ),
        IconButton(
          onPressed: () => setState(() {
            _asc = !_asc;
            getData();
          }),
          icon: const Icon(Icons.sort_by_alpha_rounded),
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
                  // resetChips();
                  rebuildMaxValue();
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
                    }),
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
                            chips: filterChips,
                          );
                        });
                    rebuildMaxValue();
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.05),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: rehwildFarbe))
              : groupData.isEmpty
                  ? const NoDataFoundWidget()
                  : ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: size.height * 0.5,
                        maxWidth: size.width * 0.9,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.01,
                          vertical: size.height * 0.01,
                        ),
                        child: BarChart(
                          swapAnimationDuration:
                              const Duration(milliseconds: 350), // Optional
                          swapAnimationCurve: Curves.decelerate, // Optional
                          BarChartData(
                            alignment: BarChartAlignment.spaceEvenly,
                            maxY: maxDisplayValue.toDouble() +
                                (maxDisplayValue * 0.05),
                            minY: 0,
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            barGroups: groupData,
                            titlesData: FlTitlesData(
                              rightTitles: AxisTitles(),
                              leftTitles: AxisTitles(),
                              topTitles: AxisTitles(),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    String g = chartItems
                                        .elementAt(value.toInt())
                                        .label;
                                    // g = res.length > 15
                                    //     ? g.substring(0, 1)
                                    //     : g.length < 3
                                    //         ? g
                                    //         : g.substring(0, 3);
                                    double w =
                                        size.width / chartItems.length * 0.08;
                                    num endIndex = g.length > w ? w : g.length;

                                    g = g.isEmpty
                                        ? ''
                                        : g.substring(
                                            0,
                                            endIndex < 1 ? 1 : endIndex.toInt(),
                                          );
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(g),
                                    );
                                  },
                                ),
                              ),
                            ),
                            barTouchData: BarTouchData(
                                touchExtraThreshold: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                  vertical: size.height * 0.05,
                                ),
                                touchTooltipData: BarTouchTooltipData(
                                  fitInsideHorizontally: true,
                                  tooltipBgColor: Colors.transparent,
                                  tooltipPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  tooltipMargin: 0,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    //print('Working $groupIndex');
                                    return BarTooltipItem(
                                      rod.toY.toStringAsFixed(0),
                                      TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color,
                                      ),
                                    );
                                  },
                                ),
                                enabled: true,
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.spot == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .spot!.touchedBarGroupIndex;
                                  });
                                }),
                            // centerSpaceRadius: size.width * 0.15,
                            // sections: sections,
                          ),
                        ),
                      ),
                    ),
          _showLegend ? ChartLegend(items: chartItems) : Container()
        ],
      ),
    );
  }
}