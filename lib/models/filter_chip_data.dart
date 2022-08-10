import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/generated/l10n.dart';
import 'package:jagdverband_scraper/utils/utils.dart';

class FilterChipData {
  final String label;
  final Color color;
  IconData? icon;
  bool isSelected;

  FilterChipData(
      {required this.label, required this.color, this.isSelected = true, this.icon});

  @override
  bool operator ==(dynamic other) =>
      other != null &&
      other is FilterChipData &&
      label == other.label &&
      isSelected == other.isSelected;
  //&& ascending == other.ascending;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode + Object.hash(label, '');

  // String display(BuildContext ctx) {
  //   final dg = S.of(ctx);
  //   switch (label) {
  //     case 'Rehwild':
  //       return dg.rehwild;
  //     case 'Rotwild':
  //       return dg.rotwild;
  //     case 'Gamswild':
  //       return dg.gamswild;
  //     case 'Steinwild':
  //       return dg.steinwild;
  //     case 'Schwarzwild':
  //       return dg.schwarzwild;
  //     case 'Spielhahn':
  //       return dg.spielhahn;
  //     case 'Steinhuhn':
  //       return dg.steinhuhn;
  //     case 'Schneehuhn':
  //       return dg.schneehuhn;
  //     case 'Murmeltier':
  //       return dg.murmeltier;
  //     case 'Dachs':
  //       return dg.dachs;
  //     case 'Fuchs':
  //       return dg.fuchs;
  //     case 'Schneehase':
  //       return dg.schneehase;
  //     case 'Andere Wildart':
  //       return dg.andereWildart;
  //     case 'erlegt':
  //       return dg.erlegt;
  //     case 'Fallwild':
  //       return dg.fallwild;
  //     case 'Hegeabschuss':
  //       return dg.hegeabschuss;
  //     case 'Straßenunfall':
  //       return dg.strassenunfall;
  //     case 'Protokoll / beschlagnahmt':
  //       return dg.protokollBeschlagnahmt;
  //     case 'vom zug überfahren':
  //       return dg.vomZug;
  //     case 'Freizone':
  //       return dg.freizone;
  //     case 'Eigengebrauch':
  //       return dg.eigengebrauch;
  //     case 'Eigengebrauch - Abgabe zur Weiterverarbeitung':
  //       return dg.eigengebrauchAbgabe;
  //     case 'verkauf':
  //       return dg.verkauf;
  //     case 'nicht verwertbar':
  //       return dg.nichtVerwertbar;
  //     case 'nicht gefunden / Nachsuche erfolglos':
  //       return dg.nichtGefunden;
  //     case 'nicht bekannt':
  //       return dg.nichtBekannt;
  //     default:
  //       return label;
  //   }
  // }

  static List<FilterChipData> allWild = <FilterChipData>[
    FilterChipData(label: 'Rehwild', color: rehwildFarbe),
    FilterChipData(label: 'Rotwild', color: rotwildFarbe),
    FilterChipData(label: 'Gamswild', color: gamswildFarbe),
    FilterChipData(label: 'Steinwild', color: steinwildFarbe),
    FilterChipData(label: 'Schwarzwild', color: schwarzwildFarbe),
    FilterChipData(label: 'Spielhahn', color: spielhahnFarbe),
    FilterChipData(label: 'Steinhuhn', color: steinhuhnFarbe),
    FilterChipData(label: 'Schneehuhn', color: schneehuhnFarbe),
    FilterChipData(label: 'Murmeltier', color: murmeltierFarbe),
    FilterChipData(label: 'Dachs', color: dachsFarbe),
    FilterChipData(label: 'Fuchs', color: fuchsFarbe),
    FilterChipData(label: 'Schneehase', color: schneehaseFarbe),
    FilterChipData(label: 'Andere Wildart', color: wildFarbe),
  ];

  static List<FilterChipData> allUrsache = <FilterChipData>[
    FilterChipData(label: 'erlegt', color: erlegtFarbe, icon: getUrsacheIcon('erlegt')),
    FilterChipData(
        label: 'Fallwild', color: fallwildFarbe, icon: getUrsacheIcon('Fallwild')),
    FilterChipData(
        label: 'Hegeabschuss',
        color: hegeabschussFarbe,
        icon: getUrsacheIcon('Hegeabschuss')),
    FilterChipData(
        label: 'Straßenunfall',
        color: strassenunfallFarbe,
        icon: getUrsacheIcon('Straßenunfall')),
    FilterChipData(
        label: 'Protokoll / beschlagnahmt',
        color: protokollFarbe,
        icon: getUrsacheIcon('Protokoll / beschlagnahmt')),
    FilterChipData(
        label: 'vom zug überfahren',
        color: zugFarbe,
        icon: getUrsacheIcon('vom zug überfahren')),
    FilterChipData(
        label: 'Freizone', color: freizoneFarbe, icon: getUrsacheIcon('Freizone')),
  ];

  static List<FilterChipData> allVerwendung = <FilterChipData>[
    FilterChipData(label: 'Eigengebrauch', color: eigengebrauchFarbe),
    FilterChipData(
        label: 'Eigengebrauch - Abgabe zur Weiterverarbeitung',
        color: weiterverarbeitungFarbe),
    FilterChipData(label: 'verkauf', color: verkaufFarbe),
    FilterChipData(label: 'nicht verwertbar', color: nichtVerwertbarFarbe),
    FilterChipData(
        label: 'nicht gefunden / Nachsuche erfolglos', color: nichtGefundenFarbe),
    FilterChipData(label: 'nicht bekannt', color: nichtBekanntFarbe),
  ];

  @override
  String toString() {
    return '$label ($color) isSelected: $isSelected';
  }
}
