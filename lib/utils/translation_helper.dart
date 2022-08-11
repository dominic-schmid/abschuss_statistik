import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';

const languages = {
  "en": {"name": "English", "nativeName": "English"},
  "de": {"name": "German", "nativeName": "Deutsch"},
  "it": {"name": "Italian", "nativeName": "Italiano"}
};

// Translate some of the values the page is going to return
String translateSex(BuildContext context, String sex) {
  final dg = S.of(context);
  switch (sex) {
    default:
      return sex;
  }
}

String translateValue(BuildContext ctx, String label) {
  final dg = S.of(ctx);
  switch (label) {
    // GAME TYPES
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
    // CAUSES
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
    // USAGES
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
    // SEXES
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
    // DEFAULT
    default:
      return label;
  }
}
