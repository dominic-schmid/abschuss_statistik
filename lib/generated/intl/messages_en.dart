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

  static String m4(link) => "Check out the hunting statistics app!\n\n${link}";

  static String m5(x) => "Hunting times ${x} ";

  static String m6(howMany) =>
      "${Intl.plural(howMany, one: '1 Kill', other: '${howMany} Kills')}";

  static String m7(x) => "${x} new kills were found!";

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
        "appSettings": MessageLookupByLibrary.simpleMessage("App"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Hunting statistics"),
        "area": MessageLookupByLibrary.simpleMessage("Area"),
        "bache": MessageLookupByLibrary.simpleMessage("Female boar"),
        "betaModeDescription": MessageLookupByLibrary.simpleMessage(
            "Some features may not work correctly."),
        "betaModeTitle": MessageLookupByLibrary.simpleMessage("Beta mode"),
        "biometrics": MessageLookupByLibrary.simpleMessage("Biometrics"),
        "bockjahrling": MessageLookupByLibrary.simpleMessage("Young buck"),
        "bockkitz": MessageLookupByLibrary.simpleMessage("Buck fawn"),
        "border": MessageLookupByLibrary.simpleMessage("Border"),
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
        "confirmDeleteDatabase": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to reset the database?"),
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
        "defaultLocationDescription": MessageLookupByLibrary.simpleMessage(
            "Default view when adding a kill or calculating shot times."),
        "defaultLocationTitle":
            MessageLookupByLibrary.simpleMessage("Select starting point"),
        "deleteDatabaseDescription": MessageLookupByLibrary.simpleMessage(
            "Delete kills and re-download them. Run this operation to fix any errors."),
        "deleteDatabaseTitle":
            MessageLookupByLibrary.simpleMessage("Reset database"),
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
        "empfohlen": MessageLookupByLibrary.simpleMessage("Recommended"),
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
        "jagdbegleiter":
            MessageLookupByLibrary.simpleMessage("Hunting companion"),
        "jagdzeiten": MessageLookupByLibrary.simpleMessage("Hunting times"),
        "jahrlingsHirsch": MessageLookupByLibrary.simpleMessage("Young buck"),
        "jahrlingsbock": MessageLookupByLibrary.simpleMessage("Young buck"),
        "jetztFestlegen": MessageLookupByLibrary.simpleMessage("Set now"),
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
        "legend": MessageLookupByLibrary.simpleMessage("Legend"),
        "loginDataInvalid": MessageLookupByLibrary.simpleMessage(
            "Your login credentials are no longer valid!"),
        "loslegen": MessageLookupByLibrary.simpleMessage("Get started"),
        "maennlich": MessageLookupByLibrary.simpleMessage("Male"),
        "map": MessageLookupByLibrary.simpleMessage("Map"),
        "mapInitialPosition":
            MessageLookupByLibrary.simpleMessage("Initial position"),
        "mitKeimruhe": MessageLookupByLibrary.simpleMessage("with dormancy"),
        "monate": MessageLookupByLibrary.simpleMessage("months"),
        "monthlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Monthly breakdown"),
        "murmeltier": MessageLookupByLibrary.simpleMessage("Marmot"),
        "needLogin": MessageLookupByLibrary.simpleMessage(
            "Since you have biometric authentication enabled, you must be logged in to see kills!"),
        "newKills": MessageLookupByLibrary.simpleMessage("New kills"),
        "nichtBekannt": MessageLookupByLibrary.simpleMessage("Unknown"),
        "nichtGefunden": MessageLookupByLibrary.simpleMessage(
            "Not found / search unsuccessful"),
        "nichtVerwertbar": MessageLookupByLibrary.simpleMessage("Not usable"),
        "noBiometricsFound": MessageLookupByLibrary.simpleMessage(
            "Error: No biometric data found!"),
        "noDataFoundText":
            MessageLookupByLibrary.simpleMessage("Nothing to see here.."),
        "noInternetError":
            MessageLookupByLibrary.simpleMessage("Error: No internet!"),
        "noKillsFoundError":
            MessageLookupByLibrary.simpleMessage("Error: No kills found!"),
        "noKillsLoadedError": MessageLookupByLibrary.simpleMessage(
            "Error: Kills could not be loaded!"),
        "number": MessageLookupByLibrary.simpleMessage("Number"),
        "onboardStatDesc": MessageLookupByLibrary.simpleMessage(
            "What impact do wildlife diseases have on your hunting ground?\nHas more roe deer been shot in recent years than this year?\nAnd much more..."),
        "onboardTerritoryDesc": MessageLookupByLibrary.simpleMessage(
            "All kills visualized and mapped in a modern way!\nEnter kills directly into the app"),
        "onboardUtilDesc": MessageLookupByLibrary.simpleMessage(
            "Check the hunting times of different game species and the shooting time of the day"),
        "onlyShot": MessageLookupByLibrary.simpleMessage("Only shot"),
        "open": MessageLookupByLibrary.simpleMessage("Open"),
        "ortFestlegen": MessageLookupByLibrary.simpleMessage(
            "You must first set a location for the sun times."),
        "overseer": MessageLookupByLibrary.simpleMessage("Overseer"),
        "paarungszeiten": MessageLookupByLibrary.simpleMessage("Mating times"),
        "perMonth": MessageLookupByLibrary.simpleMessage("per Month"),
        "pflichtfeld": MessageLookupByLibrary.simpleMessage("Mandatory"),
        "points": MessageLookupByLibrary.simpleMessage("Point"),
        "protokollBeschlagnahmt":
            MessageLookupByLibrary.simpleMessage("Protocol / confiscated"),
        "refreshListConfirmation":
            MessageLookupByLibrary.simpleMessage("List refreshed."),
        "rehwild": MessageLookupByLibrary.simpleMessage("Roe deer"),
        "rotwild": MessageLookupByLibrary.simpleMessage("Deer"),
        "schmalreh": MessageLookupByLibrary.simpleMessage("Young doe"),
        "schmaltier": MessageLookupByLibrary.simpleMessage("Young doe"),
        "schneehase": MessageLookupByLibrary.simpleMessage("snow bunny"),
        "schneehuhn": MessageLookupByLibrary.simpleMessage("Grouse"),
        "schusszeiten": MessageLookupByLibrary.simpleMessage("Shooting times"),
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
        "settingsDefaultYear":
            MessageLookupByLibrary.simpleMessage("Show harvests from"),
        "settingsDevelopment":
            MessageLookupByLibrary.simpleMessage("Development"),
        "settingsDisplay": MessageLookupByLibrary.simpleMessage("Display"),
        "settingsDonate": MessageLookupByLibrary.simpleMessage("Give feedback"),
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
        "share": MessageLookupByLibrary.simpleMessage("Share app"),
        "shareAppText": m4,
        "shouldUseLocalAuth": MessageLookupByLibrary.simpleMessage(
            "If you activate biometric authentication, you will be asked for the login data stored on your device when you start the app.\nDo you want to enable biometrics? (recommended)"),
        "signOfOrigin": MessageLookupByLibrary.simpleMessage("Sign of origin"),
        "signOutResetAll": MessageLookupByLibrary.simpleMessage(
            "If you have problems logging in, you can reset all settings.\nAttention: This will deregister you and you will have to register again!"),
        "sjvPublikation": MessageLookupByLibrary.simpleMessage(
            "A publication of the South Tyrolean Hunting Association"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
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
        "timeInLocal": MessageLookupByLibrary.simpleMessage(
            "The times are based on UTC and are converted to the format of the device.\nSwipe left or right to change the date."),
        "tragzeit": MessageLookupByLibrary.simpleMessage("gestation period"),
        "trophaehenHirsch": MessageLookupByLibrary.simpleMessage("Trophy buck"),
        "ueberlaeuferBache":
            MessageLookupByLibrary.simpleMessage("Young female boar"),
        "ueberlaeuferKeiler":
            MessageLookupByLibrary.simpleMessage("Young male boar"),
        "usage": MessageLookupByLibrary.simpleMessage("Usage"),
        "usages": MessageLookupByLibrary.simpleMessage("Usages"),
        "useLocalAuth":
            MessageLookupByLibrary.simpleMessage("Biometric authentication"),
        "verkauf": MessageLookupByLibrary.simpleMessage("Sale"),
        "vomZug": MessageLookupByLibrary.simpleMessage("Killed by train"),
        "weiblich": MessageLookupByLibrary.simpleMessage("Female"),
        "weiblicheRehe": MessageLookupByLibrary.simpleMessage("Female deer"),
        "weight": MessageLookupByLibrary.simpleMessage("Weight"),
        "weightInKg": MessageLookupByLibrary.simpleMessage("Weight in kg"),
        "wild": MessageLookupByLibrary.simpleMessage("Species"),
        "wildkalb": MessageLookupByLibrary.simpleMessage("Female fawn"),
        "willBeLoggedInAuto": MessageLookupByLibrary.simpleMessage(
            "You will be automatically logged in..."),
        "wochen": MessageLookupByLibrary.simpleMessage("weeks"),
        "xJagdzeiten": m5,
        "xKill_s": m6,
        "xNewKillsFound": m7,
        "yearly": MessageLookupByLibrary.simpleMessage("Yearly"),
        "yearlyBreakdown":
            MessageLookupByLibrary.simpleMessage("Yearly breakdown"),
        "yourTerritory": MessageLookupByLibrary.simpleMessage("Your territory"),
        "zahlNegativError":
            MessageLookupByLibrary.simpleMessage("No negative numbers"),
        "zahlNichtGelesenError":
            MessageLookupByLibrary.simpleMessage("Number unreadable")
      };
}
