import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:jagdverband_scraper/database_methods.dart';
import 'package:jagdverband_scraper/models/kill_entry.dart';
import 'package:jagdverband_scraper/models/kill_page.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:path/path.dart';
import 'package:requests/requests.dart';
import 'package:sqflite/sqflite.dart';

class RequestMethods {
  static const String _baseURL = 'https://stat.jagdverband.it/index.php';

  static final _baseHeaders = {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials":
        'true', // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
  };

  // Returns true if login data is valid (by checking whether or not the POST request returned a set-cookie)
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
      headers: _baseHeaders,
      body: data,
      persistCookies: true,
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
    );
    // location: https://stat.jagdverband.it/index.php?id=4&no_cache=1

    res = await Requests.get(
      'https://stat.jagdverband.it',
      headers: _baseHeaders,
    );

    dom.DocumentFragment html = dom.DocumentFragment.html(res.body);
    if (html.text!.contains('Abmelden')) {
      print('Erfolgreich angemeldet!');
      return true;
    } else {
      print('Anmeldung nicht erfolgreich!');
      return false;
    }
  }

  // If called after tryLogin(), returns list of kills using cookie
  static Future<KillPage?> getPage(int year) async {
    var res = await Requests.get(
      '$_baseURL?id=4&no_cache=1&tx_jvdb_pi1[filter-year]=$year',
      persistCookies: true,
      headers: _baseHeaders,
    );

    if (res.content().contains('Anmeldung')) {
      print('ACHTUNG: Session nicht mehr gültig!');
      var creds = await loadCredentialsFromPrefs();

      try {
        String user = creds!['revierLogin']!;
        String pass = creds['revierPasswort']!;
        bool verified = await tryLogin(user, pass);
        print('Erneute Session mit $user $pass: $verified');
        if (!verified) {
          await deletePrefs();
        } else {
          return getPage(year);
        }
      } catch (e) {
        await deletePrefs();
      }
    }

    dom.Document html = dom.Document.html(res.body);

    KillPage? page = KillPage.fromPage(year, html);
    if (page != null) {
      Database db = await SqliteDB().db;
      var testIfExist = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='Kill';");

      if (testIfExist.isEmpty) {
        // Somehow db was deleted, recreate it
        await SqliteDB().initDb();
      }

      for (KillEntry k in page.kills) {
        // await d.rawDelete('Delete FROM Kill ');

        await db.transaction((txn) async => await txn.insert(
              'Kill',
              {
                'key': '$year-${k.key}',
                'year': year,
                'revier': page.revierName,
                'nummer': k.nummer,
                'wildart': k.wildart,
                'geschlecht': k.geschlecht,
                'hegeinGebietRevierteil': k.hegeinGebietRevierteil,
                'alterm': k.alter,
                'alterw': k.alterw,
                'gewicht': k.gewicht,
                'erleger': k.erleger,
                'begleiter': k.begleiter,
                'ursache': k.ursache,
                'verwendung': k.verwendung,
                'ursprungszeichen': k.ursprungszeichen,
                'oertlichkeit': k.oertlichkeit,
                'datetime': k.datetime.toIso8601String(),
                'aufseherDatum':
                    k.jagdaufseher == null ? null : k.jagdaufseher!['datum'],
                'aufseherZeit':
                    k.jagdaufseher == null ? null : k.jagdaufseher!['zeit'],
                'aufseher':
                    k.jagdaufseher == null ? null : k.jagdaufseher!['aufseher'],
              },
              conflictAlgorithm: ConflictAlgorithm.ignore,
            ));
      }
    }

    return page;
  }
}
