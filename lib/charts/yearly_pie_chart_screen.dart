import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/models/filter_chip_data.dart';
import 'package:jagdstatistik/utils/constants.dart';
import 'package:jagdstatistik/utils/database_methods.dart';
import 'package:jagdstatistik/utils/translation_helper.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/chip_selector_modal.dart';
import 'package:jagdstatistik/widgets/no_data_found.dart';
import 'package:jagdstatistik/widgets/value_selector_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets/chart_app_bar.dart';
import '../widgets/chart_legend.dart';

class YearlyPieChartScreen extends StatefulWidget {
  const YearlyPieChartScreen({Key? key}) : super(key: key);

  @override
  State<YearlyPieChartScreen> createState() => _YearlyPieChartScreenState();
}

class _YearlyPieChartScreenState extends State<YearlyPieChartScreen> {
  late int year;
  int _minYear = 2000;
  int _maxYear = 2022;

  int touchedIndex = -1;
  List<ChartItem> chartItems = [];
  bool _isLoading = true;

  Set<FilterChipData> configurationChips = {};
  bool _showLegend = false;
  bool _showOnlyErlegt = true;

  Map<String, String> groupBy = {};

  List<Map<String, String>> groupBys = [];

  showPerson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showPerson = prefs.getBool('showPerson') ?? false;
    if (!mounted) return;
    final dg = S.of(context);
    if (showPerson) {
      groupBys.addAll(
        [
          {
            'key': dg.killer,
            'value': 'erleger',
          },
          {
            'key': dg.companion,
            'value': 'begleiter',
          },
        ],
      );
    }
  }

  getConfig() async {
    showPerson();
    await getYearList();
    await getData();
  }

  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    getConfig();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      groupBys = getBaseGroupBys(context).toList();
      groupBy = groupBys.first;
      final dg = S.of(context);
      configurationChips.addAll([
        FilterChipData(
            label: dg.onlyShot, color: Colors.red, isSelected: _showOnlyErlegt),
        FilterChipData(
            label: dg.legend, color: Colors.orange, isSelected: _showLegend),
      ]);
    });
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
      _minYear = 2000;
      _maxYear = DateTime.now().year;
    }
  }

  getData() async {
    Database db = await SqliteDB().db;
    String erlegtQuery = _showOnlyErlegt ? "ursache = 'erlegt'" : "1 = 1";
    List<Map<String, Object?>> res = await db.rawQuery("""
    SELECT
    COUNT(*) AS Anzahl,
    ${groupBy['value']} AS Gruppierung
    FROM Kill
    WHERE year = $year AND $erlegtQuery
    GROUP BY ${groupBy['value']}    
    """);

    chartItems = [];
    for (int i = 0; i < res.length; i++) {
      var e = res.elementAt(i);
      String label = e['Gruppierung'] as String;
      double value = (e['Anzahl'] as int).toDouble();

      Color c = groupBy['value'] == 'wildart'
          ? GameType.all
              .firstWhere((f) => f.wildart == e['Gruppierung'] as String)
              .color
          : Colors.primaries[i % Colors.primaries.length];
      if (!mounted) return;
      chartItems.add(ChartItem(
          label: translateValue(context, label), value: value, color: c));
    }

    if (mounted) setState(() => _isLoading = false);
  }

  List<PieChartSectionData> buildSections() {
    Size size = MediaQuery.of(context).size;

    int sum = 0;
    for (var e in chartItems) {
      sum += e.value.toInt();
    }

    return chartItems.map((e) {
      String percentage = (e.value / sum * 100).toStringAsFixed(0);
      int index = chartItems.indexOf(e);
      num radius = touchedIndex == index
          ? size.aspectRatio < 1
              ? size.width * 0.35
              : size.height * 0.35
          : size.aspectRatio < 1
              ? size.width * 0.3
              : size.height * 0.3;

      return PieChartSectionData(
        badgePositionPercentageOffset: touchedIndex == index ? 1.23 : 1.33,
        badgeWidget: Text(
          '${e.label}\n(${e.value.toInt()})',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.displayLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        radius: radius.toDouble(),
        //radius: touchedIndex == index ? size.height * 0.35 : size.height * 0.3,
        titlePositionPercentageOffset: 0.5,
        //color: KillEntry.getColorFromWildart(e['Gruppierung'] as String),
        color: e.color,
        title: '$percentage%',
        titleStyle:
            const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        value: e.value,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: rehwildFarbe));
    }

    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);

    return Scaffold(
      appBar: ChartAppBar(title: Text(groupBy['key'] as String), actions: [
        IconButton(
          onPressed: () async {
            await showModalBottomSheet(
                showDragHandle: true,
                context: context,
                shape: Constants.modalShape,
                builder: (BuildContext context) {
                  return ChipSelectorModal(
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                      left: size.width * 0.05,
                      right: size.width * 0.05,
                      bottom: size.height * 0.015,
                    ),
                    title: dg.configuration,
                    chips: configurationChips,
                  );
                });
            setState(() {
              _showOnlyErlegt = configurationChips
                  .where((element) => element.label == dg.onlyShot)
                  .first
                  .isSelected;
              _showLegend = configurationChips
                  .where((element) => element.label == dg.legend)
                  .first
                  .isSelected;
            });
            getData();
          },
          icon: const Icon(Icons.settings),
        ),
      ]),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.035),
            child: Text(
              year.toString(),
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
              child: Slider(
                min: _minYear.toDouble(),
                max: _maxYear.toDouble(),
                label: year.toString(),
                divisions: _maxYear - _minYear == 0 ? 1 : _maxYear - _minYear,
                value: year.toDouble(),
                onChanged: (double value) async {
                  year = value.toInt();
                  await getData();
                },
              ),
            ),
          ),
          ActionChip(
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
              label: Text(dg.display),
              onPressed: () async {
                await showModalBottomSheet(
                    showDragHandle: true,
                    context: context,
                    shape: Constants.modalShape,
                    builder: (BuildContext context) {
                      return ValueSelectorModal<String>(
                        items: List.generate(
                          groupBys.length,
                          (index) => groupBys.elementAt(index)['key'] as String,
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
                            setState(() {});
                          }
                        },
                      );
                    });
              }),
          SizedBox(height: size.height * 0.05),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: rehwildFarbe))
              : chartItems.isEmpty
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
                        child: PieChart(
                          swapAnimationDuration:
                              const Duration(milliseconds: 350), // Optional
                          swapAnimationCurve: Curves.decelerate, // Optional
                          PieChartData(
                            startDegreeOffset: 180,

                            pieTouchData: PieTouchData(touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            }),
                            sectionsSpace: 2,
                            centerSpaceRadius: 0, //size.width * 0.15,
                            sections: buildSections(),
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
