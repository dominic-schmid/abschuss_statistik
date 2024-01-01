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

  static String m4(link) => "Schau dir die Jagdstatistik App an!\n\n${link}";

  static String m5(x) => "Jagdzeiten ${x} ";

  static String m6(howMany) =>
      "${Intl.plural(howMany, one: '1 Abschuss', other: '${howMany} Abschüsse')}";

  static String m7(x) => "Es wurden ${x} neue Abschüsse gefunden!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M": MessageLookupByLibrary.simpleMessage("Männlich"),
        "W": MessageLookupByLibrary.simpleMessage("Weiblich"),
        "addKill": MessageLookupByLibrary.simpleMessage("Abschuss hinzufügen"),
        "age": MessageLookupByLibrary.simpleMessage("Alter"),
        "altgeiss": MessageLookupByLibrary.simpleMessage("Altgeiß"),
        "alttier": MessageLookupByLibrary.simpleMessage("Alttier"),
        "andereWildart": MessageLookupByLibrary.simpleMessage("Andere Wildart"),
        "appSettings": MessageLookupByLibrary.simpleMessage("App"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Jagdstatistik"),
        "area": MessageLookupByLibrary.simpleMessage("Gebiet"),
        "bache": MessageLookupByLibrary.simpleMessage("Bache"),
        "betaModeDescription": MessageLookupByLibrary.simpleMessage(
            "Einige Features funktionieren möglicherweise nicht richtig."),
        "betaModeTitle": MessageLookupByLibrary.simpleMessage("Beta Modus"),
        "biometrics": MessageLookupByLibrary.simpleMessage("Biometrie"),
        "bockjahrling": MessageLookupByLibrary.simpleMessage("Bockjährling"),
        "bockkitz": MessageLookupByLibrary.simpleMessage("Bockkitz"),
        "border": MessageLookupByLibrary.simpleMessage("Grenze"),
        "both": MessageLookupByLibrary.simpleMessage("Beide"),
        "brutzeit": MessageLookupByLibrary.simpleMessage("Brutzeit"),
        "causes": MessageLookupByLibrary.simpleMessage("Ursachen"),
        "chartBasedOnDownloaded": MessageLookupByLibrary.simpleMessage(
            "Die Diagramme basieren auf deinen heruntergeladenen Daten. Falls ein Jahr fehlt, kannst du es auf der Startseite auswählen und herunterladen.\n\nDiese Diagramme bieten Aufschluss über die historische Entwicklung des Wilds in deinem Revier und wurden so gestaltet, dass du dir den Aufbau selbst konfigurieren kannst!"),
        "checkOutThisKillXY": m0,
        "close": MessageLookupByLibrary.simpleMessage("Schließen"),
        "companion": MessageLookupByLibrary.simpleMessage("Begleiter"),
        "configuration": MessageLookupByLibrary.simpleMessage("Konfiguration"),
        "confirm": MessageLookupByLibrary.simpleMessage("Bestätigen"),
        "confirmAddKillCancel": MessageLookupByLibrary.simpleMessage(
            "Willst du die Bearbeitung des neuen Abschusses wirklich abbrechen?"),
        "confirmDeleteDatabase": MessageLookupByLibrary.simpleMessage(
            "Bist du sicher, dass du die Datenbank zurücksetzen möchtest?"),
        "copiedToClipboardSnackbar":
            MessageLookupByLibrary.simpleMessage("In Zwischenablage kopiert!"),
        "credentialsScreen":
            MessageLookupByLibrary.simpleMessage("Anmeldedaten"),
        "credsDisclaimerText": MessageLookupByLibrary.simpleMessage(
            "Deine Anmeldedaten werden nur lokal gespeichert und verwendet, um die Abschüsse von der Seite des Jagdverbands herunterzuladen.\nSie werden niemals an Dritte weitergegeben!"),
        "credsEmptySnackbar": MessageLookupByLibrary.simpleMessage(
            "Du musst beide Felder angeben!"),
        "credsLoginButton": MessageLookupByLibrary.simpleMessage("ANMELDEN"),
        "credsLoginErrorSnackbar": MessageLookupByLibrary.simpleMessage(
            "Fehler: Zu diesen Daten gibt es kein Revier!"),
        "credsLoginTitle": MessageLookupByLibrary.simpleMessage("Anmelden"),
        "credsPasswordFieldHint":
            MessageLookupByLibrary.simpleMessage("Passwort"),
        "credsPasswordFieldTitle":
            MessageLookupByLibrary.simpleMessage("Passwort"),
        "credsTerritoryFieldHint":
            MessageLookupByLibrary.simpleMessage("z.B. Bruneck13L"),
        "credsTerritoryFieldTitle":
            MessageLookupByLibrary.simpleMessage("Revier"),
        "credsTooManySigninsSnackbar": MessageLookupByLibrary.simpleMessage(
            "Zu oft angemeldet! Warte 1 Minute bevor du dich erneut anmelden kannst."),
        "dachs": MessageLookupByLibrary.simpleMessage("Dachs"),
        "dateEmptyError":
            MessageLookupByLibrary.simpleMessage("Datum darf nicht leer sein"),
        "dateInFutureError":
            MessageLookupByLibrary.simpleMessage("Zeitpunkt ungültig"),
        "defaultLocationDescription": MessageLookupByLibrary.simpleMessage(
            "Standard Ansicht beim Hinzufügen eines Abschusses oder der Berechnung der Schusszeiten."),
        "defaultLocationTitle":
            MessageLookupByLibrary.simpleMessage("Startpunkt festlegen"),
        "deleteDatabaseDescription": MessageLookupByLibrary.simpleMessage(
            "Lösche Abschüsse und lade sie neu herunter. Führe diese Operation aus, um eventuelle Fehler zu beheben."),
        "deleteDatabaseTitle":
            MessageLookupByLibrary.simpleMessage("Datenbank zurücksetzen"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "dialogLogoutBody": MessageLookupByLibrary.simpleMessage(
            "Möchtest du dich wirklich abmelden?\nDeine Anmeldedaten und alle deiner Einstellungen werden dabei gelöscht!"),
        "dialogNo": MessageLookupByLibrary.simpleMessage("Nein"),
        "dialogYes": MessageLookupByLibrary.simpleMessage("Ja"),
        "display": MessageLookupByLibrary.simpleMessage("Anzeige"),
        "distribution": MessageLookupByLibrary.simpleMessage("Verteilung"),
        "editKill": MessageLookupByLibrary.simpleMessage("Abschuss bearbeiten"),
        "eigengebrauch": MessageLookupByLibrary.simpleMessage("Eigengebrauch"),
        "eigengebrauchAbgabe": MessageLookupByLibrary.simpleMessage(
            "Eigengebrauch - Abgabe zur Weiterverarbeitung"),
        "empfohlen": MessageLookupByLibrary.simpleMessage("Empfohlen"),
        "erlegt": MessageLookupByLibrary.simpleMessage("Erlegt"),
        "error": MessageLookupByLibrary.simpleMessage("Fehler"),
        "fallwild": MessageLookupByLibrary.simpleMessage("Fallwild"),
        "feedbackMailSubject": MessageLookupByLibrary.simpleMessage(
            "Feedback zur Jagdstatistik App"),
        "filter": MessageLookupByLibrary.simpleMessage("Filtern"),
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
        "geschlossen": MessageLookupByLibrary.simpleMessage("Geschlossen"),
        "grid": MessageLookupByLibrary.simpleMessage("Gitter"),
        "hegeabschuss": MessageLookupByLibrary.simpleMessage("Hegeabschuss"),
        "hirschkalb": MessageLookupByLibrary.simpleMessage("Hirschkalb"),
        "historic": MessageLookupByLibrary.simpleMessage("Historisch"),
        "hunter": MessageLookupByLibrary.simpleMessage("Jäger"),
        "jagdbegleiter": MessageLookupByLibrary.simpleMessage("Jagdbegleiter"),
        "jagdzeiten": MessageLookupByLibrary.simpleMessage("Jagdzeiten"),
        "jahrlingsHirsch":
            MessageLookupByLibrary.simpleMessage("Jährlingshirsch"),
        "jahrlingsbock": MessageLookupByLibrary.simpleMessage("Jährlingsbock"),
        "jetztFestlegen":
            MessageLookupByLibrary.simpleMessage("Jetzt festlegen"),
        "kahlwild": MessageLookupByLibrary.simpleMessage("Kahlwild"),
        "keiler": MessageLookupByLibrary.simpleMessage("Keiler"),
        "killer": MessageLookupByLibrary.simpleMessage("Erleger"),
        "kills": MessageLookupByLibrary.simpleMessage("Abschüsse"),
        "ksExport": MessageLookupByLibrary.simpleMessage("Export"),
        "ksExportDialogTitle":
            MessageLookupByLibrary.simpleMessage("Exportieren als"),
        "ksExportErrorSnackbar": MessageLookupByLibrary.simpleMessage(
            "Fehler: Keine Abschüsse zum exportieren."),
        "ksExportSubtitle": MessageLookupByLibrary.simpleMessage(
            "Nur die angezeigten Abschüsse werden exportiert."),
        "ksShowXFromYProgressBar": m1,
        "ksTerritoryTitle": MessageLookupByLibrary.simpleMessage("Revier"),
        "legend": MessageLookupByLibrary.simpleMessage("Legende"),
        "loginDataInvalid": MessageLookupByLibrary.simpleMessage(
            "Deine Anmeldedaten sind nicht mehr gültig!"),
        "loslegen": MessageLookupByLibrary.simpleMessage("Loslegen"),
        "maennlich": MessageLookupByLibrary.simpleMessage("Männlich"),
        "map": MessageLookupByLibrary.simpleMessage("Karte"),
        "mapInitialPosition":
            MessageLookupByLibrary.simpleMessage("Anfangsposition"),
        "mitKeimruhe": MessageLookupByLibrary.simpleMessage("mit Keimruhe"),
        "monate": MessageLookupByLibrary.simpleMessage("Monate"),
        "monthlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Monatsverlauf"),
        "murmeltier": MessageLookupByLibrary.simpleMessage("Murmeltier"),
        "needLogin": MessageLookupByLibrary.simpleMessage(
            "Da du die biometrische Authentifizierung aktiviert hast, musst du angemeldet sein, um Abschüsse zu sehen!"),
        "newKills": MessageLookupByLibrary.simpleMessage("Neue Abschüsse"),
        "nichtBekannt": MessageLookupByLibrary.simpleMessage("Nicht bekannt"),
        "nichtGefunden": MessageLookupByLibrary.simpleMessage(
            "Nicht gefunden / Nachsuche erfolglos"),
        "nichtVerwertbar":
            MessageLookupByLibrary.simpleMessage("Nicht verwertbar"),
        "noBiometricsFound": MessageLookupByLibrary.simpleMessage(
            "Fehler: Keine biometrischen Daten gefunden!"),
        "noDataFoundText": MessageLookupByLibrary.simpleMessage(
            "Hier gibt es nichts zu sehen..."),
        "noInternetError":
            MessageLookupByLibrary.simpleMessage("Fehler: Kein Internet"),
        "noKillsFoundError": MessageLookupByLibrary.simpleMessage(
            "Fehler: Keine Abschüsse gefunden!"),
        "noKillsLoadedError": MessageLookupByLibrary.simpleMessage(
            "Fehler: Abschüsse konnten nicht geladen werden!"),
        "number": MessageLookupByLibrary.simpleMessage("Nummer"),
        "onboardStatDesc": MessageLookupByLibrary.simpleMessage(
            "Welchen Einfluss haben Wildkrankheiten in deinem Revier?\nWurde in den letzten Jahren mehr Rehwild erlegt als dieses Jahr?\nUnd noch viel mehr..."),
        "onboardTerritoryDesc": MessageLookupByLibrary.simpleMessage(
            "Alle Abschüsse modern visualisiert und kartographisiert!\nAbschüsse direkt in die App eintragen"),
        "onboardUtilDesc": MessageLookupByLibrary.simpleMessage(
            "Prüfe die Jagdzeiten verschiedener Wildarten und die Schusszeit des Tages"),
        "onlyShot": MessageLookupByLibrary.simpleMessage("Nur Erlegte"),
        "open": MessageLookupByLibrary.simpleMessage("Offen"),
        "ortFestlegen": MessageLookupByLibrary.simpleMessage(
            "Du musst zuerst einen Ort für die Sonnenzeiten festlegen."),
        "overseer": MessageLookupByLibrary.simpleMessage("Aufseher"),
        "paarungszeiten":
            MessageLookupByLibrary.simpleMessage("Paarungszeiten"),
        "perMonth": MessageLookupByLibrary.simpleMessage("pro Monat"),
        "pflichtfeld": MessageLookupByLibrary.simpleMessage("Pflichtfeld"),
        "points": MessageLookupByLibrary.simpleMessage("Punkte"),
        "protokollBeschlagnahmt":
            MessageLookupByLibrary.simpleMessage("Protokoll / beschlagnahmt"),
        "refreshListConfirmation":
            MessageLookupByLibrary.simpleMessage("Liste wurde aktualisiert."),
        "rehwild": MessageLookupByLibrary.simpleMessage("Rehwild"),
        "rotwild": MessageLookupByLibrary.simpleMessage("Rotwild"),
        "schmalreh": MessageLookupByLibrary.simpleMessage("Schmalreh"),
        "schmaltier": MessageLookupByLibrary.simpleMessage("Schmaltier"),
        "schneehase": MessageLookupByLibrary.simpleMessage("Schneehase"),
        "schneehuhn": MessageLookupByLibrary.simpleMessage("Schneehuhn"),
        "schusszeiten": MessageLookupByLibrary.simpleMessage("Schusszeiten"),
        "schwarzwild": MessageLookupByLibrary.simpleMessage("Schwarzwild"),
        "search": MessageLookupByLibrary.simpleMessage("Suchen"),
        "searchXKills": m2,
        "seenByXonYatZ": m3,
        "selectCoordinates": MessageLookupByLibrary.simpleMessage(
            "Koordinaten auf Karte wählen"),
        "selectYear": MessageLookupByLibrary.simpleMessage("Wähle Jahr"),
        "settingsAbout": MessageLookupByLibrary.simpleMessage("Über"),
        "settingsAccount": MessageLookupByLibrary.simpleMessage("Konto"),
        "settingsDarkMode":
            MessageLookupByLibrary.simpleMessage("Dunkler Modus"),
        "settingsDefaultYear":
            MessageLookupByLibrary.simpleMessage("Zeige Abschüsse von"),
        "settingsDevelopment":
            MessageLookupByLibrary.simpleMessage("Entwicklung"),
        "settingsDisplay": MessageLookupByLibrary.simpleMessage("Anzeige"),
        "settingsDonate":
            MessageLookupByLibrary.simpleMessage("Feedback geben"),
        "settingsHuntersAssociationWebsite":
            MessageLookupByLibrary.simpleMessage("Jagdverband Statistik"),
        "settingsKontakt": MessageLookupByLibrary.simpleMessage("Kontakt"),
        "settingsLanguage": MessageLookupByLibrary.simpleMessage("Sprache"),
        "settingsLinks": MessageLookupByLibrary.simpleMessage("Links"),
        "settingsLogout": MessageLookupByLibrary.simpleMessage("Abmelden"),
        "settingsShowNamesBody": MessageLookupByLibrary.simpleMessage(
            "Es könnte sein, dass dabei nur Sterne angezeigt werden können."),
        "settingsShowNamesTitle":
            MessageLookupByLibrary.simpleMessage("Namen anzeigen"),
        "settingsTitle": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "settingsWebsite": MessageLookupByLibrary.simpleMessage("Webseite"),
        "sexes": MessageLookupByLibrary.simpleMessage("Geschlechter"),
        "share": MessageLookupByLibrary.simpleMessage("App teilen"),
        "shareAppText": m4,
        "shouldUseLocalAuth": MessageLookupByLibrary.simpleMessage(
            "Wenn du die Biometrische authentifizierung aktivierst, wirst du beim Start der App nach den auf deinem Gerät gespeicherten Anmeldedaten gefragt.\nMöchtest du Biometrie aktivieren? (empfohlen)"),
        "signOfOrigin":
            MessageLookupByLibrary.simpleMessage("Ursprungszeichen"),
        "signOutResetAll": MessageLookupByLibrary.simpleMessage(
            "Wenn du Probleme bei der Anmeldung hast kannst du alle Einstellungen zurücksetzen.\nAchtung: Dadurch wirst du abgemeldet und musst die Revieranmeldung erneut durchführen!"),
        "sjvPublikation": MessageLookupByLibrary.simpleMessage(
            "Eine Publikation des Südtiroler Jagdverbands"),
        "skip": MessageLookupByLibrary.simpleMessage("Überspringen"),
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
        "tage": MessageLookupByLibrary.simpleMessage("Tage"),
        "time": MessageLookupByLibrary.simpleMessage("Uhrzeit"),
        "timeEmptyError":
            MessageLookupByLibrary.simpleMessage("Zeit darf nicht leer sein"),
        "timeInLocal": MessageLookupByLibrary.simpleMessage(
            "Die Uhrzeiten basieren auf UTC und werden in das Format des Geräts umgewandelt.\nWische nach rechts oder links um den Tag zu wechseln."),
        "tragzeit": MessageLookupByLibrary.simpleMessage("Tragzeit"),
        "trophaehenHirsch":
            MessageLookupByLibrary.simpleMessage("Trophäenhirsch"),
        "ueberlaeuferBache":
            MessageLookupByLibrary.simpleMessage("Überläuferbache"),
        "ueberlaeuferKeiler":
            MessageLookupByLibrary.simpleMessage("Überläuferkeiler"),
        "usage": MessageLookupByLibrary.simpleMessage("Verwendung"),
        "usages": MessageLookupByLibrary.simpleMessage("Verwendungen"),
        "useLocalAuth":
            MessageLookupByLibrary.simpleMessage("Biometrische Anmeldung"),
        "verkauf": MessageLookupByLibrary.simpleMessage("Verkauf"),
        "vomZug": MessageLookupByLibrary.simpleMessage("Vom Zug überfahren"),
        "weiblich": MessageLookupByLibrary.simpleMessage("Weiblich"),
        "weiblicheRehe": MessageLookupByLibrary.simpleMessage("Weibliche Rehe"),
        "weight": MessageLookupByLibrary.simpleMessage("Gewicht"),
        "weightInKg": MessageLookupByLibrary.simpleMessage("Gewicht in kg"),
        "wild": MessageLookupByLibrary.simpleMessage("Wild"),
        "wildkalb": MessageLookupByLibrary.simpleMessage("Wildkalb"),
        "willBeLoggedInAuto": MessageLookupByLibrary.simpleMessage(
            "Du wirst gleich automatisch angemeldet..."),
        "wochen": MessageLookupByLibrary.simpleMessage("Wochen"),
        "xJagdzeiten": m5,
        "xKill_s": m6,
        "xNewKillsFound": m7,
        "yearly": MessageLookupByLibrary.simpleMessage("Jährlich"),
        "yearlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Jahresverlauf"),
        "yourTerritory": MessageLookupByLibrary.simpleMessage("Dein Revier"),
        "zahlNegativError":
            MessageLookupByLibrary.simpleMessage("Keine negativen Zahlen"),
        "zahlNichtGelesenError": MessageLookupByLibrary.simpleMessage(
            "Zahl konnte nicht gelesen werden")
      };
}
