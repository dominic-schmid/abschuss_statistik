import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:jagdverband_scraper/utils.dart';
import 'package:jagdverband_scraper/widgets/filter_chip_data.dart';

import 'kill_entry.dart';

class KillPage {
  final int jahr;
  final String revierName;
  final int revierNummer;

  final List<KillEntry> kills;

  List<FilterChipData> wildarten = [];
  List<FilterChipData> geschlechter = [];
  List<FilterChipData> ursachen = [];
  List<FilterChipData> verwendungen = [];

  // DateTime parseDateTime(String d, String t) {
  //   int yy = int.parse(datum.substring(6));
  //   int mo = int.parse(datum.substring(3, 5));
  //   int dd = int.parse(datum.substring(0, 2));
  //   int hh24 = int.parse(zeit.substring(0, 2));
  //   int mi = int.parse(zeit.substring(3));
  //   return DateTime(yy, mo, dd, hh24, mi);
  // }

  KillPage({
    required this.jahr,
    required this.revierName,
    required this.revierNummer,
    required this.kills,
  }) {
    // Select distinct
    List<String> wildarten = kills.map((e) => e.wildart).toSet().toList();
    List<String> ursachen = kills.map((e) => e.ursache).toSet().toList();
    List<String> verwendungen = kills.map((e) => e.verwendung).toSet().toList();

    this.wildarten.addAll(FilterChipData.allWild
        .where((element) => wildarten.contains(element.label)));
    this.ursachen.addAll(FilterChipData.allUrsache
        .where((element) => ursachen.contains(element.label)));
    this.verwendungen.addAll(FilterChipData.allVerwendung
        .where((element) => verwendungen.contains(element.label)));
  }

  static KillPage? fromPage(int year, dom.Document page) {
    try {
      var titel = page.querySelector('#c4 > h1');

      String revierName = "Unbekanntes Revier";
      int revierNummer = 0;
      if (titel != null) {
        revierName = titel.text.substring(titel.text.indexOf('-') + 2);
        revierNummer = int.tryParse(
                titel.text.substring(0, titel.text.indexOf('-') - 1)) ??
            0;
      }

      List<KillEntry> kills = [];
      dom.Element? table = page.querySelector('#dataTables');
      if (table != null) {
        final entries = table
            .querySelectorAll('tr'); //.map((e) => e.innerHtml.trim()).toList();
        print('${entries.length} kill entries loaded');

        // Sublist 1 because the first element is the table header
        for (dom.Element e in entries.sublist(1)) {
          KillEntry? k = KillEntry.fromEntry(e);
          if (k != null) {
            kills.add(k);
          }
        }
      }

      return KillPage(
        jahr: 2022,
        revierName: revierName,
        revierNummer: revierNummer,
        kills: kills,
      );
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
