import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/credentials_screen.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/utils.dart';
import 'utils/providers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;

  late SharedPreferences prefs;
  late bool _showPerson;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  void loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _showPerson = prefs.getBool('showPerson') ?? false;
    //await prefs.setBool('showPerson', value);

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color bg = Theme.of(context).scaffoldBackgroundColor;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
          child: _isLoading
              ? const CircularProgressIndicator(color: rehwildFarbe)
              : Column(
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
                                enabled: false, // TODO enable when implemented
                              ),
                              SettingsTile.switchTile(
                                onToggle: (value) {
                                  themeProvider
                                      .toggleTheme(themeProvider.isDarkMode);
                                },
                                initialValue: themeProvider.isDarkMode,
                                leading: const Icon(Icons.format_paint),
                                title: const Text('Dunkler Modus'),
                              ),
                              SettingsTile.switchTile(
                                onToggle: (value) {
                                  prefs.setBool('showPerson', value);

                                  setState(() => _showPerson = value);
                                },
                                description: const Text(
                                    'Es kann je nach Benutzer sein, dass dabei nur Sterne angezeigt werden können.'),
                                initialValue: _showPerson,
                                leading: const Icon(Icons.person),
                                title: const Text('Namen anzeigen'),
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
                                      deletePrefs().then((value) =>
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CredentialsScreen()),
                                            (route) => false,
                                          ));
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
                          SettingsSection(
                            title: const Text(
                              'Entwicklung',
                              style: TextStyle(color: rehwildFarbe),
                            ),
                            tiles: <SettingsTile>[
                              SettingsTile(
                                onPressed: (value) async {
                                  Uri uri = Uri(
                                    scheme: 'mailto',
                                    path: 'dominic.schmid@hotmail.com',
                                    queryParameters: {
                                      'subject':
                                          'Feedback zur Jagdstatistik App'
                                    },
                                  );

                                  print(uri.toString());

                                  await launchUrl(uri)
                                      .timeout(const Duration(seconds: 10));
                                },
                                leading: const Icon(Icons.mail),
                                title: const Text('Kontakt'),
                              ),
                              SettingsTile(
                                onPressed: (value) async {
                                  Uri uri = Uri(
                                    scheme: 'https',
                                    path: 'buymeacoffee.com/dominic.schmid',
                                  );

                                  await launchUrl(uri,
                                          mode: LaunchMode.externalApplication)
                                      .timeout(const Duration(seconds: 10));
                                },
                                leading: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red.withAlpha(180),
                                ),
                                title: const Text('Speck spendieren'),
                              ),
                              SettingsTile(
                                onPressed: (value) async {
                                  Uri uri = Uri(
                                    scheme: 'https',
                                    path: 'jagdstatistik.com/',
                                  );

                                  await launchUrl(uri,
                                          mode: LaunchMode.externalApplication)
                                      .timeout(const Duration(seconds: 10));
                                },
                                leading: const Icon(Icons.language_rounded),
                                title: const Text('Webseite'),
                              ),
                              SettingsTile(
                                onPressed: (value) => showAboutDialog(
                                    context: context,
                                    applicationIcon: ImageIcon(
                                      const AssetImage(
                                        'assets/ic_launcher_adaptive_fore.png',
                                      ),
                                      size: size.width * 0.1,
                                    ),
                                    applicationName: 'Jagdstatistik',
                                    applicationVersion: 'Version $appVersion',
                                    applicationLegalese:
                                        'Dominic Schmid © 2022'),
                                leading:
                                    const Icon(Icons.app_registration_rounded),
                                title: const Text('Über'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Version $appVersion © 2022',
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
