import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/providers.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/hunting_time_screen.dart';
import 'package:jagdstatistik/views/mating_time_screen.dart';
import 'package:jagdstatistik/views/shooting_times_screen.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:jagdstatistik/charts/yearly_pie_chart_screen.dart';
import 'package:provider/provider.dart';

import '../charts/historic_bar_chart_screen.dart';
import '../charts/historic_line_chart_screen.dart';
import '../charts/historic_pie_chart_screen.dart';
import '../charts/yearly_bar_chart_screen.dart';
import '../charts/yearly_line_chart_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);
    final prefProvider = Provider.of<PrefProvider>(context);

    return Scaffold(
      appBar: ChartAppBar(title: Text(dg.statistics), actions: [
        IconButton(
          onPressed: () {
            showAlertDialog(
              title: ' ${dg.usage}',
              description: dg.chartBasedOnDownloaded,
              yesOption: '',
              noOption: 'Ok',
              onYes: () {},
              icon: Icons.help_outline_rounded,
              context: context,
            );
          },
          icon: const Icon(Icons.help_outline_rounded),
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.height * 0.01),
            Text(
              dg.yearly,
              style: Theme.of(context).primaryTextTheme.titleLarge,
            ),
            Flexible(
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: [
                  ChartGridItem(
                    title: dg.sum,
                    assetImage: 'assets/pie-chart.png',
                    backgroundColor: gamswildFarbe.withAlpha(215).withOpacity(0.66),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const YearlyPieChartScreen(),
                      ),
                    ),
                  ),
                  ChartGridItem(
                    title: dg.distribution,
                    assetImage: 'assets/bar-graph.png',
                    backgroundColor: schneehaseFarbe.withOpacity(0.66),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const YearlyBarChartScreen(),
                      ),
                    ),
                  ),
                  ChartGridItem(
                    title: dg.monthlyBreakdown,
                    assetImage: 'assets/increase-line.png',
                    backgroundColor: erlegtFarbe.withGreen(150),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const YearlyLineChartScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              dg.historic,
              style: Theme.of(context).primaryTextTheme.titleLarge,
            ),
            Flexible(
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: [
                  ChartGridItem(
                    title: dg.sum,
                    assetImage: 'assets/pie-chart.png',
                    backgroundColor: gamswildFarbe.withAlpha(215),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoricPieChartScreen(),
                      ),
                    ),
                  ),
                  ChartGridItem(
                    title: dg.distribution,
                    assetImage: 'assets/bar-graph.png',
                    backgroundColor: schneehaseFarbe,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoricBarChartScreen(),
                      ),
                    ),
                  ),
                  // ChartGridItem(
                  //   title: 'Deckung',
                  //   assetImage: 'assets/area-chart.png',
                  //   backgroundColor: verkaufFarbe,
                  //   onTap: () => Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) => const HistoricLineChartScreen(),
                  //     ),
                  //   ),
                  // ),
                  ChartGridItem(
                    title: dg.yearlyBreakdown,
                    assetImage: 'assets/increase-line.png',
                    backgroundColor: erlegtFarbe.withGreen(150),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoricLineChartScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              dg.wild,
              style: Theme.of(context).primaryTextTheme.titleLarge,
            ),
            Flexible(
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: [
                  ChartGridItem(
                    title: dg.jagdzeiten,
                    assetImage: 'assets/planning.png',
                    backgroundColor: nichtGefundenFarbe.withAlpha(215),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HuntingTimeScreen(),
                      ),
                    ),
                  ),
                  ChartGridItem(
                    title: dg.paarungszeiten,
                    assetImage: 'assets/calendar.png',
                    backgroundColor: wildFarbe,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MatingTimeScreen(),
                      ),
                    ),
                  ),
                  prefProvider.betaMode
                      ? ChartGridItem(
                          title: dg.schusszeiten,
                          assetImage: 'assets/sunrise.png',
                          backgroundColor: hegeabschussFarbe.withAlpha(166),
                          onTap: () async {
                            if (await Connectivity()
                                    .checkConnectivity()
                                    .timeout(const Duration(seconds: 15)) ==
                                ConnectivityResult.none) {
                              showSnackBar(dg.noInternetError, context);
                              return;
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ShootingTimesScreen(),
                            ));
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartGridItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String assetImage;
  final Color backgroundColor;
  const ChartGridItem({
    Key? key,
    required this.onTap,
    required this.title,
    required this.assetImage,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: size.height * 0.044,
                child: Image.asset(assetImage),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
