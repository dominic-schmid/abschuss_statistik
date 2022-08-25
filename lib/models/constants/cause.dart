import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/utils.dart';

class Cause {
  final String cause;
  final IconData icon;
  final Color color;

  const Cause({
    required this.cause,
    required this.icon,
    required this.color,
  });

  static String translate(BuildContext ctx, String cause, [bool forceReturn = true]) {
    final dg = S.of(ctx);
    switch (cause) {
      case 'erlegt':
        return dg.erlegt;
      case 'Fallwild':
        return dg.fallwild;
      case 'Hegeabschuss':
        return dg.hegeabschuss;
      case 'Straßenunfall':
        return dg.strassenunfall;
      case 'Protokoll / beschlagnahmt':
        return dg.protokollBeschlagnahmt;
      case 'vom zug überfahren':
        return dg.vomZug;
      case 'Freizone':
        return dg.freizone;
      default:
        return forceReturn ? cause : "";
    }
  }

  static List<Cause> all = [
    const Cause(cause: "erlegt", icon: Icons.person, color: erlegtFarbe),
    const Cause(cause: "Fallwild", icon: Icons.cloudy_snowing, color: fallwildFarbe),
    const Cause(
      cause: "Straßenunfall",
      icon: Icons.car_crash,
      color: strassenunfallFarbe,
    ),
    const Cause(
      cause: "Hegeabschuss",
      icon: Icons.admin_panel_settings_outlined,
      color: hegeabschussFarbe,
    ),
    const Cause(
      cause: "Protokoll / beschlagnahmt",
      icon: Icons.list_alt,
      color: protokollFarbe,
    ),
    const Cause(cause: "vom Zug überfahren", icon: Icons.train, color: zugFarbe),
    const Cause(cause: "Freizone", icon: Icons.forest, color: freizoneFarbe),
  ];
}
