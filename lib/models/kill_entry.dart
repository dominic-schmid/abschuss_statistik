import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:jagdverband_scraper/utils/utils.dart';

class KillEntry {
  final int nummer;
  final String wildart;
  final String geschlecht;
  final String hegeinGebietRevierteil;

  final String alter;
  final String alterw;
  final double? gewicht;
  final String erleger;
  final String begleiter;
  final String ursache;
  final String verwendung;
  final String ursprungszeichen;
  final String oertlichkeit;
  final Map<String, String>? jagdaufseher;
  DateTime datetime = DateTime.now();
  IconData icon = Icons.question_mark;
  Color color = Colors.grey;

  KillEntry({
    required this.nummer,
    required this.wildart,
    required this.geschlecht,
    required this.datetime,
    required this.ursache,
    required this.verwendung,
    required this.oertlichkeit,
    this.hegeinGebietRevierteil = "",
    this.alter = "",
    this.alterw = "",
    this.gewicht = 0.0,
    this.erleger = "",
    this.begleiter = "",
    this.ursprungszeichen = "",
    this.jagdaufseher,
  }) {
    icon = getUrsacheIcon(ursache);
    color = getColorFromWildart(wildart);
  }

  static Color getColorFromWildart(String wildart) {
    Color color = Colors.green;
    switch (wildart) {
      case 'Rehwild':
        color = rehwildFarbe;
        break;
      case 'Rotwild':
        color = rotwildFarbe;
        break;
      case 'Gamswild':
        color = gamswildFarbe;
        break;
      case 'Steinwild':
        color = steinwildFarbe;
        break;
      case 'Schwarzwild':
        color = schwarzwildFarbe;
        break;
      case 'Spielhahn':
        color = spielhahnFarbe;
        break;
      case 'Steinhuhn':
        color = steinhuhnFarbe;
        break;
      case 'Schneehuhn':
        color = schneehuhnFarbe;
        break;
      case 'Murmeltier':
        color = murmeltierFarbe;
        break;
      case 'Dachs':
        color = dachsFarbe;
        break;
      case 'Fuchs':
        color = fuchsFarbe;
        break;
      case 'Schneehase':
        color = schneehaseFarbe;
        break;
      case 'Andere Wildart':
        color = wildFarbe;
        break;
    }
    return color;
  }

  String get key =>
      "$nummer$wildart$geschlecht${datetime.toIso8601String()}$ursache$verwendung$oertlichkeit$hegeinGebietRevierteil$alter$alterw$gewicht$erleger$begleiter$ursprungszeichen${jagdaufseher == null ? null : jagdaufseher!.values.toString()}";
  // Return an improved search string
  String _r(String s) => s
      .toLowerCase()
      .trim()
      .replaceAll('ä', 'a')
      .replaceAll('ö', 'o')
      .replaceAll('ü', 'u')
      .replaceAll('ß', 's');

  bool contains(String q) {
    q = _r(q);
    return _r(wildart).contains(q) ||
        _r(geschlecht).contains(q) ||
        _r(oertlichkeit).contains(q) ||
        _r(verwendung).contains(q) ||
        _r(ursache).contains(q) ||
        _r(datetime.toString()).contains(q) ||
        _r(gewicht.toString()).contains(q) ||
        _r(alter).contains(q) ||
        _r(alterw).contains(q);
  }

