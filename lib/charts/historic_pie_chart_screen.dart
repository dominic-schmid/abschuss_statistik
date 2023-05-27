import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/utils/constants.dart';
import 'package:jagdstatistik/utils/database_methods.dart';
import 'package:jagdstatistik/utils/translation_helper.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/chart_legend.dart';
import 'package:jagdstatistik/widgets/no_data_found.dart';
import 'package:jagdstatistik/widgets/value_selector_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../generated/l10n.dart';
import '../models/filter_chip_data.dart';
import '../widgets/chart_app_bar.dart';
import '../widgets/chip_selector_modal.dart';

class HistoricPieChartScreen extends StatefulWidget {
  const HistoricPieChartScreen({Key? key}) : super(key: key);

  @override
  State<HistoricPieChartScreen> createState() => _HistoricPieChartScreenState();
}

class _HistoricPieChartScreenState extends State<HistoricPieChartScreen> {
  late RangeValues yearRange;

  int _minYear = 2000;
  int _maxYear = 2022;

  int touchedIndex = -1;

  List<Map<String, Object?>> res = [];
  List<ChartItem> chartItems = [];
  List<FilterChipData> filterChips = [];

  bool _isLoading = true;
  List<FilterChipData> configurationChips = [];
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

  @override
  void initState() {
    super.initState();
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

  getConfig() async {
    showPerson();
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
      _minYear = 2000;
      _maxYear = DateTime.now().year;
    }
    yearRange = RangeValues(_minYear.toDouble(), _maxYear.toDouble());
  }

  getData() async {
    Database db = await SqliteDB().db;
    String erlegtQuery = _showOnlyErlegt ? "ursache = 'erlegt'" : "1 = 1";

    List<Map<String, Object?>> res = await db.rawQuery("""
    SELECT
    COUNT(*) AS Anzahl,
    ${groupBy['value']} AS Gruppierung
    FROM Kill
    WHERE year >= ${yearRange.start.toInt()} AND year <= ${yearRange.end.toInt()} AND $erlegtQuery
    GROUP BY ${groupBy['value']}    
    """);

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
          ? GameType.all.firstWhere((e) => e.wildart == g).color
          : Colors.primaries[i % Colors.primaries.length];

      filterChips.add(FilterChipData(label: g, color: c));
    }

    //     chartItems = [];
    // for (int i = 0; i < res.length; i++) {
    //   var e = res.elementAt(i);
    //   String label = e['Gruppierung'] as String;
    //   double value = (e['Anzahl'] as int).toDouble();

    //   Color c = groupBy['value'] == 'wildart'
    //       ? KillEntry.getColorFromWildart(e['Gruppierung'] as String)
    //       : Colors.primaries[i % Colors.primaries.length];

    //   chartItems.add(ChartItem(label: label, value: value, color: c));
    // }
  }

  List<PieChartSectionData> buildSections() {
    Size size = MediaQuery.of(context).size;

    double sum = 0;
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
          ? GameType.all.firstWhere((e) => e.wildart == label).color
          : Colors.primaries[i % Colors.primaries.length];

      sum += value;

      chartItems.add(ChartItem(
          label: translateValue(context, label), value: value, color: c));
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

    var sections = buildSections();

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
                      chips: configurationChips);
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
              yearRange.start == yearRange.end
                  ? '${yearRange.start.toInt()}'
                  : '${yearRange.start.toInt()} - ${yearRange.end.toInt()}',
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
                values: yearRange,
                labels: RangeLabels(yearRange.start.toInt().toString(),
                    yearRange.end.toInt().toString()),
                min: _minYear.toDouble(),
                max: _maxYear.toDouble(),
                divisions: _maxYear - _minYear == 0 ? 1 : _maxYear - _minYear,
                onChanged: (RangeValues values) async {
                  yearRange = values;
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
                    await showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        shape: Constants.modalShape,
                        builder: (BuildContext context) {
                          return ChipSelectorModal(
                            title: groupBy['key'] as String,
                            chips: filterChips,
                          );
                        });
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
              : sections.isEmpty
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
                            sections: sections,
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
