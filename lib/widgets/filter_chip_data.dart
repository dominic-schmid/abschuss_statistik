import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/utils.dart';

class FilterChipData {
  final String label;
  final Color color;
  bool isSelected;

  FilterChipData(
      {required this.label, required this.color, this.isSelected = true});

  static List<FilterChipData> all = <FilterChipData>[
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
}
