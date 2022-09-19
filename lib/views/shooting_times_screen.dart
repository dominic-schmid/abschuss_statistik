import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/constants.dart';
import 'package:jagdstatistik/utils/providers.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/add_kill/add_map_coordinates.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:jagdstatistik/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';

class ShootingTimesScreen extends StatefulWidget {
  const ShootingTimesScreen({Key? key}) : super(key: key);

  @override
  State<ShootingTimesScreen> createState() => _ShootingTimesScreenState();
}

class _ShootingTimesScreenState extends State<ShootingTimesScreen> {
  ShootingTime? shootingTime;

  DateTime? _dateTime;

  bool _isLoading = true;
  bool _isBetween = false;

  final TextStyle ts = const TextStyle(fontSize: 26, fontWeight: FontWeight.w400);
  final TextStyle tl = const TextStyle(fontSize: 44, fontWeight: FontWeight.w600);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshTimes();
    });
  }

  void _refreshTimes() async {
    final prefProvider = Provider.of<PrefProvider>(context, listen: false);
    double? lat = prefProvider.get.getDouble('shootingTimeLat');
    double? lon = prefProvider.get.getDouble('shootingTimeLon');
    if (lat != null && lon != null) {
      shootingTime =
          await ShootingTimeApi.forDate(latLng: LatLng(lat, lon), day: _dateTime);

      // check if time is between current time -> still shootable
      _isBetween = DateTime.now().isAfter(shootingTime!.from) &&
          DateTime.now().isBefore(shootingTime!.until);
      setState(() => _isLoading = false);
    }
  }

  void _updateCoords() async {
    final prefProvider = Provider.of<PrefProvider>(context, listen: false);
    double? lat = prefProvider.get.getDouble('shootingTimeLat');
    double? lon = prefProvider.get.getDouble('shootingTimeLon');

    LatLng? newLatLng = await Navigator.of(context).push(
      MaterialPageRoute<LatLng>(
        builder: (context) => AddMapCoordsScreen(
          initCoords:
              lat == null || lon == null ? Constants.bolzanoCoords : LatLng(lat, lon),
          zoom: lat == null || lon == null ? 10 : 15,
        ),
      ), // Bolzano default
    );

    if (newLatLng != null) {
      prefProvider.get.setDouble('shootingTimeLat', newLatLng.latitude);
      prefProvider.get.setDouble('shootingTimeLon', newLatLng.longitude);
      prefProvider.update();
      setState(() => _isLoading = true);
      _refreshTimes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    final prefProvider = Provider.of<PrefProvider>(context);
    double? lat = prefProvider.get.getDouble('shootingTimeLat');
    double? lon = prefProvider.get.getDouble('shootingTimeLon');

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ChartAppBar(
        title: Text(dg.schusszeiten),
        actions: [
          IconButton(
            onPressed: () => _updateCoords(),
            icon: const Icon(
              Icons.map_rounded,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: lat == null || lon == null
              ? [
                  NoDataFoundWidget(suffix: dg.ortFestlegen),
                  ElevatedButton.icon(
                    onPressed: () => _updateCoords(),
                    icon: const Icon(Icons.settings_rounded),
                    label: Text(dg.jetztFestlegen),
                  ),
                ]
              : [
                  // TODO date picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: rehwildFarbe,
                              ),
                            )
                          : shootingTime == null
                              ? Text("?", style: ts)
                              : Flexible(
                                  child: Text(
                                    ShootingTime.format(shootingTime!.sunrise),
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
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: rehwildFarbe,
                              ),
                            )
                          : shootingTime == null
                              ? Text("?", style: ts)
                              : Flexible(
                                  child: Text(
                                    ShootingTime.format(shootingTime!.sunset),
                                    style: ts,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                    ],
                  ),

                  Visibility(
                      visible: !_isLoading,
                      child: Text(
                        shootingTime.toString(),
                        style: tl,
                        textAlign: TextAlign.center,
                      )),
                  Visibility(
                    visible: !_isLoading,
                    child: Icon(
                      _isBetween == true ? Icons.check_rounded : Icons.close_rounded,
                      size: 44,
                      color: _isBetween ? rehwildFarbe : rotwildFarbe,
                    ),
                  ),
                  Visibility(
                    visible: !_isLoading,
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
                ],
        ),
      ),
    );
  }
}

class ShootingTimeApi {
  //"https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400&date=2022-09-13";
  static String baseUrl = "https://api.sunrise-sunset.org/json?";

  static Future<ShootingTime?> forDate({required LatLng latLng, DateTime? day}) async {
    day = day ?? DateTime.now();

    final res = await Requests.get(
      baseUrl,
      queryParameters: {
        'lat': latLng.latitude,
        'lng': latLng.longitude,
        'date': DateFormat('yyyy-MM-dd').format(day),
        'formatted': 0, // force datetime to be in ISO
      },
      timeoutSeconds: 15,
    );

    print(res.json());
    try {
      return ShootingTime.fromMap(res.json());
    } catch (e) {
      print("Error parsing shooting time: ${e.toString()}");
      return null;
    }
  }
}

class ShootingTime {
  late DateTime sunrise;
  late DateTime sunset;

  ShootingTime(DateTime sunrise, DateTime sunset) {
    this.sunrise = DateTime.utc(
      sunrise.year,
      sunrise.month,
      sunrise.day,
      sunrise.hour,
      sunrise.minute,
      sunrise.second,
    ).toLocal();
    this.sunset = DateTime.utc(
      sunset.year,
      sunset.month,
      sunset.day,
      sunset.hour,
      sunset.minute,
      sunset.second,
    ).toLocal();
  }

  DateTime get from => sunrise.subtract(const Duration(hours: 1));
  DateTime get until => sunset.add(const Duration(hours: 1));

  @override
  String toString() {
    DateFormat df = DateFormat.Hm();
    return "${df.format(from)} - ${df.format(until)}";
  }

  static String format(DateTime dt) {
    DateFormat df = DateFormat.Hm();
    return df.format(dt);
  }

  static ShootingTime fromMap(Map<String, dynamic> map) {
    if (map["status"] != "OK") throw Exception("Error: Sunrise status not OK");

    DateTime sunrise = DateTime.parse(map["results"]["sunrise"]);
    DateTime sunset = DateTime.parse(map["results"]["sunset"]);
    return ShootingTime(sunrise, sunset);
  }
}
