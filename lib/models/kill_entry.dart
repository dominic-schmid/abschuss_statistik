import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:jagdverband_scraper/utils.dart';

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
  final String urpsrungszeichen;
  final String oertlichkeit;
  final Map<String, String>? jagdaufseher;
  DateTime datetime = DateTime.now();
  IconData icon = Icons.question_mark;
  Color color = Colors.grey;

  // DateTime parseDateTime(String d, String t) {
  //   int yy = int.parse(datum.substring(6));
  //   int mo = int.parse(datum.substring(3, 5));
  //   int dd = int.parse(datum.substring(0, 2));
  //   int hh24 = int.parse(zeit.substring(0, 2));
  //   int mi = int.parse(zeit.substring(3));
  //   return DateTime(yy, mo, dd, hh24, mi);
  // }

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
    this.urpsrungszeichen = "",
    this.jagdaufseher,
  }) {
    // datetime = parseDateTime(datum, zeit);
    switch (ursache) {
      case 'erlegt':
        icon = Icons.person;
        break;
      case 'Fallwild':
        icon = Icons.cloudy_snowing;
        break;
      case 'Straßenunfall':
        icon = Icons.car_crash;
        break;
      case 'Hegeabschuss':
        icon = Icons.admin_panel_settings_outlined;
        break;
      case 'Protokoll / beschlagnahmt':
        icon = Icons.list_alt;
        break;
      case 'vom Zug überfahren':
        icon = Icons.train;
        break;
      case 'Freizone':
        icon = Icons.forest;
        break;
    }

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
  }

  bool contains(String q) {
    return wildart.toLowerCase().contains(q) ||
        geschlecht.toLowerCase().contains(q) ||
        oertlichkeit.toLowerCase().contains(q) ||
        verwendung.toLowerCase().contains(q) ||
        ursache.toLowerCase().contains(q) ||
        datetime.toString().contains(q) ||
        gewicht.toString().contains(q) ||
        alter.toLowerCase().contains(q) ||
        alterw.toLowerCase().contains(q);
  }

  static KillEntry? fromEntry(dom.Element e) {
    try {
      //debugPrint('PARSING: ${htmlRow.length}');
      // dom.DocumentFragment r = dom.DocumentFragment.html(htmlRow);
      // print(r.attributes);

      // print(r.children);
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

        urpsrungszeichen: cols.elementAt(12).text,
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
}
