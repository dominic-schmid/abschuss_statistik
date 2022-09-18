// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(x, y) => "Check out this kill in ${x}!\n${y}";

  static String m1(x, y) => "Showing ${x} of ${y}";

  static String m2(x) => "Filter ${x} kills";

  static String m3(x, y, z) => "Seen by ${x} on ${y} at ${z}";

  static String m4(x) => "Hunting times ${x} ";

  static String m5(howMany) =>
      "${Intl.plural(howMany, one: '1 Kill', other: '${howMany} Kills')}";

  static String m6(x) => "${x} new kills were found!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M": MessageLookupByLibrary.simpleMessage("Male"),
        "W": MessageLookupByLibrary.simpleMessage("Female"),
        "addKill": MessageLookupByLibrary.simpleMessage("Add kill"),
        "age": MessageLookupByLibrary.simpleMessage("Age"),
        "altgeiss": MessageLookupByLibrary.simpleMessage("Old doe"),
        "alttier": MessageLookupByLibrary.simpleMessage("Adult female"),
        "andereWildart":
            MessageLookupByLibrary.simpleMessage("Other wild species"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Hunting statistics"),
        "area": MessageLookupByLibrary.simpleMessage("Area"),
        "bache": MessageLookupByLibrary.simpleMessage("Female boar"),
        "betaModeDescription": MessageLookupByLibrary.simpleMessage(
            "Some features may not work correctly."),
        "betaModeTitle": MessageLookupByLibrary.simpleMessage("Beta mode"),
        "bockjahrling": MessageLookupByLibrary.simpleMessage("Young buck"),
        "bockkitz": MessageLookupByLibrary.simpleMessage("Buck fawn"),
        "both": MessageLookupByLibrary.simpleMessage("Both"),
        "brutzeit": MessageLookupByLibrary.simpleMessage("breeding season"),
        "causes": MessageLookupByLibrary.simpleMessage("Causes"),
        "chartBasedOnDownloaded": MessageLookupByLibrary.simpleMessage(
            "The charts are based on your downloaded data. If a year is missing, you can select and download it on the start page.\n\nThese diagrams provide information about the historical development of the game in your area and have been designed in such a way that you can configure the structure yourself!"),
        "checkOutThisKillXY": m0,
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "companion": MessageLookupByLibrary.simpleMessage("Companion"),
        "configuration": MessageLookupByLibrary.simpleMessage("Configuration"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmAddKillCancel": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to cancel editing the new kill?"),
        "copiedToClipboardSnackbar":
            MessageLookupByLibrary.simpleMessage("Copied to clipboard!"),
        "credentialsScreen":
            MessageLookupByLibrary.simpleMessage("Credentials"),
        "credsDisclaimerText": MessageLookupByLibrary.simpleMessage(
            "Your login details are only stored locally and used to download the kills from the hunters\' association site.\nThey will never be passed on to third parties!"),
        "credsEmptySnackbar":
            MessageLookupByLibrary.simpleMessage("You must enter both fields!"),
        "credsLoginButton": MessageLookupByLibrary.simpleMessage("LOGIN"),
        "credsLoginErrorSnackbar": MessageLookupByLibrary.simpleMessage(
            "Error: No territory found for the given credentials!"),
        "credsLoginTitle": MessageLookupByLibrary.simpleMessage("Login"),
        "credsPasswordFieldHint":
            MessageLookupByLibrary.simpleMessage("Password"),
        "credsPasswordFieldTitle":
            MessageLookupByLibrary.simpleMessage("Password"),
        "credsTerritoryFieldHint":
            MessageLookupByLibrary.simpleMessage("e.g. Bruneck13L"),
        "credsTerritoryFieldTitle":
            MessageLookupByLibrary.simpleMessage("Territory"),
        "credsTooManySigninsSnackbar": MessageLookupByLibrary.simpleMessage(
            "Signed up too often! Wait 1 minute before you can log in again."),
        "dachs": MessageLookupByLibrary.simpleMessage("Badger"),
        "dateEmptyError":
            MessageLookupByLibrary.simpleMessage("Date cannot be empty"),
        "dateInFutureError":
            MessageLookupByLibrary.simpleMessage("Time invalid"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "dialogLogoutBody": MessageLookupByLibrary.simpleMessage(
            "Do you really want to log out?\nYour login data and all your settings will be deleted!"),
        "dialogNo": MessageLookupByLibrary.simpleMessage("No"),
        "dialogYes": MessageLookupByLibrary.simpleMessage("Yes"),
        "display": MessageLookupByLibrary.simpleMessage("Display"),
        "distribution": MessageLookupByLibrary.simpleMessage("Distribution"),
        "editKill": MessageLookupByLibrary.simpleMessage("Edit kill"),
        "eigengebrauch": MessageLookupByLibrary.simpleMessage("Personal use"),
        "eigengebrauchAbgabe": MessageLookupByLibrary.simpleMessage(
            "Personal use - delivery for further processing"),
        "erlegt": MessageLookupByLibrary.simpleMessage("Killed"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "fallwild": MessageLookupByLibrary.simpleMessage("Found dead"),
        "feedbackMailSubject": MessageLookupByLibrary.simpleMessage(
            "Feedback for the hunting statistics app"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "freizone": MessageLookupByLibrary.simpleMessage("Free zone"),
        "frischling": MessageLookupByLibrary.simpleMessage("Wild boar"),
        "fuchs": MessageLookupByLibrary.simpleMessage("Fox"),
        "gameTypes": MessageLookupByLibrary.simpleMessage("Species"),
        "gamsbock": MessageLookupByLibrary.simpleMessage("Chamois buck"),
        "gamsgeiss": MessageLookupByLibrary.simpleMessage("Female chamois"),
        "gamsjahrlinge":
            MessageLookupByLibrary.simpleMessage("chamois yearlings"),
        "gamswild": MessageLookupByLibrary.simpleMessage("Chamois"),
        "geissjahrling": MessageLookupByLibrary.simpleMessage("Young female"),
        "geisskitz": MessageLookupByLibrary.simpleMessage("Female fawn"),
        "geschlossen": MessageLookupByLibrary.simpleMessage("Closed"),
        "grid": MessageLookupByLibrary.simpleMessage("Grid"),
        "hegeabschuss":
            MessageLookupByLibrary.simpleMessage("Conservation kill"),
        "hirschkalb": MessageLookupByLibrary.simpleMessage("Male fawn"),
        "historic": MessageLookupByLibrary.simpleMessage("Historic"),
        "hunter": MessageLookupByLibrary.simpleMessage("Hunter"),
        "jagdzeiten": MessageLookupByLibrary.simpleMessage("Hunting times"),
        "jahrlingsHirsch": MessageLookupByLibrary.simpleMessage("Young buck"),
        "jahrlingsbock": MessageLookupByLibrary.simpleMessage("Young buck"),
        "kahlwild": MessageLookupByLibrary.simpleMessage("Deer"),
        "keiler": MessageLookupByLibrary.simpleMessage("Male boar"),
        "killer": MessageLookupByLibrary.simpleMessage("Hunter"),
        "kills": MessageLookupByLibrary.simpleMessage("Kills"),
        "ksExport": MessageLookupByLibrary.simpleMessage("Export"),
        "ksExportDialogTitle":
            MessageLookupByLibrary.simpleMessage("Export as"),
        "ksExportErrorSnackbar":
            MessageLookupByLibrary.simpleMessage("Error: No kills to export."),
        "ksExportSubtitle": MessageLookupByLibrary.simpleMessage(
            "Only visible kills are exported."),
        "ksShowXFromYProgressBar": m1,
        "ksTerritoryTitle": MessageLookupByLibrary.simpleMessage("Territory"),
        "loginDataInvalid": MessageLookupByLibrary.simpleMessage(
            "Your login credentials are no longer valid!"),
        "maennlich": MessageLookupByLibrary.simpleMessage("Male"),
        "mapInitialPosition":
            MessageLookupByLibrary.simpleMessage("Initial position"),
        "mitKeimruhe": MessageLookupByLibrary.simpleMessage("with dormancy"),
        "monate": MessageLookupByLibrary.simpleMessage("months"),
        "monthlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Monthly breakdown"),
        "murmeltier": MessageLookupByLibrary.simpleMessage("Marmot"),
        "newKills": MessageLookupByLibrary.simpleMessage("New kills"),
        "nichtBekannt": MessageLookupByLibrary.simpleMessage("Unknown"),
        "nichtGefunden": MessageLookupByLibrary.simpleMessage(
            "Not found / search unsuccessful"),
        "nichtVerwertbar": MessageLookupByLibrary.simpleMessage("Not usable"),
        "noDataFoundText":
            MessageLookupByLibrary.simpleMessage("Nothing to see here.."),
        "noInternetError":
            MessageLookupByLibrary.simpleMessage("Error: No internet!"),
        "noKillsFoundError":
            MessageLookupByLibrary.simpleMessage("Error: No kills found!"),
        "noKillsLoadedError": MessageLookupByLibrary.simpleMessage(
            "Error: Kills could not be loaded!"),
        "number": MessageLookupByLibrary.simpleMessage("Number"),
        "onlyShot": MessageLookupByLibrary.simpleMessage("Only shot"),
        "open": MessageLookupByLibrary.simpleMessage("Open"),
        "overseer": MessageLookupByLibrary.simpleMessage("Overseer"),
        "paarungszeiten": MessageLookupByLibrary.simpleMessage("Mating times"),
        "perMonth": MessageLookupByLibrary.simpleMessage("per Month"),
        "pflichtfeld": MessageLookupByLibrary.simpleMessage("Mandatory"),
        "points": MessageLookupByLibrary.simpleMessage("Point"),
        "protokollBeschlagnahmt":
            MessageLookupByLibrary.simpleMessage("Protocol / confiscated"),
        "rehwild": MessageLookupByLibrary.simpleMessage("Roe deer"),
        "rotwild": MessageLookupByLibrary.simpleMessage("Deer"),
        "schmalreh": MessageLookupByLibrary.simpleMessage("Young doe"),
        "schmaltier": MessageLookupByLibrary.simpleMessage("Young doe"),
        "schneehase": MessageLookupByLibrary.simpleMessage("snow bunny"),
        "schneehuhn": MessageLookupByLibrary.simpleMessage("Grouse"),
        "schwarzwild": MessageLookupByLibrary.simpleMessage("Wild boar"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "searchXKills": m2,
        "seenByXonYatZ": m3,
        "selectCoordinates":
            MessageLookupByLibrary.simpleMessage("Choose coordinates on map"),
        "selectYear": MessageLookupByLibrary.simpleMessage("Select year"),
        "settingsAbout": MessageLookupByLibrary.simpleMessage("About"),
        "settingsAccount": MessageLookupByLibrary.simpleMessage("Account"),
        "settingsDarkMode": MessageLookupByLibrary.simpleMessage("Dark theme"),
        "settingsDevelopment":
            MessageLookupByLibrary.simpleMessage("Development"),
        "settingsDisplay": MessageLookupByLibrary.simpleMessage("Display"),
        "settingsDonate": MessageLookupByLibrary.simpleMessage("Donate Speck"),
        "settingsHuntersAssociationWebsite":
            MessageLookupByLibrary.simpleMessage(
                "Hunter\'s association\'s statistics"),
        "settingsKontakt": MessageLookupByLibrary.simpleMessage("Contact"),
        "settingsLanguage": MessageLookupByLibrary.simpleMessage("Language"),
        "settingsLinks": MessageLookupByLibrary.simpleMessage("Links"),
        "settingsLogout": MessageLookupByLibrary.simpleMessage("Log out"),
        "settingsShowNamesBody": MessageLookupByLibrary.simpleMessage(
            "It\'s possible you may only see stars if you enable this setting"),
        "settingsShowNamesTitle":
            MessageLookupByLibrary.simpleMessage("Show names"),
        "settingsTitle": MessageLookupByLibrary.simpleMessage("Settings"),
        "settingsWebsite": MessageLookupByLibrary.simpleMessage("Website"),
        "sexes": MessageLookupByLibrary.simpleMessage("Sexes"),
        "signOfOrigin": MessageLookupByLibrary.simpleMessage("Sign of origin"),
        "sortCause": MessageLookupByLibrary.simpleMessage("Cause"),
        "sortDate": MessageLookupByLibrary.simpleMessage("Date"),
        "sortGameType": MessageLookupByLibrary.simpleMessage("Species"),
        "sortGender": MessageLookupByLibrary.simpleMessage("Sex"),
        "sortNone": MessageLookupByLibrary.simpleMessage("No sorting"),
        "sortNumber": MessageLookupByLibrary.simpleMessage("Number"),
        "sortPlace": MessageLookupByLibrary.simpleMessage("Place"),
        "sortTitle": MessageLookupByLibrary.simpleMessage("Sorting"),
        "sortUse": MessageLookupByLibrary.simpleMessage("Use"),
        "sortWeight": MessageLookupByLibrary.simpleMessage("Weight"),
        "spielhahn": MessageLookupByLibrary.simpleMessage("Playcock"),
        "statistics": MessageLookupByLibrary.simpleMessage("Stats"),
        "steinbock": MessageLookupByLibrary.simpleMessage("Stone buck"),
        "steingeiss": MessageLookupByLibrary.simpleMessage("Stone doe"),
        "steinhuhn": MessageLookupByLibrary.simpleMessage("Rock partridge"),
        "steinwild": MessageLookupByLibrary.simpleMessage("Ibex"),
        "strassenunfall": MessageLookupByLibrary.simpleMessage("Car accident"),
        "sum": MessageLookupByLibrary.simpleMessage("Sum"),
        "tBock": MessageLookupByLibrary.simpleMessage("Trophy buck"),
        "tage": MessageLookupByLibrary.simpleMessage("days"),
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "timeEmptyError":
            MessageLookupByLibrary.simpleMessage("Time cannot be empty"),
        "tragzeit": MessageLookupByLibrary.simpleMessage("gestation period"),
        "trophaehenHirsch": MessageLookupByLibrary.simpleMessage("Trophy buck"),
        "ueberlaeuferBache":
            MessageLookupByLibrary.simpleMessage("Young female boar"),
        "ueberlaeuferKeiler":
            MessageLookupByLibrary.simpleMessage("Young male boar"),
        "usage": MessageLookupByLibrary.simpleMessage("Usage"),
        "usages": MessageLookupByLibrary.simpleMessage("Usages"),
        "verkauf": MessageLookupByLibrary.simpleMessage("Sale"),
        "vomZug": MessageLookupByLibrary.simpleMessage("Killed by train"),
        "weiblich": MessageLookupByLibrary.simpleMessage("Female"),
        "weiblicheRehe": MessageLookupByLibrary.simpleMessage("Female deer"),
        "weight": MessageLookupByLibrary.simpleMessage("Weight"),
        "weightInKg": MessageLookupByLibrary.simpleMessage("Weight in kg"),
        "wild": MessageLookupByLibrary.simpleMessage("Species"),
        "wildkalb": MessageLookupByLibrary.simpleMessage("Female fawn"),
        "wochen": MessageLookupByLibrary.simpleMessage("weeks"),
        "xJagdzeiten": m4,
        "xKill_s": m5,
        "xNewKillsFound": m6,
        "yearly": MessageLookupByLibrary.simpleMessage("Yearly"),
        "yearlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Yearly breakdown"),
        "zahlNegativError":
            MessageLookupByLibrary.simpleMessage("No negative numbers"),
        "zahlNichtGelesenError":
            MessageLookupByLibrary.simpleMessage("Number unreadable")
      };
}
