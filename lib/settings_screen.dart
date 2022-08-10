import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jagdverband_scraper/credentials_screen.dart';
import 'package:jagdverband_scraper/generated/l10n.dart';
import 'package:jagdverband_scraper/utils/request_methods.dart';
import 'package:jagdverband_scraper/widgets/chart_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
          child: _isLoading
              ? const CircularProgressIndicator(color: rehwildFarbe)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SettingsList(
                        darkTheme: const SettingsThemeData()
                            .copyWith(settingsListBackground: bg),
                        lightTheme: const SettingsThemeData()
                            .copyWith(settingsListBackground: bg),
                        sections: [
                          SettingsSection(
                            title: Text(
                              dg.settingsDisplay,
                              style: const TextStyle(color: rehwildFarbe),
                            ),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                onPressed: (context) => _pickLanguage(context),
                                leading: const Icon(Icons.language),
                                title: Text(dg.settingsLanguage),
                                value: Text(
                                    languages[Intl.getCurrentLocale()]!['nativeName']!),
                                //enabled: false, // TODO enable when implemented
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
                                  prefs.setBool('showPerson', value);

                                  setState(() => _showPerson = value);
                                },
                                description: Text(dg.settingsShowNamesBody),
                                initialValue: _showPerson,
                                leading: const Icon(Icons.person),
                                title: Text(dg.settingsShowNamesTitle),
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
                                      deletePrefs().then((value) =>
                                          Navigator.of(context).pushAndRemoveUntil(
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
                                title: Text(dg.settingsLogout),
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

                                    await launchUrl(uri,
                                            mode: LaunchMode.externalApplication)
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
                                    var cookies = await Requests.getStoredCookies(
                                        'stat.jagdverband.it');

                                    List<WebViewCookie> wvCookies = [];

                                    cookies.forEach((s, c) {
                                      wvCookies.add(WebViewCookie(
                                        name: c.name,
                                        value: c.value,
                                        domain: s,
                                      ));
                                    });

                                    String login = prefs.getString('revierLogin') ?? "";
                                    String pass = prefs.getString('revierPasswort') ?? "";

                                    if (!mounted) return;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => JagdverbandWebView(
                                          url: RequestMethods.baseURL,
                                          cookies: wvCookies,
                                          login: login,
                                          pass: pass,
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

                                  await launchUrl(uri)
                                      .timeout(const Duration(seconds: 10));
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
                                  applicationName: 'Jagdstatistik',
                                  applicationVersion: 'Version $appVersion',
                                  applicationLegalese: 'Dominic Schmid © 2022',
                                ),
                                leading: const Icon(Icons.app_registration_rounded),
                                title: Text(dg.settingsAbout),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // const Center(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(8.0),
                    //     child: Text(
                    //       'Version $appVersion © 2022',
                    //       style: TextStyle(color: Colors.grey),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
        ),
      ),
    );
  }

  _pickLanguage(BuildContext context) async {
    final dg = S.of(context);
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(dg.settingsLanguage, textAlign: TextAlign.center),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('English', textAlign: TextAlign.center),
                onPressed: () {
                  setState(() {
                    S.load(const Locale('en'));
                  });
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Deutsch', textAlign: TextAlign.center),
                onPressed: () {
                  setState(() {
                    S.load(const Locale('de'));
                  });
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Italiano', textAlign: TextAlign.center),
                onPressed: () {
                  setState(() {
                    S.load(const Locale('it'));
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
          showSnackBar('Du wirst jetzt angemeldet...', context);
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
