import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/constants/cause.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/models/constants/usage.dart';

const languages = {
  "en": {"name": "English", "nativeName": "English"},
  "de": {"name": "German", "nativeName": "Deutsch"},
  "it": {"name": "Italian", "nativeName": "Italiano"}
};

/// Tries to translate a value by translating it to GameType, Cause, Usage
String translateValue(BuildContext ctx, String label) {
  return GameType.translate(ctx, label, false).isNotEmpty
      ? GameType.translate(ctx, label)
      : GameType.translateGeschlecht(ctx, label, false).isNotEmpty
          ? GameType.translateGeschlecht(ctx, label)
          : Cause.translate(ctx, label, false).isNotEmpty
              ? Cause.translate(ctx, label)
              : Usage.translate(ctx, label, false).isNotEmpty
                  ? Usage.translate(ctx, label)
                  : label;
}
