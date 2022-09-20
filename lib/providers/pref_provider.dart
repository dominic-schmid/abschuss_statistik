import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefProvider extends ChangeNotifier {
  SharedPreferences prefInstance;

  SharedPreferences get get => prefInstance;

  bool get showPerson => prefInstance.getBool('showPerson') ?? false;
  bool get betaMode => prefInstance.getBool('betaMode') ?? false;
  String get login => prefInstance.getString('revierLogin') ?? "";
  String get password => prefInstance.getString('revierPasswort') ?? "";
  LatLng? get shootingLatLng => prefInstance.getDouble('shootingTimeLat') != null &&
          prefInstance.getDouble('shootingTimeLon') != null
      ? LatLng(
          prefInstance.getDouble('shootingTimeLat')!,
          prefInstance.getDouble('shootingTimeLon')!,
        )
      : null;

  PrefProvider({required this.prefInstance});

  void update() {
    notifyListeners();
  }
}
