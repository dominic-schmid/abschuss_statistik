import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/providers/locale_provider.dart';
import 'package:jagdstatistik/providers/pref_provider.dart';
import 'package:jagdstatistik/utils/local_auth_helper.dart';
import 'package:jagdstatistik/views/credentials_screen.dart';
import 'package:jagdstatistik/views/kills_screen.dart';
import 'package:jagdstatistik/views/stats_screen.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:jagdstatistik/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final dg = S.of(context);
      final prefProvider = Provider.of<PrefProvider>(context, listen: false);
      bool? hasSetLocalAuth = prefProvider.localAuth;
      print('Local auth: $hasSetLocalAuth');
      if (hasSetLocalAuth == null) {
        // only show this pop up the first time
        await Future.delayed(
          const Duration(milliseconds: 500),
          () async {
            bool shouldEnable = await showAlertDialog(
                  title: " ${dg.biometrics}",
                  description: dg.shouldUseLocalAuth,
                  yesOption: dg.dialogYes,
                  noOption: dg.dialogNo,
                  onYes: () {},
                  icon: Icons.fingerprint_rounded,
                  context: context,
                ) ??
                false;
            await prefProvider.get.setBool('localAuth', shouldEnable);
            _isAuthenticated = true;
          },
        );
      } else if (hasSetLocalAuth == true) {
        // Try authenticate if a user has set biometric login to enabled
        _isAuthenticated =
            await LocalAuthApi.authentiate(subtitle: dg.useLocalAuth);
      } else if (hasSetLocalAuth == false) {
        _isAuthenticated = true;
      }
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    Provider.of<LocaleProvider>(context).locale; // listen for locale changes

    return Scaffold(
      appBar: !_isAuthenticated
          ? ChartAppBar(
              title: Text(dg.appTitle),
              actions: const [],
            )
          : null,
      bottomNavigationBar: IgnorePointer(
        ignoring: !_isAuthenticated,
        child: ValueListenableBuilder(
          builder: ((context, value, child) {
            return BottomNavigationBar(
              selectedItemColor: rehwildFarbe.withGreen(160),
              // onTap: (index) => controller.jumpToPage(index),
              onTap: (index) => _pageController
                  .animateToPage(
                    index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                  )
                  .then((value) => _currentPage.value = index),
              currentIndex: _currentPage.value,
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
          valueListenable: _currentPage,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: rehwildFarbe,
              ),
            )
          : !_isAuthenticated
              ? _noAuthReAuth()
              : PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: const [
                    KillsScreen(),
                    StatsScreen(),
                  ],
                  onPageChanged: (index) => _currentPage.value = index,
                ),
    );
  }

  Widget _noAuthReAuth() {
    final dg = S.of(context);
    Size size = MediaQuery.of(context).size;

    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NoDataFoundWidget(suffix: dg.needLogin),
        SizedBox(height: size.height * 0.035),
        ElevatedButton.icon(
          onPressed: () async {
            setState(() => _isLoading = true);
            _isAuthenticated =
                await LocalAuthApi.authentiate(subtitle: dg.useLocalAuth);
            setState(() => _isLoading = false);
          },
          icon: const Icon(Icons.fingerprint_rounded),
          label: Text(dg.biometrics),
        ),
        SizedBox(height: size.height * 0.15),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1,
            vertical: size.height * 0.01,
          ),
          child: Text(
            dg.signOutResetAll,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.035),
        ElevatedButton.icon(
          onPressed: () async {
            await showAlertDialog(
              title: " ${dg.settingsLogout}",
              description: dg.dialogLogoutBody,
              yesOption: dg.dialogYes,
              noOption: dg.dialogNo,
              onYes: () {
                deletePrefs().then(
                  (value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const CredentialsScreen()),
                    (route) => false,
                  ),
                );
              },
              icon: Icons.warning_rounded,
              context: context,
            );
          },
          icon: const Icon(Icons.logout_rounded),
          label: Text(dg.settingsLogout),
        ),
      ],
    );
  }
}
