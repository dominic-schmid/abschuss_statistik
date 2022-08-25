import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/database_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> getDefaultPrefs() => {
      'login': '',
      'pass': '',
      'isDarkMode': true,
      'language': 'de',
    };

Future<Map<String, String>?> loadCredentialsFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String revierLogin = prefs.getString('revierLogin') ?? "";
  String revierPasswort = prefs.getString('revierPasswort') ?? "";

  if (revierLogin.isNotEmpty && revierPasswort.isNotEmpty) {
    print('Read credentials: `$revierLogin` `$revierPasswort`');
    return {
      'revierLogin': revierLogin,
      'revierPasswort': revierPasswort,
    };
  } else {
    return null;
  }
}

Future<void> deletePrefs() async {
  try {
    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.remove('revierLogin');
      await prefs.remove('revierPasswort');
    });
    await SqliteDB().delteDb();
  } catch (e) {
    print('Error deleting preferences! ${e.toString()}');
  }
}

showSnackBar(String content, BuildContext context, {int duration = 1500}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: duration),
      content: Text(content),
    ),
  );
}

Future<dynamic> showAlertDialog({
  required String title,
  required String description,
  required String yesOption,
  required String noOption,
  required VoidCallback? onYes,
  required IconData icon,
  required BuildContext context,
}) {
  // set up the buttons
  Widget cancelButton = MaterialButton(
    child: Text(noOption),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = MaterialButton(
    onPressed: () {
      if (onYes != null) {
        onYes();
      }
      Navigator.of(context).pop(true);
    },
    child: Text(yesOption),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Row(
      children: [
        Icon(icon),
        Text(title),
      ],
    ),
    content: Text(description),
    actions: [
      yesOption.isNotEmpty ? continueButton : Container(),
      cancelButton,
    ],
  );
  // show the dialog
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

const primaryColor = Colors.white;
Color secondaryColor = Colors.white.withAlpha(170);
const invertedPrimaryColor = Colors.black;

const rehwildFarbe = Color.fromRGBO(73, 130, 5, 1);
const rotwildFarbe = Color.fromRGBO(230, 74, 25, 1);
const gamswildFarbe = Color.fromRGBO(0, 183, 195, 1);
const steinwildFarbe = Color.fromRGBO(175, 180, 43, 1);
const schwarzwildFarbe =
    Color.fromRGBO(188, 170, 164, 1); //Color.fromRGBO(35, 35, 35, 1);
const spielhahnFarbe = Color.fromRGBO(255, 87, 34, 1);
const steinhuhnFarbe = Color.fromRGBO(0, 137, 123, 1);
const schneehuhnFarbe = Color.fromRGBO(116, 77, 169, 1);
const murmeltierFarbe = Color.fromRGBO(136, 14, 79, 1);
const dachsFarbe = Color.fromRGBO(144, 164, 174, 1); // Color.fromRGBO(66, 66, 66, 1);
const fuchsFarbe = Color.fromRGBO(255, 140, 0, 1);
const schneehaseFarbe = Color.fromRGBO(107, 105, 214, 1);
const wildFarbe = Color.fromRGBO(16, 137, 62, 1);

const erlegtFarbe = Color.fromRGBO(76, 175, 80, 1);
const fallwildFarbe = Color.fromRGBO(121, 85, 72, 1);
const hegeabschussFarbe = Color.fromRGBO(255, 87, 34, 1);
const strassenunfallFarbe = Color.fromRGBO(144, 144, 97, 1);
const protokollFarbe = Color.fromRGBO(156, 39, 176, 1);
const zugFarbe = Color.fromRGBO(175, 180, 43, 1);
const freizoneFarbe = Color.fromRGBO(92, 107, 192, 1);

const eigengebrauchFarbe = Color.fromRGBO(76, 175, 80, 1);
const weiterverarbeitungFarbe = Color.fromRGBO(245, 127, 23, 1);
const verkaufFarbe = Color.fromRGBO(63, 81, 181, 1);
const nichtVerwertbarFarbe = Color.fromRGBO(144, 97, 97, 1);
const nichtGefundenFarbe = Color.fromRGBO(0, 121, 107, 1);
const nichtBekanntFarbe = Color.fromRGBO(233, 30, 99, 1);

List<Map<String, String>> getBaseGroupBys(BuildContext ctx) {
  final dg = S.of(ctx);
  return [
    {
      'key': dg.gameTypes,
      'value': 'wildart',
    },
    {
      'key': dg.sexes,
      'value': 'geschlecht',
    },
    {
      'key': dg.sortPlace,
      'value': 'hegeinGebietRevierteil',
    },
    {
      'key': dg.causes,
      'value': 'ursache',
    },
    {
      'key': dg.usages,
      'value': 'verwendung',
    },
    {
      'key': dg.signOfOrigin,
      'value': 'ursprungszeichen',
    },
    //  'datetime': k.datetime.toIso8601String(),
  ];
}

const ShapeBorder modalShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
);

Future<void> showLanguagePicker(BuildContext context) async {
  final dg = S.of(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(dg.settingsLanguage, textAlign: TextAlign.center),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('English', textAlign: TextAlign.center),
              onPressed: () async {
                await S.load(const Locale('en'));
                await prefs.setString('language', 'en');
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Deutsch', textAlign: TextAlign.center),
              onPressed: () async {
                await S.load(const Locale('de'));
                await prefs.setString('language', 'de');
                print('wrote de to prefs');
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Italiano', textAlign: TextAlign.center),
              onPressed: () async {
                await S.load(const Locale('it'));
                await prefs.setString('language', 'it');
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
