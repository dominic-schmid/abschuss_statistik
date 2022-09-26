import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/shooting_time.dart';
import 'package:jagdstatistik/providers/shooting_time_provider.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/settings_screen.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:jagdstatistik/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

class ShootingTimesScreen extends StatefulWidget {
  const ShootingTimesScreen({Key? key}) : super(key: key);

  @override
  State<ShootingTimesScreen> createState() => _ShootingTimesScreenState();
}

class _ShootingTimesScreenState extends State<ShootingTimesScreen> {
  final int _initialOffset = DateTime.now()
      .difference(DateTime(DateTime.now().year))
      .inDays; // get start of year

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialOffset);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (await Connectivity().checkConnectivity().timeout(const Duration(seconds: 10)) ==
          ConnectivityResult.none) {
        final dg = S.of(context);
        showSnackBar(dg.noInternetError, context);
        return;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Update coordinate by pushing settings page and then the map and updating providers
  Future<void> _updateCoords() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(
            initStep: SettingsInitStep.setDefaultPos,
          ),
        ),
      );

  Future<void> _animateToToday() async {
    await _pageController.animateToPage(
      _initialOffset,
      duration: const Duration(milliseconds: 666),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ChartAppBar(
        title: Text(dg.schusszeiten),
        actions: [
          IconButton(
            onPressed: _animateToToday,
            icon: const Icon(Icons.today_rounded),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 5,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  final sTime = Provider.of<ShootingTimeProvider>(context, listen: false);
                  sTime.setDay(DateTime.now().add(
                    Duration(days: index - _initialOffset),
                  ));
                },
                itemBuilder: (context, index) {
                  final sTime = Provider.of<ShootingTimeProvider>(context);
                  if (sTime.latLng == null) return _notFound(dg.ortFestlegen);
                  if (sTime.shootingTime == null) _notFound(dg.noInternetError, false);

                  return ShootingTimeDayDisplay(
                    key: Key("sTime-${index.toString()}"),
                    sTime: sTime.shootingTime,
                    day: DateTime.now().add(
                      Duration(days: index - _initialOffset),
                    ),
                  );
                }),
          ),
          Flexible(
            child: Consumer<ShootingTimeProvider>(
              builder: (context, prov, child) {
                bool? between = prov.isBetween;
                return AnimatedSwitcher(
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    between == true ? Icons.check_rounded : Icons.close_rounded,
                    key: between == true
                        ? const Key('checkIconShootingTime')
                        : between == false
                            ? const Key('closeIconShootingTime')
                            : const Key('noIconShootingTime'),
                    size: 44,
                    color: between == true
                        ? rehwildFarbe
                        : between == false
                            ? rotwildFarbe
                            : Colors.transparent,
                  ),
                );
              },
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
                vertical: size.height * 0.015,
              ),
              child: Text(
                dg.timeInLocal,
                style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'OpenSans',
                  fontSize: 10,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notFound(String suffix, [bool showButton = true]) {
    final dg = S.of(context);
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NoDataFoundWidget(suffix: suffix),
          Visibility(
            visible: showButton,
            child: ElevatedButton.icon(
              onPressed: _updateCoords,
              icon: const Icon(Icons.settings_rounded),
              label: Text(dg.jetztFestlegen),
            ),
          ),
        ],
      ),
    );
  }
}

class ShootingTimeDayDisplay extends StatefulWidget {
  final ShootingTime? sTime;
  final DateTime day;

  const ShootingTimeDayDisplay({
    Key? key,
    required this.sTime,
    required this.day,
  }) : super(key: key);

  @override
  State<ShootingTimeDayDisplay> createState() => _ShootingTimeDayDisplayState();
}

class _ShootingTimeDayDisplayState extends State<ShootingTimeDayDisplay> {
  final TextStyle ts = const TextStyle(fontSize: 26, fontWeight: FontWeight.w400);
  final TextStyle tl = const TextStyle(fontSize: 44, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return widget.sTime == null ? _buildNullTime() : _buildShootingTime(widget.sTime!);
  }

  Widget _buildNullTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Text(
            DateFormat.yMd().format(widget.day),
            style: ts,
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Text(
                '-',
                style: ts,
                textAlign: TextAlign.center,
              ),
            ),
            const Flexible(
                child: Icon(
              Icons.sunny,
              size: 32,
              color: Colors.yellow,
            )),
            const Flexible(
                child: Icon(
              Icons.nightlight,
              size: 32,
              color: Colors.blueGrey,
            )),
            Flexible(
              child: Text(
                '-',
                style: ts,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Text(
          '',
          style: tl,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildShootingTime(ShootingTime sTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Text(
            DateFormat.yMd().format(widget.day),
            style: ts,
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Text(
                ShootingTime.format(sTime.sunrise),
                style: ts,
                textAlign: TextAlign.center,
              ),
            ),
            const Flexible(
                child: Icon(
              Icons.sunny,
              size: 32,
              color: Colors.yellow,
            )),
            const Flexible(
                child: Icon(
              Icons.nightlight,
              size: 32,
              color: Colors.blueGrey,
            )),
            Flexible(
              child: Text(
                ShootingTime.format(sTime.sunset),
                style: ts,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Text(
          sTime.toString(),
          style: tl,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
