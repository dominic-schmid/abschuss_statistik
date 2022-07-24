import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/database_methods.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:jagdverband_scraper/widgets/no_data_found.dart';
import 'package:jagdverband_scraper/widgets/value_selector_modal.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kill_entry.dart';

class WildartPieChart extends StatefulWidget {
  const WildartPieChart({Key? key}) : super(key: key);

  @override
  State<WildartPieChart> createState() => _WildartPieChartState();
}

class _WildartPieChartState extends State<WildartPieChart> {
  late int year;
  Map<String, String> groupBy = {
    'key': 'Wildart',
    'value': 'wildart',
  };
  int touchedIndex = -1;

  List<Map<String, Object?>> res = [];

  bool _isLoading = true;

  List<Map<String, String>> groupBys = [
    {
      'key': 'Wildart',
      'value': 'wildart',
    },
    {
      'key': 'Geschlecht',
      'value': 'geschlecht',
    },
    {
      'key': 'Gebiet',
      'value': 'hegeinGebietRevierteil',
    },
    {
      'key': 'Erleger',
      'value': 'erleger',
    },
    {
      'key': 'Begleiter',
      'value': 'begleiter',
    },
    {
      'key': 'Ursache',
      'value': 'ursache',
    },
    {
      'key': 'Verwendung',
      'value': 'verwendung',
    },
    {
      'key': 'Ursprungszeichen',
      'value': 'ursprungszeichen',
    },
    {
      'key': 'Örtlichkeit',
      'value': 'oertlichkeit',
    },
    //  'datetime': k.datetime.toIso8601String(),
  ];

  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    getData();
  }

  getData() async {
    Database db = await SqliteDB().db;
    print('SQL grouping by ${groupBy['value']}');
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

      return PieChartSectionData(
        badgePositionPercentageOffset: 1.75,
        badgeWidget: Text('$title\n($value)',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline1!.color,
                fontWeight: FontWeight.bold)),
        //titlePositionPercentageOffset: -2,
        radius: touchedIndex == index ? size.width * 0.175 : size.width * 0.125,
        //color: KillEntry.getColorFromWildart(e['Gruppierung'] as String),
        color: groupBy['key'] == 'Wildart'
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

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.035, vertical: size.height * 0.05),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Text(
              'Abschüsse $year\nGruppiert über ${groupBy['key']}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: size.height * 0.04,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ActionChip(
                      avatar: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.calendar_month,
                          color: schneehaseFarbe,
                          size: 18,
                        ),
                      ),
                      backgroundColor: schneehaseFarbe.withOpacity(0.25),
                      labelStyle: const TextStyle(color: schneehaseFarbe),
                      label: Text('$year'),
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
                              return ValueSelectorModal<int>(
                                items: List.generate(
                                  DateTime.now().year - 2000 + 1,
                                  (index) => index + 2000,
                                ).reversed.toList(),
                                selectedItem: year,
                                onSelect: (selectedYear) async {
                                  if (selectedYear != year) {
                                    year = selectedYear;
                                    await getData();
                                    setState(() {});
                                  }
                                },
                              );
                            });
                      }),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(2),
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
                                  (index) => groupBys.elementAt(index)['key']
                                      as String,
                                ),
                                selectedItem: groupBy['key'] as String,
                                padding: false,
                                onSelect: (selected) async {
                                  if (groupBy !=
                                      groupBys.firstWhere((element) =>
                                          element['key'] as String ==
                                          selected)) {
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
              ),
            ],
          ),
          sections.isEmpty
              ? const NoDataFoundWidget(
                  suffix: "Eventuell musst du diese Daten erst herunterladen",
                )
              : Expanded(
                  child: PieChart(
                    swapAnimationDuration:
                        const Duration(milliseconds: 150), // Optional
                    swapAnimationCurve: Curves.decelerate, // Optional
                    PieChartData(
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
                      centerSpaceRadius: size.width * 0.15,
                      sections: sections,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
