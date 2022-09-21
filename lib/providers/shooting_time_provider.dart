import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagdstatistik/models/shooting_time.dart';
import 'package:jagdstatistik/utils/request_methods.dart';

class ShootingTimeProvider extends ChangeNotifier {
  LatLng? _latLng;
  DateTime _day = DateTime.now();
  ShootingTime? _shootingTime;
  bool? _isBetween;

  DateTime get day => _day;
  ShootingTime? get shootingTime => _shootingTime;
  bool? get isBetween => _isBetween;
  LatLng? get latLng => _latLng;

  ShootingTimeProvider(this._latLng) {
    if (_latLng != null) setLatLng(_latLng!);
  }

  Future<void> setDay(DateTime newDay) async {
    _day = newDay;
    _shootingTime = await ShootingTimeApi.getFor(_latLng, newDay);
    if (_shootingTime != null) {
      _isBetween = DateTime.now().isAfter(_shootingTime!.from) &&
          DateTime.now().isBefore(_shootingTime!.until);
      if (DateTime.now().day == _day.day) _isBetween = true;
    }

    notifyListeners();
  }

  Future<void> setLatLng(LatLng latLng) async {
    _latLng = latLng;
    _shootingTime = await ShootingTimeApi.getFor(_latLng, DateTime.now());
    if (_shootingTime != null) {
      _isBetween = DateTime.now().isAfter(_shootingTime!.from) &&
          DateTime.now().isBefore(_shootingTime!.until);
      if (DateTime.now().day == _day.day) _isBetween = true;
    }
    notifyListeners();
  }

  // Future<ShootingTime?> getFor(DateTime date){
  //   if(_shootingTime != null && DateFormat("yyyy-MM-dd").format(_shootingTime!.sunrise) == ""){
  //     return _shootingTime;
  //   }
  //   _shootingTime ?? ;

}
