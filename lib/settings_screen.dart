import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'main.dart';
import 'utils.dart';
import 'providers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).textTheme.headline1!.color,
        title: const Text('Einstellungen'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
              minWidth: 100, maxWidth: 600, minHeight: 400),
          child: SettingsList(
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
                          deletePrefs().then((value) => Navigator.of(context)
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
