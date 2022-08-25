import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';

class HuntingTime {
  final String wildart;
  final String geschlecht;
  final DateTime von;
  final DateTime bis;
  final String? note;
  late bool open;

  HuntingTime({
    required this.wildart,
    this.geschlecht = "",
    required this.von,
    required this.bis,
    this.note,
  }) {
    open = DateTime.now().isAfter(von) && DateTime.now().isBefore(bis);
  }

  String translateWildart(BuildContext ctx, [bool forceReturn = true]) {
    final dg = S.of(ctx);
    switch (wildart) {
      case 'Rehwild':
        return dg.rehwild;
      case 'Rotwild':
        return dg.rotwild;
      case 'Gamswild':
        return dg.gamswild;
      case 'Steinwild':
        return dg.steinwild;
      case 'Schwarzwild':
        return dg.schwarzwild;
      case 'Spielhahn':
        return dg.spielhahn;
      case 'Steinhuhn':
        return dg.steinhuhn;
      case 'Schneehuhn':
        return dg.schneehuhn;
      case 'Murmeltier':
        return dg.murmeltier;
      case 'Dachs':
        return dg.dachs;
      case 'Fuchs':
        return dg.fuchs;
      case 'Schneehase':
        return dg.schneehase;
      case 'Andere Wildart':
        return dg.andereWildart;
      default:
        return forceReturn ? wildart : "";
    }
  }

  String translateGeschlecht(BuildContext ctx) {
    final dg = S.of(ctx);
    switch (geschlecht) {
      //    "Rehwild": [
      //   "Jährlingsbock",
      //   "Trophäenbock",
      //   "Schmalgaisen",
      //   "Nicht führende Gaisen",
      //   "Führende Gaisen",
      //   "Kitze"
      // ],
      // "Rotwild": [
      //   "Jährlingshirsch",
      //   "Trophäenhirsch",
      //   "Schmaltiere",
      //   "Nicht führende Tiere",
      //   "Führende Tiere",
      //   "Kälber"
      // ],
      // "Gamswild": ["Gamsbock", "Gamsgais (auch mit Kitz)", "Gamsjahrling"],
      // "Schwarzwild": [""],
      // "Damwild": [""],
      // "Muffelwild": [""],
      // "Fuchs": [""],
      // "Feldhase": [""],
      // "Schneehase": [""],
      // "Wildkaninchen": [""],
      // "Spielhahn, Steinhühner": [""],
      // "Schneehuhn": [""],
      // "Fasan, Ringeltaube, Waldschnepfe, Wachtel, Amsel, Aaskrähe, Eichelhäher, Elster, Blässhuhn, Stockente, Knäckente, Krickente":
      //     [""],
      // "Wacholderdrossel, Singdrossel": [""]
      case 'afwaqarKahlwild':
        return dg.kahlwild;
      case 'qhrqaehqehWeibliche Rehe':
        return dg.weiblicheRehe;
      default:
        return geschlecht;
    }
  }

