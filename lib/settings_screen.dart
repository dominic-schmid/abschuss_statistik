import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'utils.dart';
import 'providers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        foregroundColor: Theme.of(context).textTheme.headline1!.color,
        title: Text('Einstellungen'),
      ),
      body: SettingsList(
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
        ],
      ),
    );
  }
}
