import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:jagdverband_scraper/main.dart';
import 'package:jagdverband_scraper/providers.dart';
import 'package:jagdverband_scraper/request_methods.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:provider/provider.dart';

import 'models/kill_entry.dart';

class KillsScreen extends StatefulWidget {
  final String revier;
  final String passwort;

  const KillsScreen({Key? key, required this.revier, required this.passwort})
      : super(key: key);

  @override
  State<KillsScreen> createState() => _KillsScreenState();
}

class _KillsScreenState extends State<KillsScreen> {
  Future<List<KillEntry>>? myFuture;

  loadCookieAndKills() async {
    Provider.of<CookieProvider>(context, listen: false)
        .refreshCredentials(widget.revier, widget.passwort);

    await Provider.of<CookieProvider>(context, listen: false)
        .readPrefsOrUpdate();
    String cookie =
        Provider.of<CookieProvider>(context, listen: false).getCookie;
    print('Init state found cookie $cookie');
    myFuture = RequestMethods.loadKills(cookie);
  }

  // Well, she's delighted now! She got a VW Golf from Germany on Tuesday. Quite an expensive car to pick if you ask me but she really had her mind made up about that..

  @override
  void initState() {
    super.initState();
    loadCookieAndKills();
  }

  @override
  Widget build(BuildContext context) {
    String cookie = Provider.of<CookieProvider>(context).getCookie;
    cookie = "5991d3756866e88e2922a3b1873ffbb3"; // TODO REMOVE

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              print(loadCredentialsFromPrefs());
            },
            child: const Text('324 - Terenten')), // TODO get from loaded page
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              deletePrefs();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyApp()));
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () async {
              print(
                  'Cookie: ${Provider.of<CookieProvider>(context, listen: false).getCookie}');

              print(
                  'New cookie: ${await Provider.of<CookieProvider>(context, listen: false).refreshCookie()}');
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
              onPressed: () async {
                final url = Uri.parse(
                    'https://stat.jagdverband.it/index.php?id=4&no_cache=1');

                //_headers.putIfAbsent('cookie', () => 'fe_typo_user=$cookie;');

                print('URL: $url');
                final response = await http.get(
                  url,
                  headers: {
                    'authority': 'stat.jagdverband.it',
                    'accept':
                        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
                    'accept-language': 'de,de-DE;q=0.9,en-US;q=0.8,en;q=0.7',
                    'cookie':
                        'fe_typo_user=5991d3756866e88e2922a3b1873ffbb3; revier=-324',
                    'referer':
                        'https://stat.jagdverband.it/index.php?id=4&no_cache=1',
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
                  },
                );

                dom.Document html = dom.Document.html(response.body);
                debugPrint(response.body);
              },
              icon: Icon(Icons.http))
        ],
      ),
      body: FutureBuilder<List<KillEntry>>(
        future: RequestMethods.loadKills('5991d3756866e88e2922a3b1873ffbb3'),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            List<KillEntry> kills = snap.data!;

            return Container(
              color: Colors.green,
            );
          } else if (snap.connectionState == ConnectionState.none ||
              snap.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.green));
          }

          return Text('Keine Daten!');
        },
      ),
    );
  }

  Widget buildKillEntries(
    List<KillEntry> kills,
  ) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: ((context, index) {
          return Container(
            height: 30,
            width: double.infinity,
            color: Colors.blue,
            child: Text(index.toString()),
          );
        }));
  }
}
