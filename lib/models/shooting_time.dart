import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ShootingTime {
  final DateTime sunrise;
  final DateTime sunset;

  final LatLng latLng;

  const ShootingTime(this.latLng, this.sunrise, this.sunset);

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

  static ShootingTime fromMap(LatLng latLng, Map<String, dynamic> map) {
    if (map["status"] != "OK") throw Exception("Error: Sunrise status not OK");

    DateTime sunrise = DateTime.parse(map["results"]["sunrise"]);
    DateTime sunset = DateTime.parse(map["results"]["sunset"]);

    sunrise = DateTime.utc(
      sunrise.year,
      sunrise.month,
      sunrise.day,
      sunrise.hour,
      sunrise.minute,
      sunrise.second,
    ).toLocal();

    sunset = DateTime.utc(
      sunset.year,
      sunset.month,
      sunset.day,
      sunset.hour,
      sunset.minute,
      sunset.second,
    ).toLocal();

    return ShootingTime(latLng, sunrise, sunset);
  }
}