  static List<HuntingTime> all(int year) => [
        HuntingTime(
          wildart: "Rehwild",
          geschlecht: "Jährlingsbock",
          von: DateTime(year, 5, 1),
          bis: DateTime(year, 10, 20),
        ),
        HuntingTime(
          wildart: "Rehwild",
          geschlecht: "Trophäenbock",
          von: DateTime(year, 6, 15),
          bis: DateTime(year, 10, 20),
        ),
        HuntingTime(
          wildart: "Rehwild",
          geschlecht: "Schmalgaisen",
          von: DateTime(year, 5, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Rehwild",
          geschlecht: "Nicht führende Gaisen",
          von: DateTime(year, 5, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Rehwild",
          geschlecht: "Führende Gaisen",
          von: DateTime(year, 9, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Rehwild",
          geschlecht: "Kitze",
          von: DateTime(year, 9, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Rotwild",
          geschlecht: "Jährlingshirsch",
          von: DateTime(year, 5, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Rotwild",
          geschlecht: "Trophäenhirsch",
          von: DateTime(year, 8, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Rotwild",
          geschlecht: "Schmaltiere",
          von: DateTime(year, 5, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
            wildart: "Rotwild",
            geschlecht: "Nicht führende Tiere",
            von: DateTime(year, 5, 1),
            bis: DateTime(year, 12, 15)),
        HuntingTime(
          wildart: "Rotwild",
          geschlecht: "Führende Tiere",
          von: DateTime(year, 8, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Rotwild",
          geschlecht: "Kälber",
          von: DateTime(year, 8, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Gamswild",
          geschlecht: "Gamsbock",
          von: DateTime(year, 8, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Gamswild",
          geschlecht: "Gamsgais (auch mit Kitz)",
          von: DateTime(year, 8, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Gamswild",
          geschlecht: "Gamsjahrling",
          von: DateTime(year, 8, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Schwarzwild",
          geschlecht: "",
          von: DateTime(year, 10, 1),
          bis: DateTime(year, 12, 30),
        ),
        HuntingTime(
          wildart: "Damwild",
          geschlecht: "",
          von: DateTime(year, 10, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Muffelwild",
          geschlecht: "",
          von: DateTime(year, 10, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Fuchs",
          geschlecht: "",
          von:
              _getXDayOfWeekIn(2022, weekday: DateTime.sunday, month: DateTime.september),
          bis: DateTime(year + 1, 1, 31), // 31st January next year
        ),
        HuntingTime(
          wildart: "Feldhase",
          geschlecht: "",
          von:
              _getXDayOfWeekIn(2022, weekday: DateTime.sunday, month: DateTime.september),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Schneehase",
          geschlecht: "",
          von: DateTime(year, 10, 1),
          bis: DateTime(year, 11, 30),
        ),
        HuntingTime(
          wildart: "Wildkaninchen",
          geschlecht: "",
          von: DateTime(year, 10, 1),
          bis: DateTime(year, 12, 31),
        ),
        HuntingTime(
          wildart: "Spielhahn, Steinhühner",
          geschlecht: "",
          von: DateTime(year, 10, 15),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Schneehuhn",
          geschlecht: "",
          von: DateTime(year, 10, 1),
          bis: DateTime(year, 11, 30),
        ),
        HuntingTime(
          wildart:
              "Fasan, Ringeltaube, Waldschnepfe, Wachtel, Amsel, Aaskrähe, Eichelhäher, Elster, Blässhuhn, Stockente, Knäckente, Krickente",
          geschlecht: "",
          von: DateTime(year, 10, 1),
          bis: DateTime(year, 12, 15),
        ),
        HuntingTime(
          wildart: "Wacholderdrossel, Singdrossel",
          geschlecht: "",
          von: DateTime(year, 10, 1),
          bis: DateTime(year, 12, 15),
          note:
              "bis zum 31.01. im Obst- und Weinbaugebiet, an nicht mehr als 3 Tagen pro Woche mit jagdverbot an jedem Dienstag und Freitag",
        ),
      ];

  static List<HuntingTime> matingTimes(int year, BuildContext ctx) {
    final dg = S.of(ctx);
    return [
      HuntingTime(
        wildart: "Auerhahn", // TODO translate
        von: DateTime(year, 3, 1),
        bis: DateTime(year, 5, 31),
        note: "4 ${dg.wochen} ${dg.brutzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Birkwild", // TODO translate
        von: DateTime(year, 4, 1),
        bis: DateTime(year, 6, 31),
        note: "40 ${dg.wochen} ${dg.brutzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Dachs",
        von: DateTime(year, 7, 1),
        bis: DateTime(year, 8, 31),
        note: "9 ${dg.monate} ${dg.tragzeit} (${dg.mitKeimruhe})", // TODO translate
      ),
      HuntingTime(
        wildart: "Feldhase",
        von: DateTime(year, 12, 1),
        bis: DateTime(year + 1, 8, 31),
        note: "10 ${dg.tage} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Fuchs",
        von: DateTime(year, 1, 1),
        bis: DateTime(year, 2, 28),
        note: "53 ${dg.tage} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Gamswild",
        von: DateTime(year, 10, 1),
        bis: DateTime(year, 11, 30),
        note: "26 ${dg.wochen} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Hermelin",
        von: DateTime(year, 2, 1),
        bis: DateTime(year, 3, 31),
        note: "7-12 ${dg.monate} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Rotwild",
        von: DateTime(year, 9, 1),
        bis: DateTime(year, 10, 31),
        note: "9 ${dg.monate} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Luchs",
        geschlecht: "Schmaltiere",
        von: DateTime(year, 3, 1),
        bis: DateTime(year, 4, 30),
        note: "65-75 ${dg.tage} ${dg.tragzeit}",
      ),
      HuntingTime(
        wildart: "Muffelwild",
        von: DateTime(year, 11, 1),
        bis: DateTime(year, 12, 31),
        note: "5,5 ${dg.monate} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Murmeltier",
        von: DateTime(year, 5, 1),
        bis: DateTime(year, 5, 31),
        note: "5 ${dg.wochen} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Rehwild",
        von: DateTime(year, 7, 15),
        bis: DateTime(year, 8, 31),
        note: "40 ${dg.wochen} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Schneehase",
        von: DateTime(year, 1, 1),
        bis: DateTime(year, 9, 30),
        note: "50 ${dg.tage} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Steinbock",
        von: DateTime(year, 11, 1),
        bis: DateTime(year + 1, 1, 15),
        note: "23 ${dg.wochen} ${dg.tragzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Steinhuhn",
        von: DateTime(year, 3, 1),
        bis: DateTime(year, 5, 31),
        note: "24-26 ${dg.tage} ${dg.brutzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Schneehuhn",
        von: DateTime(year, 4, 1),
        bis: DateTime(year, 6, 30),
        note: "2,5 ${dg.wochen} ${dg.brutzeit}", // TODO translate
      ),
      HuntingTime(
        wildart: "Steinmarder, Edelmarder",
        von: DateTime(year, 6, 1),
        bis: DateTime(year, 8, 31),
        note: "9 ${dg.monate} ${dg.tragzeit} (${dg.mitKeimruhe})", // TODO translate
      ),
      HuntingTime(
        wildart: "Wildschwein",
        von: DateTime(year, 11, 1),
        bis: DateTime(year, 12, 31),
        note: "4 ${dg.monate} ${dg.tragzeit}", // TODO translate
      ),
    ];
  }

  static DateTime _getXDayOfWeekIn(
    int year, {
    int weekday = DateTime.sunday,
    int month = DateTime.september,
  }) {
    var initial = DateTime(year, DateTime.september, 1);
    // Get first Sunday in September
    while (initial.weekday != DateTime.sunday) {
      initial = initial.add(const Duration(days: 1));
    }
    // First Sunday + 2 Sundays = Third Sunday of September
    var thirdSunday = initial.add(const Duration(days: DateTime.sunday * 2));
    assert(thirdSunday.month == DateTime.september);
    return thirdSunday;
  }
}
