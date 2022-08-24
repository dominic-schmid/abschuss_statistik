class HuntingTimeCollection {
  final int year;
  final List<HuntingTime> huntingTimes = [];

  // On constructor call, initialize hunting Times for all possible combinations
  // TODO create this combination map somewhere
  HuntingTimeCollection(this.year) {
    Map<String, List<String>> wildartenGeschlechter = {
      'Rehwild': ['Geißkitz', 'Schmalreh', 'Altgeiß', 'Bockkitz'],
      'Rotwild': ['Jährlingshirsch', 'Trophäenhirsch', 'Hirschkalb', 'Wildkalb'],
      'Fuchs': [''],
    };
    wildartenGeschlechter.forEach((wildart, geschlechter) {
      for (String geschlecht in geschlechter) {
        HuntingTime? time = _getFor(wildart: wildart, geschlecht: geschlecht);
        if (time != null) huntingTimes.add(time);
      }
    });

    // TODO sort within wildart group from von ascending
  }

  HuntingTime? _getFor({required String wildart, required String geschlecht}) {
    DateTime? von, bis;
    switch (wildart) {
      case 'Rehwild':
        switch (geschlecht) {
          case 'Geißkitz':
            von = DateTime(year, 9, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Schmalreh':
            von = DateTime(year, 5, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Altgeiß':
            von = DateTime(year, 5, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Bockkitz':
            von = DateTime(year, 9, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Jährlingsbock':
            von = DateTime(year, 5, 1);
            bis = DateTime(year, 10, 20);
            break;
          case 'T-Bock':
            von = DateTime(year, 6, 15);
            bis = DateTime(year, 10, 20);
            break;
          case 'nicht bekannt':
            von = DateTime(year, 5, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Weibliche Rehe': // TODO check if this is "führende Gaisen"?
            von = DateTime(year, 9, 1);
            bis = DateTime(year, 12, 15);
            break;
        }
        break;
      case 'Rotwild':
        switch (geschlecht) {
          case 'Jährlingshirsch':
            von = DateTime(year, 5, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Trophäenhirsch':
            von = DateTime(year, 8, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Hirschkalb':
            von = DateTime(year, 8, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Wildkalb':
            von = DateTime(year, 8, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Schmaltier':
            von = DateTime(year, 5, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Alttier':
            von = DateTime(year, 5, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'nicht bekannt':
            von = DateTime(year, 5, 1);
            bis = DateTime(year, 12, 15);
            break;
          case 'Kahlwild':
            von = DateTime(year, 9, 1);
            bis = DateTime(year, 12, 15);
            break;
        }
        break;
      // case 'Gamswild':
      //   return dg.gamswild;
      // case 'Steinwild':
      //   return dg.steinwild;
      // case 'Schwarzwild':
      //   return dg.schwarzwild;
      // case 'Spielhahn':
      //   return dg.spielhahn;
      // case 'Steinhuhn':
      //   return dg.steinhuhn;
      // case 'Schneehuhn':
      //   return dg.schneehuhn;
      // case 'Murmeltier':
      //   return dg.murmeltier;
      // case 'Dachs':
      //   return dg.dachs;
      case 'Fuchs': // For fox - doesn't matter whether M or F
        var initial = DateTime(year, DateTime.september, 1);
        // Get first Sunday in September
        while (initial.weekday != DateTime.sunday) {
          initial = initial.add(const Duration(days: 1));
        }
        // First Sunday + 2 Sundays = Third Sunday of September
        var thirdSunday = initial.add(const Duration(days: DateTime.sunday * 2));
        assert(thirdSunday.month == DateTime.september);
        von = thirdSunday;
        bis = DateTime(year + 1, 1, 31); // 31st September next year
        break;
      // case 'Schneehase':
      //   return dg.schneehase;
      // case 'Andere Wildart':
      //   return dg.andereWildart;
    }
    return von == null || bis == null
        ? null
        : HuntingTime(wildart: wildart, geschlecht: geschlecht, von: von, bis: bis);
  }
}

class HuntingTime {
  final String wildart;
  final String geschlecht;
  final DateTime von;
  final DateTime bis;

  const HuntingTime({
    required this.wildart,
    required this.geschlecht,
    required this.von,
    required this.bis,
  });
}
