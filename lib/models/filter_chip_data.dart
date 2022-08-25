import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/constants/cause.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/models/constants/usage.dart';

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
  int get hashCode => super.hashCode + Object.hash(label, '');

  static List<FilterChipData> allUrsache = Cause.all
      .map((e) => FilterChipData(label: e.cause, color: e.color, icon: e.icon))
      .toList();

  static List<FilterChipData> allWild =
      GameType.all.map((e) => FilterChipData(label: e.wildart, color: e.color)).toList();

  static List<FilterChipData> allVerwendung =
      Usage.all.map((e) => FilterChipData(label: e.usage, color: e.color)).toList();

  @override
  String toString() {
    return '$label ($color) isSelected: $isSelected';
  }
}
