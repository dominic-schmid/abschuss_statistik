import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/utils.dart';

class FilterChipData {
  final String label;
  final Color color;
  IconData? icon;
  bool isSelected;

  FilterChipData(
      {required this.label,
      required this.color,
      this.isSelected = true,
      this.icon});

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
    FilterChipData(
        label: 'erlegt', color: erlegtFarbe, icon: getUrsacheIcon('erlegt')),
    FilterChipData(
        label: 'Fallwild',
        color: fallwildFarbe,
        icon: getUrsacheIcon('Fallwild')),
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
        label: 'Freizone',
        color: freizoneFarbe,
        icon: getUrsacheIcon('Freizone')),
  ];

  static List<FilterChipData> allVerwendung = <FilterChipData>[
    FilterChipData(label: 'Eigengebrauch', color: eigengebrauchFarbe),
    FilterChipData(
        label: 'Eigengebrauch - Abgabe zur Weiterverarbeitung',
        color: weiterverarbeitungFarbe),
    FilterChipData(label: 'verkauf', color: verkaufFarbe),
    FilterChipData(label: 'nicht verwertbar', color: nichtVerwertbarFarbe),
    FilterChipData(
        label: 'nicht gefunden / Nachsuche erfolglos',
        color: nichtGefundenFarbe),
    FilterChipData(label: 'nicht bekannt', color: nichtBekanntFarbe),
  ];
}
