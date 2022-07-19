import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/credentials_screen.dart';
import 'dart:async';
import 'package:jagdverband_scraper/request_methods.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';
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
    return MaterialApp(
      title: 'Abschuss Statistik',
      // theme: ThemeData.dark(
      //   primarySwatch: Colors.green,
      // ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightGreen,
        useMaterial3: true,
        //primaryColor: Color.fromRGBO(56, 142, 60, 1),
      ),
      //darkTheme: ThemeData.dark(),
      //themeMode: ThemeMode.dark,
      //scrollBehavior: const ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      home: FutureBuilder<Map<String, String>?>(
        future:
            loadCredentialsFromPrefs(), // Loads creds and cookie from storage
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              String user = snapshot.data!['revierLogin'] ?? "";
              String pass = snapshot.data!['revierPasswort'] ?? "";

              if (user.isEmpty || pass.isEmpty) {
                return CredentialsScreen();
              }

              return FutureBuilder<bool>(
                future: RequestMethods.tryLogin(user, pass),
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
              );
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
        }),
      ),
    );
  }
}
