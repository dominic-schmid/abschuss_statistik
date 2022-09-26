import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/providers/locale_provider.dart';
import 'package:jagdstatistik/providers/pref_provider.dart';
import 'package:jagdstatistik/providers/shooting_time_provider.dart';
import 'package:jagdstatistik/providers/theme_provider.dart';
import 'package:jagdstatistik/utils/local_auth_helper.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/add_kill/add_map_coordinates.dart';
import 'package:jagdstatistik/views/credentials_screen.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/constants.dart';
import 'package:jagdstatistik/utils/request_methods.dart';
import 'package:jagdstatistik/utils/translation_helper.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum SettingsInitStep {
  setDefaultPos,
}

class SettingsScreen extends StatefulWidget {
  final SettingsInitStep? initStep;
  const SettingsScreen({Key? key, this.initStep}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.initStep != null) {
        switch (widget.initStep) {
          case SettingsInitStep.setDefaultPos:
            await Future.delayed(const Duration(milliseconds: 250));
            _updateLatLng(closeOnSet: true);
            break;
          default:
            break;
        }
      }
    });
  }

  void _updateLatLng({bool closeOnSet = false}) async {
    final prefProvider = Provider.of<PrefProvider>(context, listen: false);
    final shootingTimeProvider =
        Provider.of<ShootingTimeProvider>(context, listen: false);
    // Get device stored coords for default view position
    final latLng = prefProvider.latLng;

    LatLng? newLatLng = await Navigator.of(context).push(
      MaterialPageRoute<LatLng>(
        builder: (context) => AddMapCoordsScreen(
          initCoords: latLng ?? Constants.bolzanoCoords, // Bolzano default if none set
          zoom: latLng == null ? 10 : 12.5,
        ),
      ),
    );

    if (newLatLng != null && mounted) {
      await prefProvider.setLatLng(newLatLng);
      await shootingTimeProvider.setLatLng(newLatLng);
      if (mounted && closeOnSet) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // listen for locale changes
    final localeProvider = Provider.of<LocaleProvider>(context);
    final prefProvider = Provider.of<PrefProvider>(context);

    final dg = S.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color bg = Theme.of(context).scaffoldBackgroundColor;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).textTheme.headline1!.color,
        backgroundColor: bg,
        title: Text(dg.settingsTitle),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 600, minHeight: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: SettingsList(
                  darkTheme:
                      const SettingsThemeData().copyWith(settingsListBackground: bg),
                  lightTheme:
                      const SettingsThemeData().copyWith(settingsListBackground: bg),
                  sections: [
                    SettingsSection(
                      title: Text(
                        dg.settingsDisplay,
                        style: const TextStyle(color: rehwildFarbe),
                      ),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          onPressed: (context) async {
                            Locale? newLocale = await showLanguagePicker(context);
                            // await prefs.setString('language', );
                            if (newLocale != null && mounted) {
                              localeProvider.updateLocale(newLocale);
                            }
                          },
                          leading: const Icon(Icons.language),
                          title: Text(dg.settingsLanguage),
                          value: Text(languages[Intl.getCurrentLocale()]!['nativeName']!),
                        ),
                        SettingsTile.switchTile(
                          onToggle: (value) {
                            themeProvider.toggleTheme(themeProvider.isDarkMode);
                          },
                          initialValue: themeProvider.isDarkMode,
                          leading: const Icon(Icons.format_paint),
                          title: Text(dg.settingsDarkMode),
                        ),
                        SettingsTile.switchTile(
                          onToggle: (value) {
                            prefProvider.get.setBool('showPerson', value);
                            prefProvider.update();
                          },
                          description: Text(dg.settingsShowNamesBody),
                          initialValue: prefProvider.showPerson,
                          leading: const Icon(Icons.person),
                          title: Text(dg.settingsShowNamesTitle),
                        ),
                        SettingsTile.switchTile(
                          onToggle: (value) {
                            prefProvider.get.setBool('betaMode', value);
                            prefProvider.update();
                          },
                          description: Text(dg.betaModeDescription),
                          initialValue: prefProvider.betaMode,
                          leading: const Icon(Icons.construction_rounded),
                          title: Text(dg.betaModeTitle),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: Text(
                        dg.appSettings,
                        style: const TextStyle(color: rehwildFarbe),
                      ),
                      tiles: <SettingsTile>[
                        SettingsTile.switchTile(
                          onToggle: (value) async {
                            bool hasBiometrics = await LocalAuthApi.hasBiometrics();
                            // If trying to enable biometrics when there are none found => error
                            if (value == true && !hasBiometrics && mounted) {
                              await showSnackBar(dg.noBiometricsFound, context);
                              return;
                            }
                            prefProvider.get.setBool('localAuth', value);
                            prefProvider.update();
                          },
                          description: Text(dg.empfohlen),
                          initialValue: prefProvider.localAuth,
                          leading: const Icon(Icons.fingerprint_rounded),
                          title: Text(dg.useLocalAuth),
                        ),
                        SettingsTile(
                          onPressed: (context) => _updateLatLng(),
                          title: Text(dg.defaultLocationTitle),
                          description: Text(dg.defaultLocationDescription),
                          leading: const Icon(Icons.map_rounded),
                        ),
                      ],
                    ),
                    SettingsSection(
                        title: Text(
                          dg.settingsLinks,
                          style: const TextStyle(color: rehwildFarbe),
                        ),
                        tiles: <SettingsTile>[
                          SettingsTile(
                            onPressed: (value) async {
                              Uri uri = Uri(
                                scheme: 'https',
                                path: 'buymeacoffee.com/dominic.schmid',
                              );

                              await launchUrl(uri, mode: LaunchMode.externalApplication)
                                  .timeout(const Duration(seconds: 10));
                            },
                            leading: Icon(
                              Icons.favorite_rounded,
                              color: Colors.red.withAlpha(180),
                            ),
                            title: Text(dg.settingsDonate),
                          ),
                          SettingsTile(
                            onPressed: (value) async {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => const MyStatistikWebView(
                              //       url: 'https://jagdstatistik.com',
                              //     ),
                              //   ),
                              // );

                              await launchUrl(
                                      Uri(
                                        scheme: 'https',
                                        path: 'www.jagdstatistik.com',
                                      ),
                                      mode: LaunchMode.externalApplication)
                                  .timeout(const Duration(seconds: 10));
                            },
                            leading: Icon(
                              Icons.language_rounded,
                              color: Colors.blue[300],
                            ),
                            title: Text(dg.settingsWebsite),
                          ),
                          SettingsTile(
                            onPressed: (value) async {
                              var cookies =
                                  await Requests.getStoredCookies('stat.jagdverband.it');

                              List<WebViewCookie> wvCookies = [];

                              cookies.forEach((s, c) {
                                wvCookies.add(WebViewCookie(
                                  name: c.name,
                                  value: c.value,
                                  domain: s,
                                ));
                              });

                              if (!mounted) return;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => JagdverbandWebView(
                                    url: RequestMethods.baseURL,
                                    cookies: wvCookies,
                                    login: prefProvider.login,
                                    pass: prefProvider.password,
                                  ),
                                ),
                              );

                              // await launchUrl(uri,
                              //         mode: LaunchMode.externalApplication)
                              //     .timeout(const Duration(seconds: 10));
                            },
                            leading: const Icon(
                              Icons.open_in_browser_rounded,
                              color: Colors.orange,
                            ),
                            title: Text(dg.settingsHuntersAssociationWebsite),
                          ),
                        ]),
                    SettingsSection(
                      title: Text(
                        dg.settingsDevelopment,
                        style: const TextStyle(color: rehwildFarbe),
                      ),
                      tiles: <SettingsTile>[
                        SettingsTile(
                          onPressed: (value) async {
                            Uri uri = Uri(
                              scheme: 'mailto',
                              path: 'feedback@jagdstatistik.com',
                              queryParameters: {'subject': dg.feedbackMailSubject},
                            );

                            await launchUrl(uri).timeout(const Duration(seconds: 10));
                          },
                          leading: const Icon(Icons.mail),
                          title: Text(dg.settingsKontakt),
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
                            applicationName: dg.appTitle,
                            applicationVersion: 'Version ${Constants.appVersion}',
                            applicationLegalese: Constants.appLegalese,
                          ),
                          leading: const Icon(Icons.app_registration_rounded),
                          title: Text(dg.settingsAbout),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: Text(
                        dg.settingsAccount,
                        style: const TextStyle(color: rehwildFarbe),
                      ),
                      tiles: <SettingsTile>[
                        SettingsTile(
                          onPressed: (value) async {
                            await showAlertDialog(
                              title: ' ${dg.settingsLogout}',
                              description: dg.dialogLogoutBody,
                              yesOption: dg.dialogYes,
                              noOption: dg.dialogNo,
                              onYes: () {
                                deletePrefs().then(
                                  (value) => Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const CredentialsScreen()),
                                    (route) => false,
                                  ),
                                );
                              },
                              icon: Icons.warning,
                              context: context,
                            );
                          },
                          leading: const Icon(Icons.logout),
                          title: Text(dg.settingsLogout),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JagdverbandWebView extends StatefulWidget {
  final String url;

  final List<WebViewCookie> cookies;

  final String login;
  final String pass;

  const JagdverbandWebView({
    Key? key,
    required this.url,
    required this.cookies,
    required this.login,
    required this.pass,
  }) : super(key: key);

  @override
  State<JagdverbandWebView> createState() => _JagdverbandWebViewState();
}

class _JagdverbandWebViewState extends State<JagdverbandWebView> {
  WebViewController? ctrl;

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    print('Opening WebView for ${widget.url}');
    for (var c in widget.cookies) {
      print('Using Cookie: ${c.domain} ${c.name} ${c.value}');
    }

    return Scaffold(
      appBar: const ChartAppBar(title: Text('Jagdverband'), actions: []),
      body: WebView(
        initialCookies: widget.cookies,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
        onWebViewCreated: (controller) {
          ctrl = controller;
          // controller.loadUrl(widget.url, headers: RequestMethods.baseHeaders);
          showSnackBar(dg.willBeLoggedInAuto, context);
        },
        onPageFinished: (page) async {
          if (ctrl != null) {
            await ctrl!.runJavascript(
                "document.getElementById('login-username').value = '${widget.login}'");
            await ctrl!.runJavascript(
                "document.getElementById('login-password').value = '${widget.pass}'");
            await ctrl!.runJavascript(
                " document.querySelectorAll('input[type=submit]')[0].click();");
          }
        },
      ),
    );
  }
}

class MyStatistikWebView extends StatelessWidget {
  final String url;

  const MyStatistikWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Opening WebView for $url');

    return Scaffold(
      appBar: const ChartAppBar(title: Text('Jagdstatistik'), actions: []),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
