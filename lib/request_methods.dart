import 'package:html/dom.dart' as dom;
import 'package:jagdverband_scraper/models/kill_page.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:requests/requests.dart';

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

    if (res.headers.containsKey('set-cookie')) {
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
          return getPage(year);
        }
      }
    }

    dom.Document html = dom.Document.html(res.body);

    KillPage? page = KillPage.fromPage(year, html);

    return page;
  }
}
