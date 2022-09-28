import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jagdstatistik/providers/locale_provider.dart';
import 'package:jagdstatistik/providers/pref_provider.dart';
import 'package:jagdstatistik/views/add_kill_screen.dart';
import 'package:jagdstatistik/views/all_map_screen.dart';
import 'package:jagdstatistik/views/credentials_screen.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/database_methods.dart';
import 'package:jagdstatistik/models/kill_page.dart';
import 'package:jagdstatistik/utils/request_methods.dart';
import 'package:jagdstatistik/views/settings_screen.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:jagdstatistik/widgets/chip_selector_modal.dart';
import 'package:jagdstatistik/models/filter_chip_data.dart';
import 'package:jagdstatistik/widgets/no_data_found.dart';
import 'package:jagdstatistik/widgets/value_selector_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/kill_entry.dart';

import '../models/sorting.dart';
import '../widgets/kill_list_entry.dart';

class KillsScreen extends StatefulWidget {
  const KillsScreen({Key? key}) : super(key: key);

  @override
  State<KillsScreen> createState() => _KillsScreenState();
}

class _KillsScreenState extends State<KillsScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0);

  bool _isLoading = true;
  ValueNotifier<bool>? _isFabVisible;
  bool _showSearch = false;

  late int _currentYear;
  List<int> _yearList = [];
  late DateTime _lastRefresh;
  late Sorting _currentSorting;
  List<Sorting> _sortings = [];

  KillPage? page;
  List<KillEntry> filteredKills = [];
  List<KillEntry> newKills = [];

  List<FilterChipData> wildChips = [];
  List<FilterChipData> ursacheChips = [];
  List<FilterChipData> verwendungChips = [];
  List<FilterChipData> geschlechterChips = [];

  @override
  void initState() {
    super.initState();

    _currentYear = DateTime.now().year;
    _yearList = List.generate(
      _currentYear - 2015 + 1,
      (index) => index + 2015,
    ).reversed.toList();

    _lastRefresh = DateTime.now()
        .subtract(const Duration(seconds: 60)); // first refresh can happen instantly
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final dg = S.of(context);
      _sortings = (Sorting.generateDefault(context));
      _currentSorting =
          _sortings.firstWhere((element) => element.sortType == SortType.datum);

      await loadYear(_currentYear);
      print('Loaded initial page for year $_currentYear: $page');
      setState(() {
        _isLoading = false;
      });
      KillPage? p2 = await refresh(
          _currentYear); // Refresh current year if launching app to check for updates
      if (page != null && p2 != null && page!.kills.isNotEmpty && page != p2) {
        // If internet is returning LESS kills, delete from DB and replace with internet
        if (p2.kills.length < page!.kills.length) {
          await SqliteDB().deleteYear(_currentYear);
          await SqliteDB().insertKills(_currentYear, p2);
          print('Internet returned less kills. Replaced SQL');
          return;
        } else {
          newKills = p2.kills.where((k) {
            return !page!.kills.contains(k);
          }).toList();

          showAlertDialog(
            title: ' ${dg.newKills}',
            description: dg.xNewKillsFound(newKills.length),
            yesOption: '',
            noOption: dg.close,
            onYes: () {},
            icon: Icons.fiber_new_rounded,
            context: context,
          );

          updateYearUI(p2);
        }
      }
      loadPastYearsIfNotExisting(); // Async loads all historic years in BG if not existing
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    // On logout, re-select all chips to make sure that on login you arent filtering anything
    // This probably doesn't even do much but eh
    wildChips.forEach((element) => element.isSelected = true);
    ursacheChips.forEach((element) => element.isSelected = true);
    verwendungChips.forEach((element) => element.isSelected = true);
    geschlechterChips.forEach((element) => element.isSelected = true);

    super.dispose();
  }

  void loadPastYearsIfNotExisting() async {
    // Load all years in background
    for (int y in _yearList.sublist(1)) {
// If DB has no entries for a given year, refresh for that year
      if (await readFromDb(y) == null) await refresh(y);
    }
  }

  Future<void> loadYear(int year, {bool updateUI = true}) async {
    KillPage? p = await readFromDb(year);
    // P is null if db has no entries for this year -> refresh
    // If last refresh was more than 60 seconds ago we (=true on init) can query again
    if (p == null) {
      print('DB returned null. Refreshing from Internet...');
      if (updateUI) {
        // Not clean in here but maaan
        if (!mounted) return;
        setState(() {
          _isLoading = true;
        });
      }

      KillPage? p2 = await refresh(year);
      if (!mounted) return;
      final dg = S.of(context);

      if (p2 != null) {
        if (page != null &&
            page!.jahr == year &&
            page!.kills.isNotEmpty &&
            p2.kills.isNotEmpty &&
            page != p2) {
          // If internet is returning LESS kills, delete from DB and replace with internet
          if (p2.kills.length < page!.kills.length) {
            await SqliteDB().deleteYear(_currentYear);
            await SqliteDB().insertKills(_currentYear, p2);
            return;
          } else {
            print('Changes found!');
            newKills = p2.kills.where((k) {
              return !page!.kills.contains(k);
            }).toList();

            showAlertDialog(
              title: ' ${dg.newKills}',
              description: dg.xNewKillsFound(newKills.length),
              yesOption: '',
              noOption: dg.close,
              onYes: () {},
              icon: Icons.fiber_new_rounded,
              context: context,
            );

            updateUI = true;
          }
        }

        p = p2; // Prioritize Internet loaded data
      }
    }

    // Update UI if data was found, otherwise set null -> Page shown is empty
    if (updateUI) updateYearUI(p);

    return;
  }

  void updateYearUI(KillPage? page) {
    this.page = page;
    if (page != null) {
      wildChips = page.wildarten;
      ursacheChips = page.ursachen;
      verwendungChips = page.verwendungen;
      geschlechterChips = page.geschlechter;
    }
    setState(() {
      _isLoading = false;
    });
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 1500), curve: Curves.decelerate);
  }

  List<KillEntry> chipFilter(List<KillEntry> kills) {
    List<KillEntry> filtered = [];

    // Find all selected chips and see if contains
    for (KillEntry k in kills) {
      if (wildChips.where((e) => e.isSelected).map((e) => e.label).contains(k.wildart) &&
          ursacheChips
              .where((e) => e.isSelected)
              .map((e) => e.label)
              .contains(k.ursache) &&
          verwendungChips
              .where((e) => e.isSelected)
              .map((e) => e.label)
              .contains(k.verwendung) &&
          geschlechterChips
              .where((e) => e.isSelected)
              .map((e) => e.label)
              .contains(k.geschlecht)) {
        filtered.add(k);
      }
    }

    return filtered;
  }

  Future<KillPage?> readFromDb(int year) async {
    KillPage? page;
    try {
      await SqliteDB().db.then((d) async {
        List<Map<String, Object?>> kills = await d.query('Kill', where: 'year = $year');

        print('SQL found ${kills.length} entries for year $year');
        List<KillEntry> killList = [];

        for (Map<String, Object?> m in kills) {
          KillEntry? k = KillEntry.fromMap(m);
          if (k != null) {
            killList.add(k);
          }
        }
        try {
          // Return new kill page. Throws BadState: No Element for kills.first if kills is null
          page = KillPage.fromList(kills.first['revier'] as String, year, killList);
        } catch (e) {
          print('Error parsing KillPage: ${e.toString()}');
        }
      });
    } catch (e) {
      print('Database exception ${e.toString()}');
    }
    return page;
  }

  void invalidCredentialsLogout() async {
    final dg = S.of(context);
    await showAlertDialog(
      title: dg.error,
      description: dg.loginDataInvalid,
      yesOption: 'Ok',
      noOption: '',
      onYes: () {},
      icon: Icons.error,
      context: context,
    );

    deletePrefs();
    if (!mounted) return null;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CredentialsScreen()));
  }

  Future<KillPage?> refresh(int year) async {
    final dg = S.of(context);
    if (await Connectivity().checkConnectivity().timeout(const Duration(seconds: 15)) ==
        ConnectivityResult.none) {
      showSnackBar(dg.noInternetError, context);
      return null;
    }

    KillPage? page = await RequestMethods.getPage(year)
        .timeout(const Duration(seconds: 15), onTimeout: () {
      _lastRefresh = DateTime.now().subtract(const Duration(
          seconds: 15)); // Can refresh after 15-30 seconds since error occured
      if (mounted) {
        showSnackBar(dg.noKillsLoadedError, context);
      }
      return null;
    });

    _lastRefresh = DateTime.now();

    if (page == null) {
      invalidCredentialsLogout();
    } else {
      return page;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // listen for locale changes
    final localeProvider = Provider.of<LocaleProvider>(context);
    final prefs = Provider.of<PrefProvider>(context);
    _isFabVisible = prefs.betaMode ? ValueNotifier(true) : null;

    final delegate = S.of(context);

    super.build(context); // explicit

    if (page == null) {
      return Scaffold(
        appBar: ChartAppBar(
          title: Text(delegate.ksTerritoryTitle),
          actions: buildActionButtons(),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    }

    Size size = MediaQuery.of(context).size;

    filteredKills = chipFilter(page == null ? [] : page!.kills);

    filteredKills = filteredKills.where((k) {
      if (controller.text.isEmpty) {
        return true;
      } else {
        String query = controller.text.toLowerCase();
        return k.contains(query);
      }
    }).toList();

    filteredKills = _currentSorting.sort(filteredKills);

    return Scaffold(
      appBar: ChartAppBar(
        title: _showSearch
            ? buildToolbarSearchbar()
            : InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  if (await Connectivity()
                          .checkConnectivity()
                          .timeout(const Duration(seconds: 15)) ==
                      ConnectivityResult.none) {
                    showSnackBar(delegate.noInternetError, context);
                    return;
                  }
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AllMapScreen(page: page!)));
                  setState(() {});
                },
                child: Row(
                  children: [
                    const Icon(Icons.map_rounded),
                    const SizedBox(width: 5),
                    Text(page == null ? delegate.ksTerritoryTitle : page!.revierName),
                  ],
                ),
              ),
        //backgroundColor: Colors.green,
        actions: buildActionButtons(),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          constraints:
              const BoxConstraints(minWidth: 100, maxWidth: 1000, minHeight: 400),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  children: buildActionChips(),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: size.height * 0.01)),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : filteredKills.isEmpty
                      ? const Expanded(child: NoDataFoundWidget())
                      : Expanded(flex: 9, child: buildKillEntries(filteredKills)),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFab(isVisible: _isFabVisible ?? ValueNotifier(false)),
    );
  }

  List<Widget> buildActionButtons() {
    return <Widget>[
      IconButton(
        onPressed: () {
          if (controller.text.isNotEmpty) controller.text = "";
          setState(() => _showSearch = !_showSearch);
        },
        icon: Icon(_showSearch ? Icons.close : Icons.search),
      ),
      IconButton(
        onPressed: () => Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => const SettingsScreen()),
        ),
        icon: const Icon(Icons.settings),
      ),
    ];
  }

  Widget buildToolbarSearchbar() {
    final dg = S.of(context);
    return Center(
      child: TextField(
        autofocus: true,
        onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: dg.searchXKills(filteredKills.length),
        ),
        onChanged: (query) => setState(() {}),
      ),
    );
  }

  List<Widget> buildActionChips() {
    final dg = S.of(context);
    ShapeBorder modalShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
    EdgeInsets chipPadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 0);

    int selectedWildChips = wildChips.where((e) => e.isSelected).length;
    int selectedUrsachenChips = ursacheChips.where((e) => e.isSelected).length;
    int selectedVerwendungenChips = verwendungChips.where((e) => e.isSelected).length;
    int selectedGeschlechterChips = geschlechterChips.where((e) => e.isSelected).length;

    //bool darkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return [
      Padding(
        padding: chipPadding,
        child: ActionChip(
            avatar: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.filter_list_alt,
                color: schneehaseFarbe,
                size: 18,
              ),
            ),
            backgroundColor: schneehaseFarbe.withOpacity(0.25),
            labelStyle: const TextStyle(color: schneehaseFarbe),
            label: Text('$_currentYear'),
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return ValueSelectorModal<int>(
                      items: _yearList,
                      selectedItem: _currentYear,
                      onSelect: (selectedYear) async {
                        if (selectedYear != _currentYear) {
                          await loadYear(selectedYear);
                          setState(() {});
                          _currentYear = selectedYear;
                          _scrollToTop();
                        }
                      },
                    );
                    //return buildYearModalSheet();
                  });
            }),
      ),
      Padding(
        padding: chipPadding,
        child: ActionChip(
            avatar: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.sort,
                color: steinhuhnFarbe,
                size: 18,
              ),
            ),
            backgroundColor: steinhuhnFarbe.withOpacity(0.25),
            labelStyle: const TextStyle(color: steinhuhnFarbe),
            label: Text(dg.sortTitle),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return buildSortierungModalSheet();
                  });
              if (mounted) setState(() {});
            }),
      ),
      Padding(
        padding: chipPadding,
        child: ActionChip(
            avatar: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                selectedWildChips < wildChips.length
                    ? Icons.filter_list_rounded
                    : Icons.checklist_rtl_sharp,
                color: wildFarbe,
                size: 18,
              ),
            ),
            backgroundColor: wildFarbe.withOpacity(0.25),
            labelStyle: const TextStyle(color: wildFarbe),
            label: Text('$selectedWildChips ${dg.gameTypes}'),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return ChipSelectorModal(
                      key: const Key('GameSelectorModal'),
                      title: dg.gameTypes,
                      chips: wildChips,
                    );
                  });
              if (mounted) setState(() {});
            }),
      ),
      Padding(
        padding: chipPadding,
        child: ActionChip(
            avatar: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                selectedGeschlechterChips < geschlechterChips.length
                    ? Icons.filter_list_rounded
                    : Icons.checklist_rtl_sharp,
                color: protokollFarbe,
                size: 18,
              ),
            ),
            backgroundColor: protokollFarbe.withOpacity(0.25),
            labelStyle: const TextStyle(color: protokollFarbe),
            label: Text('$selectedGeschlechterChips ${dg.sexes}'),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return ChipSelectorModal(
                      key: const Key('SexSelectorModal'),
                      title: dg.sexes,
                      chips: geschlechterChips,
                    );
                  });
              if (mounted) setState(() {});
            }),
      ),
      Padding(
        padding: chipPadding,
        child: ActionChip(
            avatar: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                selectedUrsachenChips < ursacheChips.length
                    ? Icons.filter_list_rounded
                    : Icons.checklist_rtl_sharp,
                color: hegeabschussFarbe,
                size: 18,
              ),
            ),
            backgroundColor: hegeabschussFarbe.withOpacity(0.25),
            labelStyle: const TextStyle(color: hegeabschussFarbe),
            label: Text('$selectedUrsachenChips ${dg.causes}'),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return ChipSelectorModal(
                      key: const Key('CauseSelectorModal'),
                      title: dg.causes,
                      chips: ursacheChips,
                    );
                  });
              if (mounted) setState(() {});
            }),
      ),
      Padding(
        padding: chipPadding,
        child: ActionChip(
            avatar: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                selectedVerwendungenChips < verwendungChips.length
                    ? Icons.filter_list_rounded
                    : Icons.checklist_rtl_sharp,
                color: nichtBekanntFarbe,
                size: 18,
              ),
            ),
            backgroundColor: nichtBekanntFarbe.withOpacity(0.25),
            labelStyle: const TextStyle(color: nichtBekanntFarbe),
            label: Text('$selectedVerwendungenChips ${dg.usages}'),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return ChipSelectorModal(
                        key: const Key('UsageSelectorModal'),
                        title: dg.usages,
                        chips: verwendungChips);
                  });
              if (mounted) setState(() {});
            }),
      ),
      Padding(
        padding: chipPadding,
        child: ActionChip(
          avatar: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.download_rounded,
              color: Colors.lightBlue[700],
              size: 18,
            ),
          ),
          backgroundColor: Colors.lightBlue[700]!.withOpacity(0.3),
          labelStyle: TextStyle(color: Colors.lightBlue[700]),
          label: Text(dg.ksExport),
          onPressed: () => _selectExport(context),
        ),
      ),
    ];
  }

  Future<void> _saveAndShareFile({String csvDelimiter = ";", bool isJson = false}) async {
    final dg = S.of(context);
    if (filteredKills.isEmpty || page == null) {
      showSnackBar(dg.ksExportErrorSnackbar, context);
      return;
    }

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // ONLY AVAILABLE ON ANDROID
    final dir =
        (await getExternalStorageDirectories(type: StorageDirectory.downloads))!.first;

    final filteredPage =
        KillPage(jahr: page!.jahr, revierName: page!.revierName, kills: filteredKills);

    String filename =
        '${dir.path}/${filteredPage.revierName}-${DateTime.now().toIso8601String()}';

    filename = isJson ? '$filename.json' : '$filename.csv';

    File f = await File(filename).create(recursive: true);

    if (!mounted) return;
    if (isJson) {
      f.writeAsStringSync(jsonEncode(filteredPage.toJson(context)), encoding: utf8);
    } else {
      f.writeAsStringSync(
          ListToCsvConverter(fieldDelimiter: csvDelimiter)
              .convert(filteredPage.toCSV(context)),
          encoding: utf8);
    }

    await Share.shareFiles([filename]);

    f.delete(); // Delete after sharing
    return;
  }

  _selectExport(BuildContext context) async {
    final dg = S.of(context);
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(dg.ksExportDialogTitle, textAlign: TextAlign.center),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('CSV (;)', textAlign: TextAlign.center),
                onPressed: () async {
                  if (page == null || page!.kills.isEmpty) {
                    showSnackBar(dg.noKillsFoundError, context);
                    return;
                  }
                  _saveAndShareFile(csvDelimiter: ';');

                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('CSV (,)', textAlign: TextAlign.center),
                onPressed: () async {
                  if (page == null || page!.kills.isEmpty) {
                    showSnackBar(dg.noKillsFoundError, context);
                    return;
                  }
                  _saveAndShareFile(csvDelimiter: ',');

                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('JSON', textAlign: TextAlign.center),
                onPressed: () {
                  if (page == null || page!.kills.isEmpty) {
                    showSnackBar(dg.noKillsFoundError, context);
                    return;
                  }
                  _saveAndShareFile(isJson: true);

                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: Text(
                    dg.ksExportSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }

  Widget buildSortierungModalSheet() {
    List<Widget> buttonList = [];
    buttonList.add(_buildHandle(context));
    Size size = MediaQuery.of(context).size;

    _sortings = Sorting.generateDefault(context);

    for (Sorting s in _sortings) {
      buttonList.add(
        MaterialButton(
          minWidth: size.width,
          onPressed: () {
            if (_currentSorting == s) {
              _currentSorting.toggleDirection();
            } else {
              _currentSorting = s;
            }
            Navigator.of(context).pop();
            _scrollToTop();
          },
          elevation: 2,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1, vertical: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                s.label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: s == _currentSorting ? FontWeight.bold : FontWeight.normal,
                  color: s == _currentSorting
                      ? Colors.green
                      : Theme.of(context).textTheme.headline1!.color,
                ),
              ),
              const SizedBox(width: 12),
              s.sortType == SortType.kein || s != _currentSorting
                  ? Container()
                  : Icon(
                      _currentSorting.ascending
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: s == _currentSorting
                          ? Colors.green
                          : Theme.of(context).textTheme.headline1!.color,
                    ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: buttonList,
      ),
    );
  }

  Widget buildProgressBar(List<KillEntry> kills) {
    final dg = S.of(context);
    double percentage = kills.length / page!.kills.length;
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        left: w * 0.1,
        right: w * 0.1,
        top: 0,
        bottom: 15,
      ),
      child: Column(
        children: [
          //#c4 > h1
          const SizedBox(height: 10),
          Text(
            dg.ksShowXFromYProgressBar(kills.length, page!.kills.length),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            color: rehwildFarbe,
            value: percentage,
          )
        ],
      ),
    );
  }

  Widget buildKillEntries(List<KillEntry> kills) {
    final prefs = Provider.of<PrefProvider>(context);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (_isFabVisible != null) {
            if (notification.direction == ScrollDirection.reverse &&
                _isFabVisible!.value) {
              _isFabVisible!.value = false;
            } else if (notification.direction == ScrollDirection.forward &&
                !_isFabVisible!.value) {
              _isFabVisible!.value = true;
            }
          }
          return true;
        },
        child: Scrollbar(
          controller: _scrollController,
          interactive: true,
          child: ListView.builder(
            controller: _scrollController,
            cacheExtent: 1250, // pixels both directions
            itemCount: kills.length + 1,
            itemBuilder: ((context, index) {
              if (index == 0) return buildProgressBar(kills);

              KillEntry k = kills.elementAt(index - 1);
              return KillListEntry(
                key: Key(k.key),
                kill: k,
                initiallyExpanded: newKills.isEmpty ? false : newKills.contains(k),
                showPerson: prefs.showPerson,
                showEdit: prefs.betaMode,
                revier: page!.revierName,
              );
            }),
          ),
        ),
      ),
      onRefresh: () async {
        print(
            'Time since last refresh: ${DateTime.now().difference(_lastRefresh).inSeconds}');
        if (DateTime.now().difference(_lastRefresh).inSeconds < 60) {
          return;
        }
        await refresh(_currentYear);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomFab extends StatelessWidget {
  final ValueNotifier<bool> isVisible;
  const CustomFab({Key? key, required this.isVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      builder: (BuildContext context, value, Widget? child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: value
              ? FloatingActionButton(
                  onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => const AddKillScreen(),
                    fullscreenDialog: true,
                  )),
                  backgroundColor: Theme.of(context).textTheme.headline1!.color,
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  isExtended: true,
                  elevation: 5,
                  child: const Icon(Icons.add),
                )
              : const SizedBox(),
        );
      },
      valueListenable: isVisible,
    );
  }
}
