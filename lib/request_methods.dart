// TO VERIFY LOGIN CHECK FOR EITHER
// <h1><h3>Anmeldefehler</h3></h1>
// <h1><h3>Anmeldung erfolgreich</h3></h1>
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:jagdverband_scraper/models/kill_entry.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestMethods {
  static const String _baseURL = 'https://stat.jagdverband.it/index.php';

  // Returns true if login data is valid
  static Future<bool> tryLogin(String user, String pass) async {
    var data = {
      'user': user,
      'pass': pass,
      'submit': 'Anmelden',
      'logintype': 'login',
      'pid': '2,25',
      'redirect_url': 'index.php?id=4&no_cache=1',
      'tx_felogin_pi1[noredirect]': '0',
    };

    await Requests.clearStoredCookies('https://stat.jagdverband.it');
    var res = await Requests.post(
      _baseURL,
      body: data,
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
    );

    if (res.headers.containsKey('set-cookie')) {
      print('Erfolgreich angemeldet!');
      return true;
    } else {
      print('Anmeldung nicht erfolgreich!');
      return false;
    }
  }

  // If called after tryLogin(), returns list of kills using cookie
  static Future<List<KillEntry>?> getKills(int year) async {
    var res = await Requests.get(
        '$_baseURL?id=4&no_cache=1&tx_jvdb_pi1[filter-year]=$year');

    if (res.content().contains('Anmeldung')) {
      print('ACHTUNG: Session nicht mehr gültig!');
      var creds = await loadCredentialsFromPrefs();
      if (creds == null ||
          !creds.containsKey('revierLogin') ||
          !creds.containsKey('revierPasswort')) {
        await deletePrefs();
      } else {
        String user = creds['revierLogin']!;
        String pass = creds['revierPasswort']!;
        bool verified = await tryLogin(user, pass);
        print('Erneute Session mit $user $pass: $verified');
        if (!verified) {
          await deletePrefs();
        } else {
          return getKills(year);
        }
      }
    }

    dom.Document html = dom.Document.html(res.body);

    List<KillEntry> kills = [];
    dom.Element? table = html.querySelector('#dataTables');
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

    return kills;
  }
}
