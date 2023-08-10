import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:jagdstatistik/models/filter_chip_data.dart';
import 'package:jagdstatistik/widgets/kills_screen/export_popup.dart';
import 'package:jagdstatistik/widgets/kills_screen/kill_list_filter_chip.dart';
import 'package:jagdstatistik/widgets/kills_screen/kill_list_progress_bar.dart';
import 'package:jagdstatistik/widgets/kills_screen/kill_list_sorting_modal.dart';
import 'package:jagdstatistik/widgets/no_data_found.dart';
import 'package:jagdstatistik/widgets/value_selector_modal.dart';
import 'package:provider/provider.dart';

import '../models/kill_entry.dart';

import '../models/sorting.dart';
import '../widgets/kill_list_entry.dart';

class KillsScreen extends StatefulWidget {
  const KillsScreen({Key? key}) : super(key: key);

  @override
  State<KillsScreen> createState() => _KillsScreenState();
}

class _KillsScreenState extends State<KillsScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0,
  );

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

  Set<FilterChipData> wildChips = {};
  Set<FilterChipData> ursacheChips = {};
  Set<FilterChipData> verwendungChips = {};
  Set<FilterChipData> geschlechterChips = {};

  @override
  void initState() {
    super.initState();

    _currentYear = DateTime.now().year;
    _yearList = List.generate(
      _currentYear - 2015 + 1,
      (index) => index + 2015,
    ).reversed.toList();

    _lastRefresh = DateTime.now().subtract(
        const Duration(seconds: 60)); // first refresh can happen instantly
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
    for (var element in wildChips) {
      element.isSelected = true;
    }
    for (var element in ursacheChips) {
      element.isSelected = true;
    }
    for (var element in verwendungChips) {
      element.isSelected = true;
    }
    for (var element in geschlechterChips) {
      element.isSelected = true;
    }

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
      if (wildChips
              .where((e) => e.isSelected)
              .map((e) => e.label)
              .contains(k.wildart) &&
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
        List<Map<String, Object?>> kills =
            await d.query('Kill', where: 'year = $year');

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
          page = KillPage.fromList(
              kills.first['revier'] as String, year, killList);
        } catch (e) {
          print('Error parsing KillPage: ${e.toString()}');
        }
      });
    } catch (e) {
      print('Database exception ${e.toString()}');
    }
    return page;
  }

  Future<List<KillEntry>> readAllFromDb() async {
    List<KillEntry> killList = [];
    try {
      await SqliteDB().db.then((d) async {
        List<Map<String, Object?>> kills = await d.query('Kill');

        print('SQL found ${kills.length} entries total');

        for (Map<String, Object?> m in kills) {
          KillEntry? k = KillEntry.fromMap(m);
          if (k != null) {
            killList.add(k);
          }
        }
      });
    } catch (e) {
      print('Database exception ${e.toString()}');
    }
    return killList;
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
    if (await Connectivity()
            .checkConnectivity()
            .timeout(const Duration(seconds: 15)) ==
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
    // ignore: unused_local_variable
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
        title: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async => _handleOpenMap(await readAllFromDb()),
          child: Ink(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                const Icon(Icons.map_rounded),
                const SizedBox(width: 5),
                _showSearch
                    ? buildToolbarSearchbar()
                    : Text(page == null
                        ? delegate.ksTerritoryTitle
                        : page!.revierName),
              ],
            ),
          ),
        ),
        //backgroundColor: Colors.green,
        actions: buildActionButtons(),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
              minWidth: 100, maxWidth: 1000, minHeight: 400),
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
              Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01)),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green))
                  : filteredKills.isEmpty
                      ? const Expanded(child: NoDataFoundWidget())
                      : Expanded(
                          flex: 9, child: buildKillEntries(filteredKills)),
            ],
          ),
        ),
      ),
      floatingActionButton:
          CustomFab(isVisible: _isFabVisible ?? ValueNotifier(false)),
    );
  }

  List<Widget> buildActionButtons() {
    final dg = S.of(context);
    return <Widget>[
      IconButton(
        onPressed: () {
          if (controller.text.isNotEmpty) controller.text = "";
          setState(() => _showSearch = !_showSearch);
        },
        icon: Icon(_showSearch ? Icons.close : Icons.search),
      ),
      IconButton(
        onPressed: () async {
          bool? needToRefresh = await Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const SettingsScreen()),
          );
          if (needToRefresh == true) {
            await refresh(_currentYear);
            if (!mounted) return;
            await showSnackBar(dg.refreshListConfirmation, context);
          }
        },
        icon: const Icon(Icons.settings),
      ),
    ];
  }

  Widget buildToolbarSearchbar() {
    final dg = S.of(context);
    return Expanded(
      child: TextField(
        autofocus: true,
        onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style:
            TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),
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

  void _handleOpenMap(List<KillEntry> kills) async {
    final delegate = S.of(context);
    if (await Connectivity()
            .checkConnectivity()
            .timeout(const Duration(seconds: 15)) ==
        ConnectivityResult.none) {
      showSnackBar(delegate.noInternetError, context);
      return;
    }

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AllMapScreen(
          kills: kills,
          searchQuery: controller.text,
        ),
      ),
    );
    setState(() {});
  }

  List<Widget> buildActionChips() {
    final dg = S.of(context);

    int selectedWildChips = wildChips.where((e) => e.isSelected).length;
    int selectedUrsachenChips = ursacheChips.where((e) => e.isSelected).length;
    int selectedVerwendungenChips =
        verwendungChips.where((e) => e.isSelected).length;
    int selectedGeschlechterChips =
        geschlechterChips.where((e) => e.isSelected).length;

    return [
      Padding(
        padding: KillListFilterChip.chipPadding,
        child: ActionChip(
            avatar: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.map_rounded,
                color: Theme.of(context).textTheme.labelLarge?.color ??
                    Colors.grey,
                size: 18,
              ),
            ),
            backgroundColor: Theme.of(context).splashColor.withOpacity(0.3),
            label: Text(dg.map),
            onPressed: () => _handleOpenMap(page!.kills)),
      ),
      KillListFilterChip(
        chipLabel: '$_currentYear',
        modalLabel: '$_currentYear',
        iconColor: schneehaseFarbe,
        iconData: Icons.filter_list_alt,
        chips: const {},
        modalBuilder: (BuildContext context) {
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
        },
        onClose: () => setState(() {}),
      ),
      KillListFilterChip(
        chipLabel: dg.sortTitle,
        modalLabel: dg.sortTitle,
        iconColor: steinhuhnFarbe,
        iconData: Icons.sort,
        chips: const {},
        modalBuilder: (BuildContext context) {
          return KillListSortingModal(
            currentSorting: _currentSorting,
            onTap: (newSorting) {
              setState(() {
                _currentSorting = newSorting;
                _scrollToTop();
              });
            },
            sortings: _sortings,
          );
        },
        onClose: () => setState(() {}),
      ),
      KillListFilterChip(
        chips: wildChips,
        modalLabel: '$selectedWildChips ${dg.gameTypes}',
        chipLabel: dg.gameTypes,
        iconColor: wildFarbe,
        iconData: selectedWildChips == wildChips.length
            ? Icons.filter_alt
            : Icons.filter_alt_off_rounded,
        onClose: () => setState(() {}),
      ),
      KillListFilterChip(
        chips: geschlechterChips,
        modalLabel: '$selectedGeschlechterChips ${dg.sexes}',
        chipLabel: dg.sexes,
        iconColor: protokollFarbe,
        iconData: selectedGeschlechterChips == geschlechterChips.length
            ? Icons.filter_alt
            : Icons.filter_alt_off_rounded,
        onClose: () => setState(() {}),
      ),
      KillListFilterChip(
        chips: ursacheChips,
        modalLabel: '$selectedUrsachenChips ${dg.causes}',
        chipLabel: dg.causes,
        iconColor: hegeabschussFarbe,
        iconData: selectedGeschlechterChips == geschlechterChips.length
            ? Icons.filter_alt
            : Icons.filter_alt_off_rounded,
        onClose: () => setState(() {}),
      ),
      KillListFilterChip(
        chips: verwendungChips,
        modalLabel: '$selectedVerwendungenChips ${dg.usages}',
        chipLabel: dg.usages,
        iconColor: nichtBekanntFarbe,
        iconData: selectedVerwendungenChips == verwendungChips.length
            ? Icons.filter_alt
            : Icons.filter_alt_off_rounded,
        onClose: () => setState(() {}),
      ),
      Padding(
        padding: KillListFilterChip.chipPadding,
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
          onPressed: () => showDialog(
            context: context,
            builder: (context) => KillListExport(
              page: page,
              filteredKills: filteredKills,
            ),
          ),
        ),
      ),
    ];
  }

  Widget buildKillEntries(List<KillEntry> kills) {
    final showPerson = Provider.of<PrefProvider>(context).showPerson;
    final betaMode = Provider.of<PrefProvider>(context).betaMode;

    return RefreshIndicator(
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
              if (index == 0) {
                return KillListProgressBar(
                    showing: kills.length, total: page!.kills.length);
              }

              KillEntry k = kills.elementAt(index - 1);
              return KillListEntry(
                key: Key(k.key),
                kill: k,
                initiallyExpanded:
                    newKills.isEmpty ? false : newKills.contains(k),
                showPerson: showPerson,
                showEdit: betaMode,
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
                  onPressed: () =>
                      Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => const AddKillScreen(),
                    fullscreenDialog: true,
                  )),
                  backgroundColor:
                      Theme.of(context).textTheme.displayLarge!.color,
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
