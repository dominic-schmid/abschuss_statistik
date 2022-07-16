import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String baseUrl = 'https://stat.jagdverband.it/index.php?id=4';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //CookieManager cookieManager = CookieManager.instance();

  List<WebViewCookie> initialCookies = const [
    WebViewCookie(name: "revier", value: "-324", domain: "stat.jagdverband.it"),
    WebViewCookie(
        name: "fe_typo_user",
        value: "5709610edb598a97d2da55fc684d4068",
        domain: "stat.jagdverband.it")
  ];

  final flutterWebviewPlugin = FlutterWebviewPlugin();
  StreamSubscription? _onDestroy;
  StreamSubscription<String>? _onUrlChanged;
  StreamSubscription<WebViewStateChanged>? _onStateChanged;

  String token = "";

  Future getWebsiteData() async {
    final url = Uri.parse(widget.baseUrl);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final entries =
        html.querySelectorAll('tr').map((e) => e.innerHtml.trim()).toList();
    print(entries);
  }

  @override
  void initState() {
    super.initState();
    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.startsWith("jagdverband")) {
            RegExp regExp = RegExp("#access_token=(.*)");
            token = regExp.firstMatch(url)?.group(1) ?? "";
            print("token $token");

            //saveToken(token);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     "/home", (Route<dynamic> route) => false);
            // flutterWebviewPlugin.close();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // HttpAuthCredentialDatabase httpAuthCredentialDatabase =
    //       HttpAuthCredentialDatabase.instance();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Jagdverband'),
          actions: [
            IconButton(
              icon: Icon(Icons.ac_unit),
              onPressed: () async {
                // TEST CODE
                //await cookieManager.getCookies(null);
              },
            )
          ],
        ),
        body: WebView(
          initialUrl: widget.baseUrl,
          initialCookies: initialCookies,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) async {
            print('CREATED');
            print('CURRENT URL: ${controller.currentUrl()}');
            // await cookieManager.setCookies([
            //   Cookie(cookieName, cookieValue)
            //     ..domain = domain
            //     ..expires = DateTime.now().add(Duration(days: 10))
            //     ..httpOnly = false
            // ]);
          },
          onPageFinished: (url) async {
            print('NEW PAGE $url');
            // final gotCookies = await cookieManager.getCookies(_url);
            // for (var item in gotCookies) {
            //   print(item);
            // }
          },
        ),
      ),
    );
  }
}
