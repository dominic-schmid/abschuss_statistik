import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:jagdverband_scraper/utils.dart';

class KillEntry {
  final int nummer;
  final String wildart;
  final String geschlecht;
  final String hegeinGebietRevierteil;
  final String datum;
  final String zeit;
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
  IconData icon = Icons.question_mark;
  Color color = Colors.grey;

  KillEntry(
    this.nummer,
    this.wildart,
    this.geschlecht,
    this.datum,
    this.zeit,
    this.ursache,
    this.verwendung,
    this.oertlichkeit, {
    this.hegeinGebietRevierteil = "",
    this.alter = "",
    this.alterw = "",
    this.gewicht = 0.0,
    this.erleger = "",
    this.begleiter = "",
    this.urpsrungszeichen = "",
    this.jagdaufseher,
  }) {
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

  static KillEntry? fromEntry(dom.Element e) {
    try {
      //debugPrint('PARSING: ${htmlRow.length}');
      // dom.DocumentFragment r = dom.DocumentFragment.html(htmlRow);
      // print(r.attributes);

      // print(r.children);
      var cols = e.querySelectorAll('td');

      return KillEntry(
        int.parse(cols.elementAt(0).text), // Nummer
        cols.elementAt(1).text, // Wildart
        cols.elementAt(2).text, // Geschlecht
        cols.elementAt(4).text.substring(0, 10), // Datum
        cols.elementAt(4).querySelector('small')!.text, // Zeit
        cols.elementAt(10).text, // Ursache
        cols.elementAt(11).text, // Verwendung
        cols
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
