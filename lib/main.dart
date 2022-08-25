import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jagdstatistik/views/credentials_screen.dart';
import 'package:jagdstatistik/views/home_screen.dart';
import 'package:jagdstatistik/utils/providers.dart';
import 'package:jagdstatistik/utils/request_methods.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:jagdstatistik/generated/l10n.dart';
import 'utils/database_methods.dart';
import 'models/kill_entry.dart';
import 'models/kill_page.dart';
import 'utils/providers.dart';

const SEND_NOTIFICATIONS = false;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await _showNotification();
    // print(
    //     "Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

Future<void> _showNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String revierLogin = prefs.getString('revierLogin') ?? "";
  String revierPasswort = prefs.getString('revierPasswort') ?? "";

  if (revierLogin.isNotEmpty && revierPasswort.isNotEmpty) {
    int year = DateTime.now().year;

    bool verified = await RequestMethods.tryLogin(revierLogin, revierPasswort);
    print('Notification login with $revierLogin $revierPasswort: $verified');
    if (verified) {
      KillPage? sqlPage;
      try {
        sqlPage = await SqliteDB.internal().db.then((d) async {
          List<Map<String, Object?>> kills = await d.query('Kill', where: 'year = $year');

          List<KillEntry> killList = [];
          for (Map<String, Object?> m in kills) {
            KillEntry? k = KillEntry.fromMap(m);
            if (k != null) killList.add(k);
          }

          return KillPage.fromList(kills.first['revier'] as String, year, killList);
        });
      } catch (e) {
        print('Notification error parsing KillPage from db: ${e.toString()}');
      }
      KillPage? httpPage = await RequestMethods.getPage(year);
      if (sqlPage != null && httpPage != null && sqlPage != httpPage) {
        // TODO show notifiaction
        print('SEND NOTIFICATION: Found difference in pages');
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: Random.secure().nextInt(999999),
          channelKey: 'basic_channel',
          title: 'Neuer Abschuss', // TODO TRANSLATIONS
          body: 'Es gibt einen neuen Abschuss in ${sqlPage.revierName}!',
        ));
      }
    }
  }
}

void initNotifications() async {
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/hunting',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        ledColor: Colors.white,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
  );

  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    print('Notifications allowed by the user: $isAllowed');
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String revierLogin = prefs.getString('revierLogin') ?? "";
  String revierPasswort = prefs.getString('revierPasswort') ?? "";
  bool? isDarkMode = prefs.getBool('isDarkMode');
  String? language = prefs.getString('language');

  Map<String, dynamic> config = {
    'login': revierLogin,
    'pass': revierPasswort,
    'isDarkMode': isDarkMode,
    'language': language,
  };

  print('Read config: $config');

  // Init database
  final db = SqliteDB();
  await db.initDb();

  if (SEND_NOTIFICATIONS) {
    initNotifications();
    //print(await db.countTable() + ' tables');
    // The top level function, aka callbackDispatche
    Workmanager().initialize(callbackDispatcher);

    // Periodic task registration
    Workmanager().registerPeriodicTask(
      "periodic-task-identifier", "updateKills",
      // When no frequency is provided the default 15 minutes is set.
      // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  // Default config
  final Map<String, dynamic> config;

  const MyApp({Key? key, required this.config}) : super(key: key);

  Future<void> tryLoadLocale(Locale locale) async {
    Locale toLoad = locale;
    if (!S.delegate.supportedLocales.contains(locale)) {
      toLoad = S.delegate.supportedLocales.first;
    }

    await S.load(toLoad);
    return;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String login = config['login'];
    String pass = config['pass'];
    bool isDarkMode = config['isDarkMode'] ??
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    Locale locale =
        config['language'] != null && (config['language'] as String).length == 2
            ? Locale(config['language'] as String)
            : const Locale('de'); // Default to German

    return FutureBuilder<void>(
        future: tryLoadLocale(locale),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          return ChangeNotifierProvider(
              create: (BuildContext context) => ThemeProvider(
                    themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  ),
              builder: (context, _) {
                final themeProvider = Provider.of<ThemeProvider>(context);

                return MaterialApp(
                  onGenerateTitle: (context) => S.of(context).appTitle,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  locale: locale,
                  supportedLocales: S.delegate.supportedLocales,
                  theme: ThemeData(
                    textTheme: Theme.of(context).textTheme.apply(
                          bodyColor: Colors.black,
                          displayColor: Colors.black,
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
                          bodyColor: Colors.white,
                          displayColor: Colors.white,
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
                      ? const CredentialsScreen()
                      : const HomeScreen(),
                );
              });
        });
  }
}
