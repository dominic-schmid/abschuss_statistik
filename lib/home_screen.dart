import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/kills_screen.dart';
import 'package:jagdverband_scraper/stats_screen.dart';
import 'package:jagdverband_scraper/utils.dart';

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
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        builder: ((context, value, child) {
          return BottomNavigationBar(
            selectedItemColor: rehwildFarbe.withGreen(160),
            onTap: (index) => controller.jumpToPage(index),
            // onTap: (index) => controller
            //     .animateToPage(
            //       index,
            //       duration: const Duration(milliseconds: 250),
            //       curve: Curves.decelerate,
            //     )
            //     .then((value) => currentPage.value = index),
            currentIndex: currentPage.value,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Abschüsse',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Statistik',
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
