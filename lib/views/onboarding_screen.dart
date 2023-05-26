import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/providers/pref_provider.dart';
import 'package:jagdstatistik/utils/translation_helper.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/credentials_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    Size size = MediaQuery.of(context).size;
    final prefProvider = Provider.of<PrefProvider>(context);
    return OnBoardingSlider(
      imageVerticalOffset: size.height * 0.03,
      middle: Text(
        dg.appTitle,
        style: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
          fontSize: 22,
        ),
      ),
      //imageHorizontalOffset: size.width * 0.2,
      background: [
        Image.asset('assets/SJV-Logo.png', height: size.height * 0.4),
        Image.asset('assets/manager-tasks-t.png', height: size.height * 0.4),
        Image.asset('assets/people-charts.png', height: size.height * 0.5),
        Image.asset('assets/time-management.png', height: size.height * 0.5),
      ],
      skipTextButton: Text(
        dg.skip,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      //leading: Image.asset('assets/SJV-Logo-DEU.png', color: Colors.white),
      finishButtonText: dg.loslegen,
      headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pageBodies: [
        OnboardingDataItem(
          title: dg.appTitle,
          description: dg.sjvPublikation,
          trailing: ElevatedButton(
            onPressed: () async {
              await showLanguagePicker(context);
              setState(() {});
            },
            child: Text(
              languages[Intl.getCurrentLocale()]!['nativeName']!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        OnboardingDataItem(
          title: dg.yourTerritory,
          description: dg.onboardTerritoryDesc,
        ),
        OnboardingDataItem(
          title: dg.statistics,
          description: dg.onboardStatDesc,
          topFlex: 11,
        ),
        OnboardingDataItem(
          title: dg.jagdbegleiter,
          description: dg.onboardUtilDesc,
          topFlex: 11,
        ),
      ],
      speed: 1.5,
      totalPage: 4,
      onFinish: () async {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CredentialsScreen()),
        );
        await prefProvider.get.setBool('onboardingComplete', true);
      },
    );
  }
}

class OnboardingDataItem extends StatelessWidget {
  final String title;
  final String description;
  final int topFlex;
  final Widget? trailing;

  const OnboardingDataItem({
    Key? key,
    required this.title,
    required this.description,
    this.topFlex = 9,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: topFlex),
          Flexible(
            flex: 1,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            flex: 3,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(flex: 1),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
