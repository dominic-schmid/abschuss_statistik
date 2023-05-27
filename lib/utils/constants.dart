import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// This class contains constants that do not change to be used when loading data
/// e.g.  "Rehwild": ["Jährlingsbock", "Trophäenbock", ...]
class Constants {
  static const String appVersion = "1.4.0";
  static const String appLegalese = 'Dominic Schmid © 2022';
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

  static const ShapeBorder modalShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  );
}
