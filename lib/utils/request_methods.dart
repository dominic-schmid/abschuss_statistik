import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:jagdstatistik/models/shooting_time.dart';
import 'package:jagdstatistik/utils/database_methods.dart';
import 'package:jagdstatistik/models/kill_page.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:requests/requests.dart';

class RequestMethods {
  static const String baseURL = 'https://stat.jagdverband.it/index.php';

  static final baseHeaders = {
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
      baseURL,
      headers: baseHeaders,
      body: data,
      persistCookies: true,
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
    );
    // location: https://stat.jagdverband.it/index.php?id=4&no_cache=1

    res = await Requests.get(
      'https://stat.jagdverband.it',
      headers: baseHeaders,
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
  static Future<KillPage?> getPage(int year, [int recursionCount = 0]) async {
    if (recursionCount > 5) return null;

    var res = await Requests.get(
      '$baseURL?id=4&no_cache=1&tx_jvdb_pi1[filter-year]=$year',
      persistCookies: true,
      headers: baseHeaders,
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
          return getPage(year, recursionCount + 1);
        }
      } catch (e) {
        await deletePrefs();
      }
    }

    dom.Document html = dom.Document.html(res.body);

    KillPage? page = KillPage.fromPage(year, html);
    if (page != null) {
      SqliteDB().insertKills(year, page);
    }

    return page;
  }
}

class ShootingTimeApi {
  //"https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400&date=2022-09-13";
  static String baseUrl = "https://api.sunrise-sunset.org/json?";

  static Future<ShootingTime?> forDate({required LatLng latLng, DateTime? day}) async {
    day = day ?? DateTime.now();

    final res = await Requests.get(
      baseUrl,
      queryParameters: {
        'lat': latLng.latitude,
        'lng': latLng.longitude,
        'date': DateFormat('yyyy-MM-dd').format(day),
        'formatted': 0, // force datetime to be in ISO
      },
      timeoutSeconds: 15,
    );

    try {
      return ShootingTime.fromMap(latLng, res.json());
    } catch (e) {
      print("Error parsing shooting time: ${e.toString()}");
      return null;
    }
  }

  static Future<ShootingTime?> getFor(LatLng? latLng, DateTime day) async {
    if (latLng == null) return null;

    // try to find time from DB
    ShootingTime? t = await SqliteDB().getShootingTimeFor(latLng, day);
    print('DB returned $t');

    if (t != null) return t;

    // if time in db is not found (still null), get from API
    t = await ShootingTimeApi.forDate(latLng: latLng, day: day);

    // if API has found, insert to DB before notifying listeners and return
    if (t != null) {
      await SqliteDB().insertShootingTime(t);
      print('Inserted shooting time $t to Database!');
    }

    return t;
  }
}
