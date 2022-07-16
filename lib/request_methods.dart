// TO VERIFY LOGIN CHECK FOR EITHER
// <h1><h3>Anmeldefehler</h3></h1>
// <h1><h3>Anmeldung erfolgreich</h3></h1>
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:jagdverband_scraper/models/kill_entry.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestMethods {
  static const String _baseURL = 'https://stat.jagdverband.it/index.php';

  static Map<String, String> getBaseHeaders() => {
        'authority': 'stat.jagdverband.it',
        'accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'accept-language': 'de,de-DE;q=0.9,en-US;q=0.8,en;q=0.7',
        'referer': 'https://stat.jagdverband.it/index.php?id=4&no_cache=1',
        'sec-ch-ua':
            '".Not/A)Brand";v="99", "Google Chrome";v="103", "Chromium";v="103"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Windows"',
        'sec-fetch-dest': 'document',
        'sec-fetch-mode': 'navigate',
        'sec-fetch-site': 'same-origin',
        'sec-fetch-user': '?1',
        'upgrade-insecure-requests': '1',
        'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36',
      };

  static Future<String> refreshCookie(String revier, String passwort) async {
    // Create new cookie from POST request
    var data = {
      'user': revier,
      'pass': passwort,
      'submit': 'Anmelden',
      'logintype': 'login',
      'pid': '2,25',
      'redirect_url': 'index.php?id=4&no_cache=1',
      'tx_felogin_pi1[noredirect]': '0',
    };

    final url = Uri.parse(_baseURL);
    //print('Sending POST request to $url containing $data');
    final response = await http.post(url, body: data);

    if (response.body.contains('Anmeldung erfolgreich') &&
        response.headers.containsKey('set-cookie')) {
      print('Login success!');
      String setCookie = response.headers['set-cookie']!;
      print(setCookie);

      return setCookie
          .replaceFirst('fe_typo_user=', '')
          .replaceFirst('; path=/', '');
      //set-cookie: fe_typo_user=369011a49440fe33de6bf40771f2a18d;
    }
    print('Login ERROR!');
//      dom.Document html = dom.Document.html(response.body);

    return "";
    // If cookie found, try login using that cookie, otherwise refresh it and save it
  }

  static Future<List<KillEntry>> loadKills(String cookie) async {
    //{'fe_typo_user': cookie},
    final url = Uri.parse('$_baseURL?id=4&no_cache=1');

    //_headers.putIfAbsent('cookie', () => 'fe_typo_user=$cookie;');

    var headers = {
      'authority': 'stat.jagdverband.it',
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'accept-language': 'de,de-DE;q=0.9,en-US;q=0.8,en;q=0.7',
      'cache-control': 'max-age=0',
      'cookie': 'revier=-324; fe_typo_user=5991d3756866e88e2922a3b1873ffbb3',
      'referer': 'https://stat.jagdverband.it/index.php?id=4&no_cache=1&L=',
      'sec-ch-ua':
          '".Not/A)Brand";v="99", "Google Chrome";v="103", "Chromium";v="103"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
      'sec-fetch-dest': 'document',
      'sec-fetch-mode': 'navigate',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-user': '?1',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
    };

    final response = await http.get(
      url,
      headers: headers,
      // headers: {
      //   'authority': 'stat.jagdverband.it',
      //   'accept':
      //       'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      //   'accept-language': 'de,de-DE;q=0.9,en-US;q=0.8,en;q=0.7',
      //   'cookie': 'fe_typo_user=$cookie; revier=-324',
      //   'referer': 'https://stat.jagdverband.it/index.php?id=4&no_cache=1',
      //   'sec-ch-ua':
      //       '".Not/A)Brand";v="99", "Google Chrome";v="103", "Chromium";v="103"',
      //   'sec-ch-ua-mobile': '?0',
      //   'sec-ch-ua-platform': '"Windows"',
      //   'sec-fetch-dest': 'document',
      //   'sec-fetch-mode': 'navigate',
      //   'sec-fetch-site': 'same-origin',
      //   'sec-fetch-user': '?1',
      //   'upgrade-insecure-requests': '1',
      //   'user-agent':
      //       'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36',
      // },
    );

    dom.Document html = dom.Document.html(response.body);
    debugPrint(response.body);

    //print(response.headers);

    print(html.querySelectorAll('link'));

    print(html.querySelector('tBody'));

    final entries =
        html.querySelectorAll('tr').map((e) => e.innerHtml.trim()).toList();
    print(entries);

    return [];
  }
}
