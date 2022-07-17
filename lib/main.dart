import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/credentials_screen.dart';
import 'dart:async';
import 'package:jagdverband_scraper/providers.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'kills_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CookieProvider>(create: (_) => CookieProvider())
      ],
      child: MaterialApp(
        title: 'Abschuss Statistik',
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
          primarySwatch: Colors.green,
          //primaryColor: Color.fromRGBO(56, 142, 60, 1),
        ),
        //darkTheme: ThemeData.dark(),
        //themeMode: ThemeMode.dark,

        home: FutureBuilder<bool>(
            future:
                validCredentialsSaved(), // Loads creds and cookie from storage
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!) {
                  return const KillsScreen();
                } else {
                  // showSnackBar(
                  //     'Fehler: Gespeicherte Daten fehlerhaft oder nicht vorhanden!',
                  //     context);
                  return CredentialsScreen();
                }
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            })),
      ),
    );
  }
}
