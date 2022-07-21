import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'utils.dart';
import 'providers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).textTheme.headline1!.color,
        backgroundColor: bg,
        title: const Text('Einstellungen'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
              minWidth: 100, maxWidth: 600, minHeight: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SettingsList(
                  darkTheme: const SettingsThemeData()
                      .copyWith(settingsListBackground: bg),
                  lightTheme: const SettingsThemeData()
                      .copyWith(settingsListBackground: bg),
                  sections: [
                    SettingsSection(
                      title: const Text(
                        'Anzeige',
                        style: TextStyle(color: rehwildFarbe),
                      ),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          onPressed: (context) {
                            showSnackBar('Sprache wechseln', context);
                          },
                          leading: Icon(Icons.language),
                          title: Text('Sprache'),
                          value: Text('Deutsch'),
                        ),
                        SettingsTile.switchTile(
                          onToggle: (value) {
                            themeProvider.toggleTheme(themeProvider.isDarkMode);
                          },
                          initialValue: themeProvider.isDarkMode,
                          leading: const Icon(Icons.format_paint),
                          title: const Text('Dunkler Modus'),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: const Text(
                        'Konto',
                        style: TextStyle(color: rehwildFarbe),
                      ),
                      tiles: <SettingsTile>[
                        SettingsTile(
                          onPressed: (value) async {
                            await showAlertDialog(
                              title: ' Abmelden',
                              description:
                                  'Möchtest du dich wirklich abmelden?\nDeine Anmeldedaten und alle deiner Einstellungen werden dabei gelöscht!',
                              yesOption: 'Ja',
                              noOption: 'Nein',
                              onYes: () {
                                deletePrefs().then((value) => Navigator.of(
                                        context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            MyApp(config: getDefaultPrefs()))));
                              },
                              icon: Icons.warning,
                              context: context,
                            );
                          },
                          leading: const Icon(Icons.logout),
                          title: const Text('Abmelden'),
                        ),
                      ],
                    ),
                    // SettingsSection(
                    //   title: const Text(
                    //     'Entwicklung',
                    //     style: TextStyle(color: rehwildFarbe),
                    //   ),
                    //   tiles: <SettingsTile>[
                    //     SettingsTile(
                    //       onPressed: (value) async {
                    //         Uri uri = Uri(
                    //           scheme: 'mailto',
                    //           path: 'dominic.schmid@hotmail.com',
                    //           queryParameters: {
                    //             'subject': 'Feedback zur Jagdstatistik App'
                    //           },
                    //         );

                    //         print(uri.toString());

                    //         await launchUrl(uri)
                    //             .timeout(const Duration(seconds: 10));
                    //       },
                    //       leading: const Icon(Icons.mail),
                    //       title: const Text('Kontakt'),
                    //     ),
                    //     SettingsTile(
                    //       onPressed: (value) async {
                    //         Uri uri = Uri(
                    //           scheme: 'https',
                    //           path: 'buymeacoffee.com/dominic.schmid',
                    //         );

                    //         await launchUrl(uri)
                    //             .timeout(const Duration(seconds: 10));
                    //       },
                    //       leading: const Icon(Icons.local_pizza_rounded),
                    //       title: const Text('Pizza spendieren'),
                    //     ),
                    //   ],
                    // )
                    // TODO UNCOMMENT IF SHAMELESS
                  ],
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Version 1.0.0 © 2022',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
