import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/utils.dart';

class Usage {
  final String usage;
  final Color color;

  const Usage({
    required this.usage,
    required this.color,
  });

  static String translate(BuildContext ctx, String usage, [bool forceReturn = true]) {
    final dg = S.of(ctx);
    switch (usage) {
      case 'Eigengebrauch':
        return dg.eigengebrauch;
      case 'Eigengebrauch - Abgabe zur Weiterverarbeitung':
        return dg.eigengebrauchAbgabe;
      case 'verkauf':
        return dg.verkauf;
      case 'nicht verwertbar':
        return dg.nichtVerwertbar;
      case 'nicht gefunden / Nachsuche erfolglos':
        return dg.nichtGefunden;
      case 'nicht bekannt':
        return dg.nichtBekannt;
      default:
        return forceReturn ? usage : "";
    }
  }

  static List<Usage> all = [
    const Usage(usage: "Eigengebrauch", color: eigengebrauchFarbe),
    const Usage(
        usage: "Eigengebrauch - Abgabe zur Weiterverarbeitung",
        color: weiterverarbeitungFarbe),
    const Usage(
      usage: "verkauf",
      color: verkaufFarbe,
    ),
    const Usage(
      usage: "nicht verwertbar",
      color: nichtVerwertbarFarbe,
    ),
    const Usage(
      usage: "nicht gefunden / Nachsuche erfolglos",
      color: nichtGefundenFarbe,
    ),
    const Usage(usage: "nicht bekannt", color: nichtBekanntFarbe),
  ];
}
