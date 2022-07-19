import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/credentials_screen.dart';
import 'package:jagdverband_scraper/providers.dart';
import 'dart:async';
import 'package:jagdverband_scraper/request_methods.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'kills_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String revierLogin = prefs.getString('revierLogin') ?? "";
  String revierPasswort = prefs.getString('revierPasswort') ?? "";
  bool isDarkMode = prefs.getBool('isDarkMode') ?? true;

  Map<String, dynamic> config = {
    'login': revierLogin,
    'pass': revierPasswort,
    'isDarkMode': isDarkMode,
  };

  print('Read config: $config');

  // return {
  //   'revierLogin': revierLogin,
  //   'revierPasswort': revierPasswort,
  // };

  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  // Default config
  final Map<String, dynamic> config;

  const MyApp({Key? key, required this.config}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    String login = config['login'];
    String pass = config['pass'];
    bool isDarkMode = config['isDarkMode'];

    return ChangeNotifierProvider(
        create: (BuildContext context) => ThemeProvider(
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            ),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'Abschuss Statistik',
            // theme: ThemeData.dark(
            //   primarySwatch: Colors.green,
            // ),
            theme: ThemeData(
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.black, //<-- SEE HERE
                    displayColor: Colors.black, //<-- SEE HERE
                  ),
              brightness: Brightness.light,
              primarySwatch: Colors.lightGreen,
              appBarTheme: const AppBarTheme().copyWith(
                foregroundColor: Colors.white,
              ),
              useMaterial3: true,
              //primaryColor: Color.fromRGBO(56, 142, 60, 1),
            ),
            darkTheme: ThemeData(
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white, //<-- SEE HERE
                    displayColor: Colors.white, //<-- SEE HERE
                  ),
              appBarTheme: const AppBarTheme().copyWith(
                foregroundColor: Colors.white,
              ),
              brightness: Brightness.dark,
              primarySwatch: Colors.lightGreen,
              useMaterial3: true,
              //primaryColor: Color.fromRGBO(56, 142, 60, 1),
            ),
            themeMode: themeProvider.themeMode,
            home: login.isEmpty || pass.isEmpty
                ? CredentialsScreen()
                : FutureBuilder<bool>(
                    future: RequestMethods.tryLogin(login, pass),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.hasData && snap.data!) {
                          return const KillsScreen();
                        } else {
                          return CredentialsScreen();
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
          );
        });
  }
}
