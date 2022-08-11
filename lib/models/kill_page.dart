import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/filter_chip_data.dart';

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
  List<FilterChipData> oertlichkeiten = [];

  KillPage({
    required this.jahr,
    required this.revierName,
    this.revierNummer = -1,
    required this.kills,
  }) {
    // Select distinct
    List<String> wildarten = kills.map((e) => e.wildart).toSet().toList();
    List<String> ursachen = kills.map((e) => e.ursache).toSet().toList();
    List<String> verwendungen = kills.map((e) => e.verwendung).toSet().toList();
    List<String> oertlichkeiten = kills.map((e) => e.oertlichkeit).toSet().toList();
    List<String> geschlechter = kills.map((e) => e.geschlecht).toSet().toList();

    this.wildarten.addAll(
        FilterChipData.allWild.where((element) => wildarten.contains(element.label)));

    this.ursachen.addAll(
        FilterChipData.allUrsache.where((element) => ursachen.contains(element.label)));
    this.verwendungen.addAll(FilterChipData.allVerwendung
        .where((element) => verwendungen.contains(element.label)));
    this.oertlichkeiten.addAll(oertlichkeiten.map((o) {
      return FilterChipData(label: o, color: const Color.fromRGBO(0, 160, 83, 1));
    }));
    for (int i = 0; i < geschlechter.length; i++) {
      this.geschlechter.add(FilterChipData(
          label: geschlechter.elementAt(i),
          color: Colors.primaries[i % Colors.primaries.length]));
    }
    // this.geschlechter.addAll(geschlechter.map((o) {
    //   return FilterChipData(label: o, color: const Color.fromRGBO(0, 160, 83, 1));
    // }));
  }

  static KillPage? fromPage(int year, dom.Document page) {
    try {
      var titel = page.querySelector('#c4 > h1');

      String revierName = "Kein Revier";
      int revierNummer = 0;
      if (titel != null) {
        revierName = titel.text.substring(titel.text.indexOf('-') + 2);
        revierNummer =
            int.tryParse(titel.text.substring(0, titel.text.indexOf('-') - 1)) ?? 0;
      }

      List<KillEntry> kills = [];
      dom.Element? table = page.querySelector('#dataTables');
      if (table != null) {
        final entries =
            table.querySelectorAll('tr'); //.map((e) => e.innerHtml.trim()).toList();
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
        jahr: year,
        revierName: revierName,
        revierNummer: revierNummer,
        kills: kills,
      );
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static KillPage fromList(String revierName, int jahr, List<KillEntry> kills) {
    return KillPage(
      jahr: jahr,
      revierName: revierName,
      kills: kills,
    );
  }

  @override
  String toString() {
    return '$jahr - $revierName - ${kills.length}';
  }

  // Define that two kill lists are equal ifthe length is the same (Wrong! but should not happen often so..?)
  @override
  bool operator ==(dynamic other) =>
      other != null &&
      other is KillPage &&
      jahr == other.jahr &&
      revierName == other.revierName &&
      kills.length == other.kills.length;

  @override
  int get hashCode => Object.hash(revierName, jahr, kills.length);

  List<List<dynamic>> toCSV(BuildContext context) {
    final dg = S.of(context);
    List<List<dynamic>> allRows = [];
    allRows.add([
      dg.number,
      dg.sortGameType,
      dg.sortGender,
      dg.area,
      dg.age,
      '{$dg.age}w',
      dg.weight,
      dg.killer,
      dg.companion,
      dg.sortCause,
      dg.usage,
      dg.signOfOrigin,
      dg.area,
      'Lat',
      'Lon',
      dg.sortDate,
      dg.time,
      '${dg.overseer} ${dg.sortDate}',
      '${dg.overseer} ${dg.time}',
      dg.overseer,
    ]);

    for (KillEntry k in kills) {
      allRows.add(k.toCSV(context));
    }

    return allRows;
  }

  List<Map<String, dynamic>> toJson(BuildContext ctx) =>
      kills.map((e) => e.toMap(ctx)).toList();
}
