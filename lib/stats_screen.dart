import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/utils/utils.dart';
import 'package:jagdverband_scraper/widgets/chart_app_bar.dart';
import 'package:jagdverband_scraper/charts/yearly_pie_chart_screen.dart';

import 'charts/historic_bar_chart_screen.dart';
import 'charts/historic_line_chart_screen.dart';
import 'charts/historic_pie_chart_screen.dart';
import 'charts/yearly_bar_chart_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const ChartAppBar(title: Text('Statistik'), actions: []),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.height * 0.01),
            Text(
              'Jährlich',
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
                    title: 'Summe',
                    assetImage: 'assets/pie-chart.png',
                    backgroundColor: gamswildFarbe.withAlpha(215),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const YearlyPieChartScreen(),
                      ),
                    ),
                  ),
                  ChartGridItem(
                    title: 'Verteilung',
                    assetImage: 'assets/bar-graph.png',
                    backgroundColor: schneehaseFarbe,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const YearlyBarChartScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.025),
            Text(
              'Historisch',
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
                    title: 'Summe',
                    assetImage: 'assets/pie-chart.png',
                    backgroundColor: gamswildFarbe.withAlpha(215),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoricPieChartScreen(),
                      ),
                    ),
                  ),
                  ChartGridItem(
                    title: 'Verteilung',
                    assetImage: 'assets/bar-graph.png',
                    backgroundColor: schneehaseFarbe,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoricBarChartScreen(),
                      ),
                    ),
                  ),
                  ChartGridItem(
                    title: 'Deckung',
                    assetImage: 'assets/area-chart.png',
                    backgroundColor: verkaufFarbe,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoricLineChartScreen(),
                      ),
                    ),
                  ),
                  ChartGridItem(
                    title: 'Verlauf',
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
                style: const TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
