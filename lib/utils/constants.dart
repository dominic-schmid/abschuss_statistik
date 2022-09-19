import 'package:google_maps_flutter/google_maps_flutter.dart';

/// This class contains constants that do not change to be used when loading data
/// e.g.  "Rehwild": ["Jährlingsbock", "Trophäenbock", ...]
class Constants {
  static const String appVersion = "1.3.0";
  static const List<String> ursachen = [
    'erlegt',
    'Fallwild',
    'Straßenunfall',
    'Hegeabschuss',
    'Protokoll / beschlagnahmt',
    'vom Zug überfahren',
    'Freizone',
  ];

  static const bolzanoCoords = LatLng(46.500000, 11.350000);
}
