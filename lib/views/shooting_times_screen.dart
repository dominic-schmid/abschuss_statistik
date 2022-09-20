import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/shooting_time.dart';
import 'package:jagdstatistik/providers/pref_provider.dart';
import 'package:jagdstatistik/utils/constants.dart';
import 'package:jagdstatistik/utils/database_methods.dart';
import 'package:jagdstatistik/utils/request_methods.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/add_kill/add_map_coordinates.dart';
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

  final ValueNotifier<bool?> _isBetween = ValueNotifier(null);

  final TextStyle ts = const TextStyle(fontSize: 26, fontWeight: FontWeight.w400);
  final TextStyle tl = const TextStyle(fontSize: 44, fontWeight: FontWeight.w600);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialOffset);
  }

  Future<void> _updateCoords() async {
    final prefProvider = Provider.of<PrefProvider>(context, listen: false);
    final latLng = prefProvider.shootingLatLng;

    LatLng? newLatLng = await Navigator.of(context).push(
      MaterialPageRoute<LatLng>(
        builder: (context) => AddMapCoordsScreen(
          initCoords: latLng ?? Constants.bolzanoCoords,
          zoom: latLng == null ? 10 : 12.5,
        ),
      ), // Bolzano default
    );

    if (newLatLng != null) {
      print('NewLatLng: %$newLatLng');
      if (!mounted) return;
      await prefProvider.get.setDouble('shootingTimeLat', newLatLng.latitude);
      await prefProvider.get.setDouble('shootingTimeLon', newLatLng.longitude);
      prefProvider.update();
      _showToday();
    }
  }

  Future<void> _showToday() async {
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
            onPressed: _showToday,
            icon: const Icon(Icons.today_rounded),
          ),
          IconButton(
            onPressed: () => _updateCoords(),
            icon: const Icon(Icons.map_rounded),
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
                itemBuilder: (context, index) {
                  final prefProvider = Provider.of<PrefProvider>(context);
                  double? lat = prefProvider.get.getDouble('shootingTimeLat');
                  double? lon = prefProvider.get.getDouble('shootingTimeLon');
                  LatLng? latLng = lat != null && lon != null ? LatLng(lat, lon) : null;

                  final selectedDate = DateTime.now().add(
                    Duration(days: index - _initialOffset),
                  );

                  return FutureBuilder<ShootingTime?>(
                      future: ShootingTimeApi.getFor(latLng, selectedDate),
                      builder: (context, snap) {
                        bool isLoading = snap.connectionState != ConnectionState.done;

                        if (!snap.hasData && !isLoading) {
                          _isBetween.value = null;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NoDataFoundWidget(suffix: dg.ortFestlegen),
                                ElevatedButton.icon(
                                  onPressed: () => _updateCoords(),
                                  icon: const Icon(Icons.settings_rounded),
                                  label: Text(dg.jetztFestlegen),
                                ),
                              ],
                            ),
                          );
                        }

                        ShootingTime? sTime = snap.data;
                        if (!isLoading && sTime != null) {
                          // delay so both builders arent being built at the same time..
                          Future.delayed(const Duration(milliseconds: 250)).then(
                            (value) => _isBetween.value =
                                DateTime.now().isAfter(sTime.from) &&
                                    DateTime.now().isBefore(sTime.until),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Text(
                                DateFormat.yMd().format(selectedDate),
                                style: ts,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                isLoading || sTime == null
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: rehwildFarbe,
                                        ),
                                      )
                                    : Flexible(
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
                                isLoading || sTime == null
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: rehwildFarbe,
                                        ),
                                      )
                                    : Flexible(
                                        child: Text(
                                          ShootingTime.format(sTime.sunset),
                                          style: ts,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              ],
                            ),
                            Visibility(
                              visible: !isLoading,
                              child: Text(
                                sTime.toString(),
                                style: tl,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      });
                }),
          ),
          Flexible(
            child: ValueListenableBuilder<bool?>(
                valueListenable: _isBetween,
                builder: (context, value, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Icon(
                      _isBetween.value == true
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                      key: _isBetween.value == true
                          ? const Key('checkIconShootingTime')
                          : const Key('closeIconShootingTime'),
                      size: 44,
                      color: _isBetween.value == true
                          ? rehwildFarbe
                          : _isBetween.value == false
                              ? rotwildFarbe
                              : secondaryColor,
                    ),
                  );
                }),
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
                style: TextStyle(
                  color: secondaryColor,
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
}
