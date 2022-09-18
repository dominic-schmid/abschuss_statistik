import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/providers.dart';
import 'package:jagdstatistik/views/kills_screen.dart';
import 'package:jagdstatistik/views/stats_screen.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController controller = PageController(initialPage: 0);
  ValueNotifier<int> currentPage = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocaleProvider>(context).locale; // listen for locale changes
    final dg = S.of(context);
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        builder: ((context, value, child) {
          return BottomNavigationBar(
            selectedItemColor: rehwildFarbe.withGreen(160),
            // onTap: (index) => controller.jumpToPage(index),
            onTap: (index) => controller
                .animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                )
                .then((value) => currentPage.value = index),
            currentIndex: currentPage.value,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home_rounded),
                label: dg.kills,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_rounded),
                label: dg.statistics,
              ),
            ],
          );
        }),
        valueListenable: currentPage,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          KillsScreen(),
          StatsScreen(),
        ],
        onPageChanged: (index) => currentPage.value = index,
      ),
    );
  }
}
