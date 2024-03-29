import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefProvider extends ChangeNotifier {
  final SharedPreferences _prefInstance;

  SharedPreferences get get => _prefInstance;

  bool get showPerson => _prefInstance.getBool('showPerson') ?? false;
  bool get betaMode => _prefInstance.getBool('betaMode') ?? false;
  bool? get localAuth => _prefInstance.getBool('localAuth');
  String get login => _prefInstance.getString('revierLogin') ?? "";
  String get password => _prefInstance.getString('revierPasswort') ?? "";
  LatLng? get latLng => _prefInstance.getDouble('defaultLat') != null &&
          _prefInstance.getDouble('defaultLng') != null
      ? LatLng(
          _prefInstance.getDouble('defaultLat')!,
          _prefInstance.getDouble('defaultLng')!,
        )
      : null;
  int get defaultYear =>
      _prefInstance.getInt('defaultYear') ?? DateTime.now().year;

  PrefProvider(this._prefInstance);

  Future<void> setLatLng(LatLng latLng) async {
    await _prefInstance.setDouble('defaultLat', latLng.latitude);
    await _prefInstance.setDouble('defaultLng', latLng.longitude);
    notifyListeners();
  }

  void setDefaultYear(int year) {
    _prefInstance.setInt('defaultYear', year);
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
