// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(x, y) => "Sieh dir diesen Abschuss in ${x} an!\n${y}";

  static String m1(x, y) => "Zeige ${x} von ${y}";

  static String m2(x) => "${x} Abschüsse filtern";

  static String m3(x, y, z) => "Gesehen von ${x} am ${y} um ${z}";

  static String m4(howMany) =>
      "${Intl.plural(howMany, one: '1 Abschuss', other: '${howMany} Abschüsse')}";

  static String m5(x) => "Es wurden ${x} neue Abschüsse gefunden!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M": MessageLookupByLibrary.simpleMessage("Männlich"),
        "W": MessageLookupByLibrary.simpleMessage("Weiblich"),
        "age": MessageLookupByLibrary.simpleMessage("Alter"),
        "altgeiss": MessageLookupByLibrary.simpleMessage("Altgeiß"),
        "alttier": MessageLookupByLibrary.simpleMessage("Alttier"),
        "andereWildart": MessageLookupByLibrary.simpleMessage("Andere Wildart"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Jagdstatistik"),
        "area": MessageLookupByLibrary.simpleMessage("Gebiet"),
        "bache": MessageLookupByLibrary.simpleMessage("Bache"),
        "bockjahrling": MessageLookupByLibrary.simpleMessage("Bockjährling"),
        "bockkitz": MessageLookupByLibrary.simpleMessage("Bockkitz"),
        "causes": MessageLookupByLibrary.simpleMessage("Ursachen"),
        "chartBasedOnDownloaded": MessageLookupByLibrary.simpleMessage(
            "Die Diagramme basieren auf deinen heruntergeladenen Daten. Falls ein Jahr fehlt, kannst du es auf der Startseite auswählen und heruntergeladen.\n\nDiese Diagramme bieten Aufschluss über die historische Entwicklung des Wilds in deinem Revier und wurden so gestaltet, dass du dir den Aufbau selbst konfigurieren kannst!"),
        "checkOutThisKillXY": m0,
        "close": MessageLookupByLibrary.simpleMessage("Schließen"),
        "companion": MessageLookupByLibrary.simpleMessage("Begleiter"),
        "configuration": MessageLookupByLibrary.simpleMessage("Konfiguration"),
        "copiedToClipboardSnackbar":
            MessageLookupByLibrary.simpleMessage("In Zwischenablage kopiert!"),
        "credentialsScreen": MessageLookupByLibrary.simpleMessage("Anmeldedaten"),
        "credsDisclaimerText": MessageLookupByLibrary.simpleMessage(
            "Deine Anmeldedaten werden nur lokal gespeichert und verwendet, um die Abschüsse von der Seite des Jagdverbands herunterzuladen.\nSie werden niemals an Dritte weitergegeben!"),
        "credsEmptySnackbar":
            MessageLookupByLibrary.simpleMessage("Du musst beide Felder angeben!"),
        "credsLoginButton": MessageLookupByLibrary.simpleMessage("ANMELDEN"),
        "credsLoginErrorSnackbar": MessageLookupByLibrary.simpleMessage(
            "Fehler: Zu diesen Daten gibt es kein Revier!"),
        "credsLoginTitle": MessageLookupByLibrary.simpleMessage("Anmelden"),
        "credsPasswordFieldHint": MessageLookupByLibrary.simpleMessage("Passwort"),
        "credsPasswordFieldTitle": MessageLookupByLibrary.simpleMessage("Passwort"),
        "credsTerritoryFieldHint":
            MessageLookupByLibrary.simpleMessage("z.B. Bruneck13L"),
        "credsTerritoryFieldTitle": MessageLookupByLibrary.simpleMessage("Revier"),
        "credsTooManySigninsSnackbar": MessageLookupByLibrary.simpleMessage(
            "Zu oft angemeldet! Warte 1 Minute bevor du dich erneut anmelden kannst."),
        "dachs": MessageLookupByLibrary.simpleMessage("Dachs"),
        "dialogLogoutBody": MessageLookupByLibrary.simpleMessage(
            "Möchtest du dich wirklich abmelden?\nDeine Anmeldedaten und alle deiner Einstellungen werden dabei gelöscht!"),
        "dialogNo": MessageLookupByLibrary.simpleMessage("Nein"),
        "dialogYes": MessageLookupByLibrary.simpleMessage("Ja"),
        "display": MessageLookupByLibrary.simpleMessage("Anzeige"),
        "distribution": MessageLookupByLibrary.simpleMessage("Verteilung"),
        "eigengebrauch": MessageLookupByLibrary.simpleMessage("Eigengebrauch"),
        "eigengebrauchAbgabe": MessageLookupByLibrary.simpleMessage(
            "Eigengebrauch - Abgabe zur Weiterverarbeitung"),
        "erlegt": MessageLookupByLibrary.simpleMessage("Erlegt"),
        "error": MessageLookupByLibrary.simpleMessage("Fehler"),
        "fallwild": MessageLookupByLibrary.simpleMessage("Fallwild"),
        "feedbackMailSubject":
            MessageLookupByLibrary.simpleMessage("Feedback zur Jagdstatistik App"),
        "freizone": MessageLookupByLibrary.simpleMessage("Freizone"),
        "frischling": MessageLookupByLibrary.simpleMessage("Frischling"),
        "fuchs": MessageLookupByLibrary.simpleMessage("Fuchs"),
        "gameTypes": MessageLookupByLibrary.simpleMessage("Wildarten"),
        "gamsbock": MessageLookupByLibrary.simpleMessage("Gamsbock"),
        "gamsgeiss": MessageLookupByLibrary.simpleMessage("Gamsgeiß"),
        "gamsjahrlinge": MessageLookupByLibrary.simpleMessage("Gamsjahrlinge"),
        "gamswild": MessageLookupByLibrary.simpleMessage("Gamswild"),
        "geissjahrling": MessageLookupByLibrary.simpleMessage("Geißjährling"),
        "geisskitz": MessageLookupByLibrary.simpleMessage("Geißkitz"),
        "grid": MessageLookupByLibrary.simpleMessage("Gitter"),
        "hegeabschuss": MessageLookupByLibrary.simpleMessage("Hegeabschuss"),
        "hirschkalb": MessageLookupByLibrary.simpleMessage("Hirschkalb"),
        "historic": MessageLookupByLibrary.simpleMessage("Historisch"),
        "hunter": MessageLookupByLibrary.simpleMessage("Jäger"),
        "jahrlingsHirsch": MessageLookupByLibrary.simpleMessage("Jährlingshirsch"),
        "jahrlingsbock": MessageLookupByLibrary.simpleMessage("Jährlingsbock"),
        "kahlwild": MessageLookupByLibrary.simpleMessage("Kahlwild"),
        "keiler": MessageLookupByLibrary.simpleMessage("Keiler"),
        "killer": MessageLookupByLibrary.simpleMessage("Erleger"),
        "kills": MessageLookupByLibrary.simpleMessage("Abschüsse"),
        "ksExport": MessageLookupByLibrary.simpleMessage("Export"),
        "ksExportDialogTitle": MessageLookupByLibrary.simpleMessage("Exportieren als"),
        "ksShowXFromYProgressBar": m1,
        "ksTerritoryTitle": MessageLookupByLibrary.simpleMessage("Revier"),
        "loginDataInvalid": MessageLookupByLibrary.simpleMessage(
            "Deine Anmeldedaten sind nicht mehr gültig!"),
        "maennlich": MessageLookupByLibrary.simpleMessage("Männlich"),
        "mapInitialPosition": MessageLookupByLibrary.simpleMessage("Anfangsposition"),
        "monthlyBreakdown": MessageLookupByLibrary.simpleMessage("Monatsverlauf"),
        "murmeltier": MessageLookupByLibrary.simpleMessage("Murmeltier"),
        "newKills": MessageLookupByLibrary.simpleMessage("Neue Abschüsse"),
        "nichtBekannt": MessageLookupByLibrary.simpleMessage("Nicht bekannt"),
        "nichtGefunden":
            MessageLookupByLibrary.simpleMessage("Nicht gefunden / Nachsuche erfolglos"),
        "nichtVerwertbar": MessageLookupByLibrary.simpleMessage("Nicht verwertbar"),
        "noDataFoundText":
            MessageLookupByLibrary.simpleMessage("Hier gibt es nichts zu sehen..."),
        "noInternetError": MessageLookupByLibrary.simpleMessage("Fehler: Kein Internet"),
        "noKillsFoundError":
            MessageLookupByLibrary.simpleMessage("Fehler: Keine Abschüsse gefunden!"),
        "noKillsLoadedError": MessageLookupByLibrary.simpleMessage(
            "Fehler: Abschüsse konnten nicht geladen werden!"),
        "number": MessageLookupByLibrary.simpleMessage("Nummer"),
        "onlyShot": MessageLookupByLibrary.simpleMessage("Nur Erlegte"),
        "overseer": MessageLookupByLibrary.simpleMessage("Aufseher"),
        "perMonth": MessageLookupByLibrary.simpleMessage("pro Monat"),
        "points": MessageLookupByLibrary.simpleMessage("Punkte"),
        "protokollBeschlagnahmt":
            MessageLookupByLibrary.simpleMessage("Protokoll / beschlagnahmt"),
        "rehwild": MessageLookupByLibrary.simpleMessage("Rehwild"),
        "rotwild": MessageLookupByLibrary.simpleMessage("Rotwild"),
        "schmalreh": MessageLookupByLibrary.simpleMessage("Schmalreh"),
        "schmaltier": MessageLookupByLibrary.simpleMessage("Schmaltier"),
        "schneehase": MessageLookupByLibrary.simpleMessage("Schneehase"),
        "schneehuhn": MessageLookupByLibrary.simpleMessage("Schneehuhn"),
        "schwarzwild": MessageLookupByLibrary.simpleMessage("Schwarzwild"),
        "searchXKills": m2,
        "seenByXonYatZ": m3,
        "settingsAbout": MessageLookupByLibrary.simpleMessage("Über"),
        "settingsAccount": MessageLookupByLibrary.simpleMessage("Konto"),
        "settingsDarkMode": MessageLookupByLibrary.simpleMessage("Dunkler Modus"),
        "settingsDevelopment": MessageLookupByLibrary.simpleMessage("Entwicklung"),
        "settingsDisplay": MessageLookupByLibrary.simpleMessage("Anzeige"),
        "settingsDonate": MessageLookupByLibrary.simpleMessage("Speck spendieren"),
        "settingsHuntersAssociationWebsite":
            MessageLookupByLibrary.simpleMessage("Jagdverband Statistik"),
        "settingsKontakt": MessageLookupByLibrary.simpleMessage("Kontakt"),
        "settingsLanguage": MessageLookupByLibrary.simpleMessage("Sprache"),
        "settingsLinks": MessageLookupByLibrary.simpleMessage("Links"),
        "settingsLogout": MessageLookupByLibrary.simpleMessage("Abmelden"),
        "settingsShowNamesBody": MessageLookupByLibrary.simpleMessage(
            "Es könnte sein, dass dabei nur Sterne angezeigt werden können."),
        "settingsShowNamesTitle": MessageLookupByLibrary.simpleMessage("Namen anzeigen"),
        "settingsTitle": MessageLookupByLibrary.simpleMessage("Einstellunge"),
        "settingsWebsite": MessageLookupByLibrary.simpleMessage("Webseite"),
        "sexes": MessageLookupByLibrary.simpleMessage("Geschlechter"),
        "signOfOrigin": MessageLookupByLibrary.simpleMessage("Ursprungszeichen"),
        "sortCause": MessageLookupByLibrary.simpleMessage("Ursache"),
        "sortDate": MessageLookupByLibrary.simpleMessage("Datum"),
        "sortGameType": MessageLookupByLibrary.simpleMessage("Wildart"),
        "sortGender": MessageLookupByLibrary.simpleMessage("Geschlecht"),
        "sortNone": MessageLookupByLibrary.simpleMessage("Keine Sortierung"),
        "sortNumber": MessageLookupByLibrary.simpleMessage("Nummer"),
        "sortPlace": MessageLookupByLibrary.simpleMessage("Örtlichkeit"),
        "sortTitle": MessageLookupByLibrary.simpleMessage("Sortierung"),
        "sortUse": MessageLookupByLibrary.simpleMessage("Verwendung"),
        "sortWeight": MessageLookupByLibrary.simpleMessage("Gewicht"),
        "spielhahn": MessageLookupByLibrary.simpleMessage("Spielhahn"),
        "statistics": MessageLookupByLibrary.simpleMessage("Statistik"),
        "steinbock": MessageLookupByLibrary.simpleMessage("Steinbock"),
        "steingeiss": MessageLookupByLibrary.simpleMessage("Steingeiß"),
        "steinhuhn": MessageLookupByLibrary.simpleMessage("Steinhuhn"),
        "steinwild": MessageLookupByLibrary.simpleMessage("Steinwild"),
        "strassenunfall": MessageLookupByLibrary.simpleMessage("Straßenunfall"),
        "sum": MessageLookupByLibrary.simpleMessage("Summe"),
        "tBock": MessageLookupByLibrary.simpleMessage("T-Bock"),
        "time": MessageLookupByLibrary.simpleMessage("Uhrzeit"),
        "trophaehenHirsch": MessageLookupByLibrary.simpleMessage("Trophäenhirsch"),
        "ueberlaeuferBache": MessageLookupByLibrary.simpleMessage("Überläuferbache"),
        "ueberlaeuferKeiler": MessageLookupByLibrary.simpleMessage("Überläuferkeiler"),
        "usage": MessageLookupByLibrary.simpleMessage("Verwendung"),
        "usages": MessageLookupByLibrary.simpleMessage("Verwendungen"),
        "verkauf": MessageLookupByLibrary.simpleMessage("Verkauf"),
        "vomZug": MessageLookupByLibrary.simpleMessage("Vom zug überfahren"),
        "weiblich": MessageLookupByLibrary.simpleMessage("Weiblich"),
        "weiblicheRehe": MessageLookupByLibrary.simpleMessage("Weibliche Rehe"),
        "weight": MessageLookupByLibrary.simpleMessage("Gewicht"),
        "wildkalb": MessageLookupByLibrary.simpleMessage("Wildkalb"),
        "xKill_s": m4,
        "xNewKillsFound": m5,
        "yearly": MessageLookupByLibrary.simpleMessage("Jährlich"),
        "yearlyBreakdown": MessageLookupByLibrary.simpleMessage("Jahresverlauf")
      };
}