  static KillEntry? fromEntry(dom.Element e) {
    try {
      var cols = e.querySelectorAll('td');

      String datum = cols.elementAt(4).text.substring(0, 10);
      String zeit = cols.elementAt(4).querySelector('small')!.text;

      int yy = int.parse(datum.substring(6));
      int mo = int.parse(datum.substring(3, 5));
      int dd = int.parse(datum.substring(0, 2));
      int hh24 = int.parse(zeit.substring(0, 2));
      int mi = int.parse(zeit.substring(3));
      DateTime datetime = DateTime(yy, mo, dd, hh24, mi);

      return KillEntry(
        nummer: int.parse(cols.elementAt(0).text), // Nummer
        wildart: cols.elementAt(1).text, // Wildart
        geschlecht: cols.elementAt(2).text, // Geschlecht
        datetime: datetime,
        ursache: cols.elementAt(10).text, // Ursache
        verwendung: cols.elementAt(11).text, // Verwendung
        oertlichkeit: cols
            .elementAt(13)
            .text
            .replaceFirst('Auf Karte anzeigen', ''), // Örtlichkeit
        hegeinGebietRevierteil: cols.elementAt(3).text,
        alter: cols.elementAt(5).text,
        alterw: cols.elementAt(6).text,
        gewicht: double.tryParse(cols.elementAt(7).text),
        erleger: cols.elementAt(8).text,
        begleiter: cols.elementAt(9).text,
        ursprungszeichen: cols.elementAt(12).text,
        jagdaufseher: cols.elementAt(14).text.length > 20
            ? {
                'datum': cols.elementAt(14).text.substring(0, 10),
                'zeit': cols.elementAt(14).text.substring(11, 19),
                'aufseher': cols.elementAt(14).text.substring(19),
              }
            : null,
        // Oertlichkeit
      );
    } catch (e) {
      print(e.toString());
    }
  }

  static KillEntry? fromMap(Map<String, Object?> map) {
    Map<String, Object?> m = Map.from(map); // Copy map since db is read only

    return KillEntry(
      nummer: m['nummer'] as int, // Nummer
      wildart: m['wildart'] as String, // Wildart
      geschlecht: m['geschlecht'] as String, // Geschlecht
      datetime: DateTime.parse(m['datetime'] as String),
      ursache: m['ursache'] as String, // Ursache
      verwendung: m['verwendung'] as String, // Verwendung
      oertlichkeit: m['oertlichkeit'] as String, // Örtlichkeit
      hegeinGebietRevierteil: m['hegeinGebietRevierteil'] as String,
      alter: m['alterm'] as String,
      alterw: m['alterw'] as String,
      gewicht: m['gewicht'] as double?,
      erleger: m['erleger'] as String,
      begleiter: m['begleiter'] as String,
      ursprungszeichen: m['ursprungszeichen'] as String,
      jagdaufseher: m['aufseher'] == null
          ? null
          : {
              'datum': m['aufseherDatum'] as String,
              'zeit': m['aufseherZeit'] as String,
              'aufseher': m['aufseher'] as String,
            },
      // Oertlichkeit
    );
  }

  @override
  String toString() {
    String datum = DateFormat('dd.MM.yy').format(datetime);
    String zeit = DateFormat('kk:mm').format(datetime);
    String alterString = alter.isNotEmpty && alterw.isEmpty
        ? alter
        : alter.isEmpty && alterw.isNotEmpty
            ? alterw
            : alter.isNotEmpty && alterw.isNotEmpty
                ? '$alter - $alterw'
                : "";
    alterString = alterString.trim();

    String aufseherString = jagdaufseher == null
        ? ''
        : "Gesehen von ${jagdaufseher!['aufseher']} am ${jagdaufseher!['datum']} um ${jagdaufseher!['zeit']}";

    return "$wildart $geschlecht,\ngeschossen $oertlichkeit am $datum um $zeit\n\nNummer: $nummer${hegeinGebietRevierteil.isEmpty ? '' : '\nGebiet: $hegeinGebietRevierteil'}${alterString.isEmpty ? '' : '\nAlter: $alterString'}${gewicht == null ? '' : '\nGewicht: $gewicht kg'}${erleger.isEmpty || erleger.contains('*') ? '' : '\nErleger: $erleger'}${begleiter.isEmpty || begleiter.contains('*') ? '' : '\nBegleiter: $begleiter'}${verwendung.isEmpty ? '' : '\nVerwendung: $verwendung'}${ursprungszeichen.isEmpty ? '' : '\nUrsprungszeichen: $ursprungszeichen'}${aufseherString.isEmpty ? '' : '\n$aufseherString'}"; //${} ${} ${} ${} ${} ${} ${} ${}""";
  }
}
