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

  /// `It's possible you may only see stars if you enable this setting`
  String get settingsShowNamesBody {
    return Intl.message(
      'It\'s possible you may only see stars if you enable this setting',
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

  /// `Give feedback`
  String get settingsDonate {
    return Intl.message(
      'Give feedback',
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

  /// `Species`
  String get sortGameType {
    return Intl.message(
      'Species',
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

  /// `Usages`
  String get usages {
    return Intl.message(
      'Usages',
      name: 'usages',
      desc: '',
      args: [],
    );
  }

  /// `Roe deer`
  String get rehwild {
    return Intl.message(
      'Roe deer',
      name: 'rehwild',
      desc: '',
      args: [],
    );
  }

  /// `Deer`
  String get rotwild {
    return Intl.message(
      'Deer',
      name: 'rotwild',
      desc: '',
      args: [],
    );
  }

  /// `Chamois`
  String get gamswild {
    return Intl.message(
      'Chamois',
      name: 'gamswild',
      desc: '',
      args: [],
    );
  }

  /// `Ibex`
  String get steinwild {
    return Intl.message(
      'Ibex',
      name: 'steinwild',
      desc: '',
      args: [],
    );
  }

  /// `Wild boar`
  String get schwarzwild {
    return Intl.message(
      'Wild boar',
      name: 'schwarzwild',
      desc: '',
      args: [],
    );
  }

  /// `Playcock`
  String get spielhahn {
    return Intl.message(
      'Playcock',
      name: 'spielhahn',
      desc: '',
      args: [],
    );
  }

  /// `Rock partridge`
  String get steinhuhn {
    return Intl.message(
      'Rock partridge',
      name: 'steinhuhn',
      desc: '',
      args: [],
    );
  }

  /// `Grouse`
  String get schneehuhn {
    return Intl.message(
      'Grouse',
      name: 'schneehuhn',
      desc: '',
      args: [],
    );
  }

  /// `Marmot`
  String get murmeltier {
    return Intl.message(
      'Marmot',
      name: 'murmeltier',
      desc: '',
      args: [],
    );
  }

  /// `Badger`
  String get dachs {
    return Intl.message(
      'Badger',
      name: 'dachs',
      desc: '',
      args: [],
    );
  }

  /// `Fox`
  String get fuchs {
    return Intl.message(
      'Fox',
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

  /// `Killed`
  String get erlegt {
    return Intl.message(
      'Killed',
      name: 'erlegt',
      desc: '',
      args: [],
    );
  }

  /// `Found dead`
  String get fallwild {
    return Intl.message(
      'Found dead',
      name: 'fallwild',
      desc: '',
      args: [],
    );
  }

  /// `Conservation kill`
  String get hegeabschuss {
    return Intl.message(
      'Conservation kill',
      name: 'hegeabschuss',
      desc: '',
      args: [],
    );
  }

  /// `Car accident`
  String get strassenunfall {
    return Intl.message(
      'Car accident',
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

  /// `Killed by train`
  String get vomZug {
    return Intl.message(
      'Killed by train',
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

  /// `Personal use`
  String get eigengebrauch {
    return Intl.message(
      'Personal use',
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

  /// `Sale`
  String get verkauf {
    return Intl.message(
      'Sale',
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

  /// `Initial position`
  String get mapInitialPosition {
    return Intl.message(
      'Initial position',
      name: 'mapInitialPosition',
      desc: '',
      args: [],
    );
  }

  /// `{howMany, plural, one{1 Kill} other{{howMany} Kills}}`
  String xKill_s(num howMany) {
    return Intl.plural(
      howMany,
      one: '1 Kill',
      other: '$howMany Kills',
      name: 'xKill_s',
      desc: '',
      args: [howMany],
    );
  }

  /// `Nothing to see here..`
  String get noDataFoundText {
    return Intl.message(
      'Nothing to see here..',
      name: 'noDataFoundText',
      desc: '',
      args: [],
    );
  }

  /// `Overseer`
  String get overseer {
    return Intl.message(
      'Overseer',
      name: 'overseer',
      desc: '',
      args: [],
    );
  }

  /// `Error: Kills could not be loaded!`
  String get noKillsLoadedError {
    return Intl.message(
      'Error: Kills could not be loaded!',
      name: 'noKillsLoadedError',
      desc: '',
      args: [],
    );
  }

  /// `Your login credentials are no longer valid!`
  String get loginDataInvalid {
    return Intl.message(
      'Your login credentials are no longer valid!',
      name: 'loginDataInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `New kills`
  String get newKills {
    return Intl.message(
      'New kills',
      name: 'newKills',
      desc: '',
      args: [],
    );
  }

  /// `{x} new kills were found!`
  String xNewKillsFound(Object x) {
    return Intl.message(
      '$x new kills were found!',
      name: 'xNewKillsFound',
      desc: '',
      args: [x],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Display`
  String get display {
    return Intl.message(
      'Display',
      name: 'display',
      desc: '',
      args: [],
    );
  }

  /// `Grid`
  String get grid {
    return Intl.message(
      'Grid',
      name: 'grid',
      desc: '',
      args: [],
    );
  }

  /// `Only shot`
  String get onlyShot {
    return Intl.message(
      'Only shot',
      name: 'onlyShot',
      desc: '',
      args: [],
    );
  }

  /// `Point`
  String get points {
    return Intl.message(
      'Point',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Configuration`
  String get configuration {
    return Intl.message(
      'Configuration',
      name: 'configuration',
      desc: '',
      args: [],
    );
  }

  /// `per Month`
  String get perMonth {
    return Intl.message(
      'per Month',
      name: 'perMonth',
      desc: '',
      args: [],
    );
  }

  /// `The charts are based on your downloaded data. If a year is missing, you can select and download it on the start page.\n\nThese diagrams provide information about the historical development of the game in your area and have been designed in such a way that you can configure the structure yourself!`
  String get chartBasedOnDownloaded {
    return Intl.message(
      'The charts are based on your downloaded data. If a year is missing, you can select and download it on the start page.\n\nThese diagrams provide information about the historical development of the game in your area and have been designed in such a way that you can configure the structure yourself!',
      name: 'chartBasedOnDownloaded',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get yearly {
    return Intl.message(
      'Yearly',
      name: 'yearly',
      desc: '',
      args: [],
    );
  }

  /// `Historic`
  String get historic {
    return Intl.message(
      'Historic',
      name: 'historic',
      desc: '',
      args: [],
    );
  }

  /// `Sum`
  String get sum {
    return Intl.message(
      'Sum',
      name: 'sum',
      desc: '',
      args: [],
    );
  }

  /// `Distribution`
  String get distribution {
    return Intl.message(
      'Distribution',
      name: 'distribution',
      desc: '',
      args: [],
    );
  }

  /// `Monthly breakdown`
  String get monthlyBreakdown {
    return Intl.message(
      'Monthly breakdown',
      name: 'monthlyBreakdown',
      desc: '',
      args: [],
    );
  }

  /// `Yearly breakdown`
  String get yearlyBreakdown {
    return Intl.message(
      'Yearly breakdown',
      name: 'yearlyBreakdown',
      desc: '',
      args: [],
    );
  }

  /// `Seen by {x} on {y} at {z}`
  String seenByXonYatZ(Object x, Object y, Object z) {
    return Intl.message(
      'Seen by $x on $y at $z',
      name: 'seenByXonYatZ',
      desc: '',
      args: [x, y, z],
    );
  }

  /// `Check out this kill in {x}!\n{y}`
  String checkOutThisKillXY(Object x, Object y) {
    return Intl.message(
      'Check out this kill in $x!\n$y',
      name: 'checkOutThisKillXY',
      desc: '',
      args: [x, y],
    );
  }

  /// `Female chamois`
  String get gamsgeiss {
    return Intl.message(
      'Female chamois',
      name: 'gamsgeiss',
      desc: '',
      args: [],
    );
  }

  /// `Trophy buck`
  String get tBock {
    return Intl.message(
      'Trophy buck',
      name: 'tBock',
      desc: '',
      args: [],
    );
  }

  /// `Buck fawn`
  String get bockkitz {
    return Intl.message(
      'Buck fawn',
      name: 'bockkitz',
      desc: '',
      args: [],
    );
  }

  /// `Chamois buck`
  String get gamsbock {
    return Intl.message(
      'Chamois buck',
      name: 'gamsbock',
      desc: '',
      args: [],
    );
  }

  /// `Old doe`
  String get altgeiss {
    return Intl.message(
      'Old doe',
      name: 'altgeiss',
      desc: '',
      args: [],
    );
  }

  /// `Young buck`
  String get jahrlingsHirsch {
    return Intl.message(
      'Young buck',
      name: 'jahrlingsHirsch',
      desc: '',
      args: [],
    );
  }

  /// `Young doe`
  String get schmalreh {
    return Intl.message(
      'Young doe',
      name: 'schmalreh',
      desc: '',
      args: [],
    );
  }

  /// `Young buck`
  String get jahrlingsbock {
    return Intl.message(
      'Young buck',
      name: 'jahrlingsbock',
      desc: '',
      args: [],
    );
  }

  /// `Female fawn`
  String get geisskitz {
    return Intl.message(
      'Female fawn',
      name: 'geisskitz',
      desc: '',
      args: [],
    );
  }

  /// `Young female`
  String get geissjahrling {
    return Intl.message(
      'Young female',
      name: 'geissjahrling',
      desc: '',
      args: [],
    );
  }

  /// `Female fawn`
  String get wildkalb {
    return Intl.message(
      'Female fawn',
      name: 'wildkalb',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get M {
    return Intl.message(
      'Male',
      name: 'M',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get W {
    return Intl.message(
      'Female',
      name: 'W',
      desc: '',
      args: [],
    );
  }

  /// `Male fawn`
  String get hirschkalb {
    return Intl.message(
      'Male fawn',
      name: 'hirschkalb',
      desc: '',
      args: [],
    );
  }

  /// `Trophy buck`
  String get trophaehenHirsch {
    return Intl.message(
      'Trophy buck',
      name: 'trophaehenHirsch',
      desc: '',
      args: [],
    );
  }

  /// `Adult female`
  String get alttier {
    return Intl.message(
      'Adult female',
      name: 'alttier',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get maennlich {
    return Intl.message(
      'Male',
      name: 'maennlich',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get weiblich {
    return Intl.message(
      'Female',
      name: 'weiblich',
      desc: '',
      args: [],
    );
  }

  /// `Wild boar`
  String get frischling {
    return Intl.message(
      'Wild boar',
      name: 'frischling',
      desc: '',
      args: [],
    );
  }

  /// `Young male boar`
  String get ueberlaeuferKeiler {
    return Intl.message(
      'Young male boar',
      name: 'ueberlaeuferKeiler',
      desc: '',
      args: [],
    );
  }

  /// `Male boar`
  String get keiler {
    return Intl.message(
      'Male boar',
      name: 'keiler',
      desc: '',
      args: [],
    );
  }

  /// `Stone doe`
  String get steingeiss {
    return Intl.message(
      'Stone doe',
      name: 'steingeiss',
      desc: '',
      args: [],
    );
  }

  /// `Stone buck`
  String get steinbock {
    return Intl.message(
      'Stone buck',
      name: 'steinbock',
      desc: '',
      args: [],
    );
  }

  /// `chamois yearlings`
  String get gamsjahrlinge {
    return Intl.message(
      'chamois yearlings',
      name: 'gamsjahrlinge',
      desc: '',
      args: [],
    );
  }

  /// `Young doe`
  String get schmaltier {
    return Intl.message(
      'Young doe',
      name: 'schmaltier',
      desc: '',
      args: [],
    );
  }

  /// `Deer`
  String get kahlwild {
    return Intl.message(
      'Deer',
      name: 'kahlwild',
      desc: '',
      args: [],
    );
  }

  /// `Female deer`
  String get weiblicheRehe {
    return Intl.message(
      'Female deer',
      name: 'weiblicheRehe',
      desc: '',
      args: [],
    );
  }

  /// `Young buck`
  String get bockjahrling {
    return Intl.message(
      'Young buck',
      name: 'bockjahrling',
      desc: '',
      args: [],
    );
  }

  /// `Female boar`
  String get bache {
    return Intl.message(
      'Female boar',
      name: 'bache',
      desc: '',
      args: [],
    );
  }

  /// `Young female boar`
  String get ueberlaeuferBache {
    return Intl.message(
      'Young female boar',
      name: 'ueberlaeuferBache',
      desc: '',
      args: [],
    );
  }

  /// `Beta mode`
  String get betaModeTitle {
    return Intl.message(
      'Beta mode',
      name: 'betaModeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Some features may not work correctly.`
  String get betaModeDescription {
    return Intl.message(
      'Some features may not work correctly.',
      name: 'betaModeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Only visible kills are exported.`
  String get ksExportSubtitle {
    return Intl.message(
      'Only visible kills are exported.',
      name: 'ksExportSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Error: No kills to export.`
  String get ksExportErrorSnackbar {
    return Intl.message(
      'Error: No kills to export.',
      name: 'ksExportErrorSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Hunting times {x} `
  String xJagdzeiten(Object x) {
    return Intl.message(
      'Hunting times $x ',
      name: 'xJagdzeiten',
      desc: '',
      args: [x],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get geschlossen {
    return Intl.message(
      'Closed',
      name: 'geschlossen',
      desc: '',
      args: [],
    );
  }

  /// `Select year`
  String get selectYear {
    return Intl.message(
      'Select year',
      name: 'selectYear',
      desc: '',
      args: [],
    );
  }

  /// `Both`
  String get both {
    return Intl.message(
      'Both',
      name: 'both',
      desc: '',
      args: [],
    );
  }

  /// `Hunting times`
  String get jagdzeiten {
    return Intl.message(
      'Hunting times',
      name: 'jagdzeiten',
      desc: '',
      args: [],
    );
  }

  /// `Mating times`
  String get paarungszeiten {
    return Intl.message(
      'Mating times',
      name: 'paarungszeiten',
      desc: '',
      args: [],
    );
  }

  /// `Species`
  String get wild {
    return Intl.message(
      'Species',
      name: 'wild',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `weeks`
  String get wochen {
    return Intl.message(
      'weeks',
      name: 'wochen',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get tage {
    return Intl.message(
      'days',
      name: 'tage',
      desc: '',
      args: [],
    );
  }

  /// `months`
  String get monate {
    return Intl.message(
      'months',
      name: 'monate',
      desc: '',
      args: [],
    );
  }

  /// `breeding season`
  String get brutzeit {
    return Intl.message(
      'breeding season',
      name: 'brutzeit',
      desc: '',
      args: [],
    );
  }

  /// `gestation period`
  String get tragzeit {
    return Intl.message(
      'gestation period',
      name: 'tragzeit',
      desc: '',
      args: [],
    );
  }

  /// `with dormancy`
  String get mitKeimruhe {
    return Intl.message(
      'with dormancy',
      name: 'mitKeimruhe',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Add kill`
  String get addKill {
    return Intl.message(
      'Add kill',
      name: 'addKill',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel editing the new kill?`
  String get confirmAddKillCancel {
    return Intl.message(
      'Are you sure you want to cancel editing the new kill?',
      name: 'confirmAddKillCancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Choose coordinates on map`
  String get selectCoordinates {
    return Intl.message(
      'Choose coordinates on map',
      name: 'selectCoordinates',
      desc: '',
      args: [],
    );
  }

  /// `Edit kill`
  String get editKill {
    return Intl.message(
      'Edit kill',
      name: 'editKill',
      desc: '',
      args: [],
    );
  }

  /// `Mandatory`
  String get pflichtfeld {
    return Intl.message(
      'Mandatory',
      name: 'pflichtfeld',
      desc: '',
      args: [],
    );
  }

  /// `Number unreadable`
  String get zahlNichtGelesenError {
    return Intl.message(
      'Number unreadable',
      name: 'zahlNichtGelesenError',
      desc: '',
      args: [],
    );
  }

  /// `No negative numbers`
  String get zahlNegativError {
    return Intl.message(
      'No negative numbers',
      name: 'zahlNegativError',
      desc: '',
      args: [],
    );
  }

  /// `Weight in kg`
  String get weightInKg {
    return Intl.message(
      'Weight in kg',
      name: 'weightInKg',
      desc: '',
      args: [],
    );
  }

  /// `Date cannot be empty`
  String get dateEmptyError {
    return Intl.message(
      'Date cannot be empty',
      name: 'dateEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Time cannot be empty`
  String get timeEmptyError {
    return Intl.message(
      'Time cannot be empty',
      name: 'timeEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Time invalid`
  String get dateInFutureError {
    return Intl.message(
      'Time invalid',
      name: 'dateInFutureError',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Shooting times`
  String get schusszeiten {
    return Intl.message(
      'Shooting times',
      name: 'schusszeiten',
      desc: '',
      args: [],
    );
  }

  /// `Set now`
  String get jetztFestlegen {
    return Intl.message(
      'Set now',
      name: 'jetztFestlegen',
      desc: '',
      args: [],
    );
  }

  /// `You must first set a location for the sun times.`
  String get ortFestlegen {
    return Intl.message(
      'You must first set a location for the sun times.',
      name: 'ortFestlegen',
      desc: '',
      args: [],
    );
  }

  /// `The times are based on UTC and are converted to the format of the device.\nSwipe left or right to change the date.`
  String get timeInLocal {
    return Intl.message(
      'The times are based on UTC and are converted to the format of the device.\nSwipe left or right to change the date.',
      name: 'timeInLocal',
      desc: '',
      args: [],
    );
  }

  /// `Select starting point`
  String get defaultLocationTitle {
    return Intl.message(
      'Select starting point',
      name: 'defaultLocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Default view when adding a kill or calculating shot times.`
  String get defaultLocationDescription {
    return Intl.message(
      'Default view when adding a kill or calculating shot times.',
      name: 'defaultLocationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication`
  String get useLocalAuth {
    return Intl.message(
      'Biometric authentication',
      name: 'useLocalAuth',
      desc: '',
      args: [],
    );
  }

  /// `App`
  String get appSettings {
    return Intl.message(
      'App',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `If you activate biometric authentication, you will be asked for the login data stored on your device when you start the app.\nDo you want to enable biometrics? (recommended)`
  String get shouldUseLocalAuth {
    return Intl.message(
      'If you activate biometric authentication, you will be asked for the login data stored on your device when you start the app.\nDo you want to enable biometrics? (recommended)',
      name: 'shouldUseLocalAuth',
      desc: '',
      args: [],
    );
  }

  /// `Biometrics`
  String get biometrics {
    return Intl.message(
      'Biometrics',
      name: 'biometrics',
      desc: '',
      args: [],
    );
  }

  /// `Since you have biometric authentication enabled, you must be logged in to see kills!`
  String get needLogin {
    return Intl.message(
      'Since you have biometric authentication enabled, you must be logged in to see kills!',
      name: 'needLogin',
      desc: '',
      args: [],
    );
  }

  /// `Error: No biometric data found!`
  String get noBiometricsFound {
    return Intl.message(
      'Error: No biometric data found!',
      name: 'noBiometricsFound',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get empfohlen {
    return Intl.message(
      'Recommended',
      name: 'empfohlen',
      desc: '',
      args: [],
    );
  }

  /// `You will be automatically logged in...`
  String get willBeLoggedInAuto {
    return Intl.message(
      'You will be automatically logged in...',
      name: 'willBeLoggedInAuto',
      desc: '',
      args: [],
    );
  }

  /// `Legend`
  String get legend {
    return Intl.message(
      'Legend',
      name: 'legend',
      desc: '',
      args: [],
    );
  }

  /// `Border`
  String get border {
    return Intl.message(
      'Border',
      name: 'border',
      desc: '',
      args: [],
    );
  }

  /// `If you have problems logging in, you can reset all settings.\nAttention: This will deregister you and you will have to register again!`
  String get signOutResetAll {
    return Intl.message(
      'If you have problems logging in, you can reset all settings.\nAttention: This will deregister you and you will have to register again!',
      name: 'signOutResetAll',
      desc: '',
      args: [],
    );
  }

  /// `Get started`
  String get loslegen {
    return Intl.message(
      'Get started',
      name: 'loslegen',
      desc: '',
      args: [],
    );
  }

  /// `A publication of the South Tyrolean Hunting Association`
  String get sjvPublikation {
    return Intl.message(
      'A publication of the South Tyrolean Hunting Association',
      name: 'sjvPublikation',
      desc: '',
      args: [],
    );
  }

  /// `What impact do wildlife diseases have on your hunting ground?\nHas more roe deer been shot in recent years than this year?\nAnd much more...`
  String get onboardStatDesc {
    return Intl.message(
      'What impact do wildlife diseases have on your hunting ground?\nHas more roe deer been shot in recent years than this year?\nAnd much more...',
      name: 'onboardStatDesc',
      desc: '',
      args: [],
    );
  }

  /// `Check the hunting times of different game species and the shooting time of the day`
  String get onboardUtilDesc {
    return Intl.message(
      'Check the hunting times of different game species and the shooting time of the day',
      name: 'onboardUtilDesc',
      desc: '',
      args: [],
    );
  }

  /// `Hunting companion`
  String get jagdbegleiter {
    return Intl.message(
      'Hunting companion',
      name: 'jagdbegleiter',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `All kills visualized and mapped in a modern way!\nEnter kills directly into the app`
  String get onboardTerritoryDesc {
    return Intl.message(
      'All kills visualized and mapped in a modern way!\nEnter kills directly into the app',
      name: 'onboardTerritoryDesc',
      desc: '',
      args: [],
    );
  }

  /// `Your territory`
  String get yourTerritory {
    return Intl.message(
      'Your territory',
      name: 'yourTerritory',
      desc: '',
      args: [],
    );
  }

  /// `Reset database`
  String get deleteDatabaseTitle {
    return Intl.message(
      'Reset database',
      name: 'deleteDatabaseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete kills and re-download them. Run this operation to fix any errors.`
  String get deleteDatabaseDescription {
    return Intl.message(
      'Delete kills and re-download them. Run this operation to fix any errors.',
      name: 'deleteDatabaseDescription',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to reset the database?`
  String get confirmDeleteDatabase {
    return Intl.message(
      'Are you sure you want to reset the database?',
      name: 'confirmDeleteDatabase',
      desc: '',
      args: [],
    );
  }

  /// `List refreshed.`
  String get refreshListConfirmation {
    return Intl.message(
      'List refreshed.',
      name: 'refreshListConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message(
      'Map',
      name: 'map',
      desc: '',
      args: [],
    );
  }

  /// `Share app`
  String get share {
    return Intl.message(
      'Share app',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Check out the hunting statistics app!\n\n{link}`
  String shareAppText(Object link) {
    return Intl.message(
      'Check out the hunting statistics app!\n\n$link',
      name: 'shareAppText',
      desc: '',
      args: [link],
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
