import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/utils.dart';

class GameType {
  final String wildart;
  final List<String> geschlechter;
  final double bitmapDescriptor;
  final Color color;

  const GameType({
    required this.wildart,
    required this.geschlechter,
    required this.bitmapDescriptor,
    required this.color,
  });

  static String translate(BuildContext ctx, String wildart, [bool forceReturn = true]) {
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

  static String translateGeschlecht(BuildContext ctx, String geschlecht,
      [bool forceReturn = true]) {
    final dg = S.of(ctx);
    switch (geschlecht) {
      case 'Gamsgeiß':
        return dg.gamsgeiss;
      case 'T-Bock':
        return dg.tBock;
      case 'Bockkitz':
        return dg.bockkitz;
      case 'Gamsbock':
        return dg.gamsbock;
      case 'Altgeiß':
        return dg.altgeiss;
      case 'Jährlingshirsch':
        return dg.jahrlingsHirsch;
      case 'Schmalreh':
        return dg.schmalreh;
      case 'Jährlingsbock':
        return dg.jahrlingsbock;
      case 'Bockjährling':
        return dg.bockjahrling;
      case 'Geißkitz':
        return dg.geisskitz;
      case 'Geißjährling':
        return dg.geissjahrling;
      case 'Wildkalb':
        return dg.wildkalb;
      case 'Männlich':
        return dg.maennlich;
      case 'Weiblich':
        return dg.weiblich;
      case 'männlich':
        return dg.maennlich;
      case 'weiblich':
        return dg.weiblich;
      case 'Hirschkalb':
        return dg.hirschkalb;
      case 'Trophäenhirsch':
        return dg.trophaehenHirsch;
      case 'Alttier':
        return dg.alttier;
      case 'M':
        return dg.M;
      case 'W':
        return dg.W;
      case 'nicht bekannt':
        return dg.nichtBekannt;
      case 'Frischling':
        return dg.frischling;
      case 'Überläuferbache':
        return dg.ueberlaeuferBache;
      case 'Überläuferkeiler':
        return dg.ueberlaeuferKeiler;
      case 'Keiler':
        return dg.keiler;
      case 'Bache':
        return dg.bache;
      case 'Steingeiß':
        return dg.steingeiss;
      case 'Steinbock':
        return dg.steinbock;
      case 'Gamsjahrlinge':
        return dg.gamsjahrlinge;
      case 'Schmaltier':
        return dg.schmaltier;
      case 'Kahlwild':
        return dg.kahlwild;
      case 'Weibliche Rehe':
        return dg.weiblicheRehe;

      default:
        return forceReturn ? geschlecht : "";
    }
  }

  static List<GameType> all = [
    const GameType(
      wildart: "Rehwild",
      geschlechter: [
        "Geißkitz",
        "Schmalreh",
        "Altgeiß",
        "Bockkitz",
        "Jährlingsbock",
        "T-Bock",
        "nicht bekannt",
        "Weibliche Rehe",
      ],
      bitmapDescriptor: BitmapDescriptor.hueGreen,
      color: rehwildFarbe,
    ),
    const GameType(
      wildart: "Rotwild",
      geschlechter: [
        "Jährlingshirsch",
        "Trophäenhirsch",
        "Hirschkalb",
        "Wildkalb",
        "Schmaltier",
        "Alttier",
        "nicht bekannt",
        "Kahlwild",
      ],
      bitmapDescriptor: BitmapDescriptor.hueRed,
      color: rotwildFarbe,
    ),
    const GameType(
      wildart: "Gamswild",
      geschlechter: [
        "Bockjährling",
        "Geißjährling",
        "Gamsgeiß",
        "Gamsbock",
        "Bockkitz",
        "Geißkitz",
        "nicht bekannt",
      ],
      bitmapDescriptor: BitmapDescriptor.hueCyan,
      color: gamswildFarbe,
    ),
    const GameType(
      wildart: "Steinwild",
      geschlechter: [
        "Bockjährling",
        "Geißjährling",
        "Steingeiß",
        "Steinbock",
        "Bockkitz",
        "Geißkitz",
        "nicht bekannt",
        "Gamsjahrlinge",
      ],
      bitmapDescriptor: BitmapDescriptor.hueYellow,
      color: steinwildFarbe,
    ),
    const GameType(
      wildart: "Schwarzwild",
      geschlechter: [
        "Frischling",
        "Überläuferbache",
        "Überläuferkeiler",
        "Keiler",
        "Bache",
        "nicht bekannt",
      ],
      bitmapDescriptor: BitmapDescriptor.hueYellow,
      color: schwarzwildFarbe,
    ),
    const GameType(
      wildart: "Spielhahn",
      geschlechter: ["nicht bekannt", "M"],
      bitmapDescriptor: BitmapDescriptor.hueOrange,
      color: spielhahnFarbe,
    ),
    const GameType(
      wildart: "Steinhuhn",
      geschlechter: ["nicht bekannt", "M", "W"],
      bitmapDescriptor: BitmapDescriptor.hueAzure,
      color: steinhuhnFarbe,
    ),
    const GameType(
      wildart: "Schneehuhn",
      geschlechter: ["nicht bekannt", "M", "W"],
      bitmapDescriptor: BitmapDescriptor.hueViolet,
      color: schneehuhnFarbe,
    ),
    const GameType(
      wildart: "Murmeltier",
      geschlechter: ["nicht bekannt", "M", "W"],
      bitmapDescriptor: BitmapDescriptor.hueRose,
      color: murmeltierFarbe,
    ),
    const GameType(
      wildart: "Dachs",
      geschlechter: ["nicht bekannt", "M", "W"],
      bitmapDescriptor: BitmapDescriptor.hueYellow,
      color: dachsFarbe,
    ),
    const GameType(
      wildart: "Fuchs",
      geschlechter: ["nicht bekannt", "M", "W"],
      bitmapDescriptor: BitmapDescriptor.hueOrange,
      color: fuchsFarbe,
    ),
    const GameType(
      wildart: "Schneehase",
      geschlechter: ["nicht bekannt", "männlich", "weiblich"],
      bitmapDescriptor: BitmapDescriptor.hueViolet,
      color: schneehaseFarbe,
    ),
    const GameType(
      wildart: "Andere Wildart",
      geschlechter: ["nicht bekannt", "männlich", "weiblich"],
      bitmapDescriptor: BitmapDescriptor.hueBlue,
      color: wildFarbe,
    ),
  ];
}
