// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Credentials`
  String get credentialsScreen {
    return Intl.message(
      'Credentials',
      name: 'credentialsScreen',
      desc: '',
      args: [],
    );
  }

  /// `Hunting statistics`
  String get appTitle {
    return Intl.message(
      'Hunting statistics',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get credsLoginTitle {
    return Intl.message(
      'Login',
      name: 'credsLoginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Territory`
  String get credsTerritoryFieldTitle {
    return Intl.message(
      'Territory',
      name: 'credsTerritoryFieldTitle',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Bruneck13L`
  String get credsTerritoryFieldHint {
    return Intl.message(
      'e.g. Bruneck13L',
      name: 'credsTerritoryFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get credsPasswordFieldTitle {
    return Intl.message(
      'Password',
      name: 'credsPasswordFieldTitle',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get credsPasswordFieldHint {
    return Intl.message(
      'Password',
      name: 'credsPasswordFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get credsLoginButton {
    return Intl.message(
      'LOGIN',
      name: 'credsLoginButton',
      desc: '',
      args: [],
    );
  }

  /// `Your login details are only stored locally and used to download the kills from the hunters' association site.\nThey will never be passed on to third parties!`
  String get credsDisclaimerText {
    return Intl.message(
      'Your login details are only stored locally and used to download the kills from the hunters\' association site.\nThey will never be passed on to third parties!',
      name: 'credsDisclaimerText',
      desc: '',
      args: [],
    );
  }

  /// `You must enter both fields!`
  String get credsEmptySnackbar {
    return Intl.message(
      'You must enter both fields!',
      name: 'credsEmptySnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Error: No territory found for the given credentials!`
  String get credsLoginErrorSnackbar {
    return Intl.message(
      'Error: No territory found for the given credentials!',
      name: 'credsLoginErrorSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Error: No internet!`
  String get noInternetError {
    return Intl.message(
      'Error: No internet!',
      name: 'noInternetError',
      desc: '',
      args: [],
    );
  }

  /// `Signed up too often! Wait 1 minute before you can log in again.`
  String get credsTooManySigninsSnackbar {
    return Intl.message(
      'Signed up too often! Wait 1 minute before you can log in again.',
      name: 'credsTooManySigninsSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Display`
  String get settingsDisplay {
    return Intl.message(
      'Display',
      name: 'settingsDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settingsLanguage {
    return Intl.message(
      'Language',
      name: 'settingsLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get settingsDarkMode {
    return Intl.message(
      'Dark theme',
      name: 'settingsDarkMode',
      desc: '',
      args: [],
    );
  }

  /// `Show names`
  String get settingsShowNamesTitle {
    return Intl.message(
      'Show names',
      name: 'settingsShowNamesTitle',
      desc: '',
      args: [],
    );
  }

  /// `It could be that only stars can be displayed.`
  String get settingsShowNamesBody {
    return Intl.message(
      'It could be that only stars can be displayed.',
      name: 'settingsShowNamesBody',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get settingsAccount {
    return Intl.message(
      'Account',
      name: 'settingsAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get settingsLogout {
    return Intl.message(
      'Log out',
      name: 'settingsLogout',
      desc: '',
      args: [],
    );
  }

  /// `Links`
  String get settingsLinks {
    return Intl.message(
      'Links',
      name: 'settingsLinks',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get settingsWebsite {
    return Intl.message(
      'Website',
      name: 'settingsWebsite',
      desc: '',
      args: [],
    );
  }

  /// `Donate Speck`
  String get settingsDonate {
    return Intl.message(
      'Donate Speck',
      name: 'settingsDonate',
      desc: '',
      args: [],
    );
  }

  /// `Hunter's association's statistics`
  String get settingsHuntersAssociationWebsite {
    return Intl.message(
      'Hunter\'s association\'s statistics',
      name: 'settingsHuntersAssociationWebsite',
      desc: '',
      args: [],
    );
  }

  /// `Development`
  String get settingsDevelopment {
    return Intl.message(
      'Development',
      name: 'settingsDevelopment',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get settingsKontakt {
    return Intl.message(
      'Contact',
      name: 'settingsKontakt',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get settingsAbout {
    return Intl.message(
      'About',
      name: 'settingsAbout',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get dialogYes {
    return Intl.message(
      'Yes',
      name: 'dialogYes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get dialogNo {
    return Intl.message(
      'No',
      name: 'dialogNo',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to log out?\nYour login data and all your settings will be deleted!`
  String get dialogLogoutBody {
    return Intl.message(
      'Do you really want to log out?\nYour login data and all your settings will be deleted!',
      name: 'dialogLogoutBody',
      desc: '',
      args: [],
    );
  }

  /// `Feedback for the hunting statistics app`
  String get feedbackMailSubject {
    return Intl.message(
      'Feedback for the hunting statistics app',
      name: 'feedbackMailSubject',
      desc: '',
      args: [],
    );
  }

  /// `Export as`
  String get ksExportDialogTitle {
    return Intl.message(
      'Export as',
      name: 'ksExportDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get ksExport {
    return Intl.message(
      'Export',
      name: 'ksExport',
      desc: '',
      args: [],
    );
  }

  /// `Showing {x} of {y}`
  String ksShowXFromYProgressBar(Object x, Object y) {
    return Intl.message(
      'Showing $x of $y',
      name: 'ksShowXFromYProgressBar',
      desc: '',
      args: [x, y],
    );
  }

  /// `Territory`
  String get ksTerritoryTitle {
    return Intl.message(
      'Territory',
      name: 'ksTerritoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Error: No kills found!`
  String get noKillsFoundError {
    return Intl.message(
      'Error: No kills found!',
      name: 'noKillsFoundError',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get sortDate {
    return Intl.message(
      'Date',
      name: 'sortDate',
      desc: '',
      args: [],
    );
  }

  /// `No sorting`
  String get sortNone {
    return Intl.message(
      'No sorting',
      name: 'sortNone',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get sortNumber {
    return Intl.message(
      'Number',
      name: 'sortNumber',
      desc: '',
      args: [],
    );
  }

  /// `Game`
  String get sortGameType {
    return Intl.message(
      'Game',
      name: 'sortGameType',
      desc: '',
      args: [],
    );
  }

  /// `Sex`
  String get sortGender {
    return Intl.message(
      'Sex',
      name: 'sortGender',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get sortWeight {
    return Intl.message(
      'Weight',
      name: 'sortWeight',
      desc: '',
      args: [],
    );
  }

  /// `Cause`
  String get sortCause {
    return Intl.message(
      'Cause',
      name: 'sortCause',
      desc: '',
      args: [],
    );
  }

  /// `Use`
  String get sortUse {
    return Intl.message(
      'Use',
      name: 'sortUse',
      desc: '',
      args: [],
    );
  }

  /// `Place`
  String get sortPlace {
    return Intl.message(
      'Place',
      name: 'sortPlace',
      desc: '',
      args: [],
    );
  }

  /// `Sorting`
  String get sortTitle {
    return Intl.message(
      'Sorting',
      name: 'sortTitle',
      desc: '',
      args: [],
    );
  }

  /// `Filter {x} kills`
  String searchXKills(Object x) {
    return Intl.message(
      'Filter $x kills',
      name: 'searchXKills',
      desc: '',
      args: [x],
    );
  }

  /// `Kills`
  String get kills {
    return Intl.message(
      'Kills',
      name: 'kills',
      desc: '',
      args: [],
    );
  }

  /// `Stats`
  String get statistics {
    return Intl.message(
      'Stats',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard!`
  String get copiedToClipboardSnackbar {
    return Intl.message(
      'Copied to clipboard!',
      name: 'copiedToClipboardSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get area {
    return Intl.message(
      'Area',
      name: 'area',
      desc: '',
      args: [],
    );
  }

  /// `Companion`
  String get companion {
    return Intl.message(
      'Companion',
      name: 'companion',
      desc: '',
      args: [],
    );
  }

  /// `Hunter`
  String get hunter {
    return Intl.message(
      'Hunter',
      name: 'hunter',
      desc: '',
      args: [],
    );
  }

  /// `Hunter`
  String get killer {
    return Intl.message(
      'Hunter',
      name: 'killer',
      desc: '',
      args: [],
    );
  }

  /// `Sign of origin`
  String get signOfOrigin {
    return Intl.message(
      'Sign of origin',
      name: 'signOfOrigin',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Usage`
  String get usage {
    return Intl.message(
      'Usage',
      name: 'usage',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Species`
  String get gameTypes {
    return Intl.message(
      'Species',
      name: 'gameTypes',
      desc: '',
      args: [],
    );
  }

  /// `Sexes`
  String get sexes {
    return Intl.message(
      'Sexes',
      name: 'sexes',
      desc: '',
      args: [],
    );
  }

  /// `Causes`
  String get causes {
    return Intl.message(
      'Causes',
      name: 'causes',
      desc: '',
      args: [],
    );
  }

  /// `usages`
  String get usages {
    return Intl.message(
      'usages',
      name: 'usages',
      desc: '',
      args: [],
    );
  }

  /// `roe deer`
  String get rehwild {
    return Intl.message(
      'roe deer',
      name: 'rehwild',
      desc: '',
      args: [],
    );
  }

  /// `deer`
  String get rotwild {
    return Intl.message(
      'deer',
      name: 'rotwild',
      desc: '',
      args: [],
    );
  }

  /// `chamois`
  String get gamswild {
    return Intl.message(
      'chamois',
      name: 'gamswild',
      desc: '',
      args: [],
    );
  }

  /// `ibex`
  String get steinwild {
    return Intl.message(
      'ibex',
      name: 'steinwild',
      desc: '',
      args: [],
    );
  }

  /// `wild boar`
  String get schwarzwild {
    return Intl.message(
      'wild boar',
      name: 'schwarzwild',
      desc: '',
      args: [],
    );
  }

  /// `playcock`
  String get spielhahn {
    return Intl.message(
      'playcock',
      name: 'spielhahn',
      desc: '',
      args: [],
    );
  }

  /// `rock partridge`
  String get steinhuhn {
    return Intl.message(
      'rock partridge',
      name: 'steinhuhn',
      desc: '',
      args: [],
    );
  }

  /// `grouse`
  String get schneehuhn {
    return Intl.message(
      'grouse',
      name: 'schneehuhn',
      desc: '',
      args: [],
    );
  }

  /// `marmot`
  String get murmeltier {
    return Intl.message(
      'marmot',
      name: 'murmeltier',
      desc: '',
      args: [],
    );
  }

  /// `badger`
  String get dachs {
    return Intl.message(
      'badger',
      name: 'dachs',
      desc: '',
      args: [],
    );
  }

  /// `fox`
  String get fuchs {
    return Intl.message(
      'fox',
      name: 'fuchs',
      desc: '',
      args: [],
    );
  }

  /// `snow bunny`
  String get schneehase {
    return Intl.message(
      'snow bunny',
      name: 'schneehase',
      desc: '',
      args: [],
    );
  }

  /// `Other wild species`
  String get andereWildart {
    return Intl.message(
      'Other wild species',
      name: 'andereWildart',
      desc: '',
      args: [],
    );
  }

  /// `killed`
  String get erlegt {
    return Intl.message(
      'killed',
      name: 'erlegt',
      desc: '',
      args: [],
    );
  }

  /// `found dead`
  String get fallwild {
    return Intl.message(
      'found dead',
      name: 'fallwild',
      desc: '',
      args: [],
    );
  }

  /// `conservation kill`
  String get hegeabschuss {
    return Intl.message(
      'conservation kill',
      name: 'hegeabschuss',
      desc: '',
      args: [],
    );
  }

  /// `car accident`
  String get strassenunfall {
    return Intl.message(
      'car accident',
      name: 'strassenunfall',
      desc: '',
      args: [],
    );
  }

  /// `Protocol / confiscated`
  String get protokollBeschlagnahmt {
    return Intl.message(
      'Protocol / confiscated',
      name: 'protokollBeschlagnahmt',
      desc: '',
      args: [],
    );
  }

  /// `killed by train`
  String get vomZug {
    return Intl.message(
      'killed by train',
      name: 'vomZug',
      desc: '',
      args: [],
    );
  }

  /// `Free zone`
  String get freizone {
    return Intl.message(
      'Free zone',
      name: 'freizone',
      desc: '',
      args: [],
    );
  }

  /// `personal use`
  String get eigengebrauch {
    return Intl.message(
      'personal use',
      name: 'eigengebrauch',
      desc: '',
      args: [],
    );
  }

  /// `Personal use - delivery for further processing`
  String get eigengebrauchAbgabe {
    return Intl.message(
      'Personal use - delivery for further processing',
      name: 'eigengebrauchAbgabe',
      desc: '',
      args: [],
    );
  }

  /// `sale`
  String get verkauf {
    return Intl.message(
      'sale',
      name: 'verkauf',
      desc: '',
      args: [],
    );
  }

  /// `Not usable`
  String get nichtVerwertbar {
    return Intl.message(
      'Not usable',
      name: 'nichtVerwertbar',
      desc: '',
      args: [],
    );
  }

  /// `Not found / search unsuccessful`
  String get nichtGefunden {
    return Intl.message(
      'Not found / search unsuccessful',
      name: 'nichtGefunden',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get nichtBekannt {
    return Intl.message(
      'Unknown',
      name: 'nichtBekannt',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
