import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/utils/database_methods.dart';
import 'package:jagdverband_scraper/utils/utils.dart';
import 'package:jagdverband_scraper/widgets/no_data_found.dart';
import 'package:jagdverband_scraper/widgets/value_selector_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kill_entry.dart';
import '../widgets/chart_app_bar.dart';

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
  List<Map<String, Object?>> res = [];
  bool _isLoading = true;

  Map<String, String> groupBy = {
    'key': 'Wildarten',
    'value': 'wildart',
  };

  List<Map<String, String>> groupBys = [
    {
      'key': 'Wildarten',
      'value': 'wildart',
    },
    {
      'key': 'Geschlechter',
      'value': 'geschlecht',
    },
    {
      'key': 'Gebiete',
      'value': 'hegeinGebietRevierteil',
    },
    {
      'key': 'Ursachen',
      'value': 'ursache',
    },
    {
      'key': 'Verwendungen',
      'value': 'verwendung',
    },
    {
      'key': 'Ursprungszeichen',
      'value': 'ursprungszeichen',
    },
    //  'datetime': k.datetime.toIso8601String(),
  ];

  List<int> years = [];

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

    List<Map<String, Object?>> res = await db.rawQuery("""
    SELECT
    COUNT(*) AS Anzahl,
    ${groupBy['value']} AS Gruppierung
    FROM Kill
    WHERE year = $year
    GROUP BY ${groupBy['value']}    
    """);

    this.res = res;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _isLoading = false);
    });
  }

  buildSections(List<Map<String, Object?>> res) {
    Size size = MediaQuery.of(context).size;
    int sum = 0;
    res.forEach((e) => sum += e['Anzahl'] as int);

    var sections = List.generate(res.length, (index) {
      Map<String, Object?> e = res.elementAt(index);

      String title = e['Gruppierung'] as String;
      int value = e['Anzahl'] as int;
      String percentage = (value / sum * 100).toStringAsFixed(0);

      num radius = touchedIndex == index
          ? size.aspectRatio < 1
              ? size.width * 0.35
              : size.height * 0.35
          : size.aspectRatio < 1
              ? size.width * 0.3
              : size.height * 0.3;

      return PieChartSectionData(
        badgePositionPercentageOffset: touchedIndex == index ? 1.23 : 1.33,
        badgeWidget: Text('$title\n($value)',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline1!.color,
                fontWeight: FontWeight.bold)),
        radius: radius.toDouble(),
        //radius: touchedIndex == index ? size.height * 0.35 : size.height * 0.3,
        titlePositionPercentageOffset: 0.5,
        //color: KillEntry.getColorFromWildart(e['Gruppierung'] as String),
        color: groupBy['value'] == 'wildart'
            ? KillEntry.getColorFromWildart(e['Gruppierung'] as String)
            : Colors.primaries[index % Colors.primaries.length],
        title: '$percentage%',
        titleStyle:
            const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        value: value.toDouble(),
      );
    });

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: rehwildFarbe));
    }

    Size size = MediaQuery.of(context).size;

    List<PieChartSectionData> sections = buildSections(res);

    return Scaffold(
      appBar: ChartAppBar(title: Text(groupBy['key'] as String), actions: []),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.035, vertical: size.height * 0.05),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
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
            Flexible(
              flex: 1,
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
                  divisions: _maxYear - _minYear,
                  value: year.toDouble(),
                  onChanged: (double value) async {
                    year = value.toInt();
                    await getData();
                    setState(() {});
                  },
                ),
              ),
            ),
            Flexible(
              flex: 2,
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
                  label: Text(groupBy['key'] as String),
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
                                setState(() {});
                              }
                            },
                          );
                        });
                  }),
            ),
            sections.isEmpty
                ? const NoDataFoundWidget(
                    suffix: "Eventuell musst du diese Daten erst herunterladen",
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: size.height * 0.5,
                      maxWidth: size.width,
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
            // : Expanded(
            //     flex: 10,
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(
            //         horizontal: size.width * 0.1,
            //         vertical: size.height * 0.1,
            //       ),
            //       child: PieChart(
            //         swapAnimationDuration:
            //             const Duration(milliseconds: 350), // Optional
            //         swapAnimationCurve: Curves.decelerate, // Optional
            //         PieChartData(
            //           pieTouchData: PieTouchData(touchCallback:
            //               (FlTouchEvent event, pieTouchResponse) {
            //             setState(() {
            //               if (!event.isInterestedForInteractions ||
            //                   pieTouchResponse == null ||
            //                   pieTouchResponse.touchedSection == null) {
            //                 touchedIndex = -1;
            //                 return;
            //               }
            //               touchedIndex = pieTouchResponse
            //                   .touchedSection!.touchedSectionIndex;
            //             });
            //           }),
            //           centerSpaceRadius: size.width * 0.15,
            //           sections: sections,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
