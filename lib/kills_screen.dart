import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/add_kill_screen.dart';
import 'package:jagdverband_scraper/all_map_screen.dart';
import 'package:jagdverband_scraper/credentials_screen.dart';
import 'package:jagdverband_scraper/map_screen.dart';
import 'package:jagdverband_scraper/utils/database_methods.dart';
import 'package:jagdverband_scraper/models/kill_page.dart';
import 'package:jagdverband_scraper/utils/request_methods.dart';
import 'package:jagdverband_scraper/settings_screen.dart';
import 'package:jagdverband_scraper/utils/utils.dart';
import 'package:jagdverband_scraper/widgets/chip_selector_modal.dart';
import 'package:jagdverband_scraper/models/filter_chip_data.dart';
import 'package:jagdverband_scraper/widgets/no_data_found.dart';
import 'package:jagdverband_scraper/widgets/value_selector_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'models/kill_entry.dart';
import 'package:intl/intl.dart';

import 'models/sorting.dart';

class KillsScreen extends StatefulWidget {
  const KillsScreen({Key? key}) : super(key: key);

  @override
  State<KillsScreen> createState() => _KillsScreenState();
}

class _KillsScreenState extends State<KillsScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  bool _isLoading = true;
  int _currentYear = 2022;
  late DateTime _lastRefresh;
  late Sorting _currentSorting;
  final List<Sorting> _sortings = Sorting.generateDefault();

  KillPage? page;
  List<KillEntry> filteredKills = [];
  List<KillEntry> newKills = [];

  List<FilterChipData> wildChips = [];
  List<FilterChipData> ursacheChips = [];
  List<FilterChipData> verwendungChips = [];

  @override
  void initState() {
    super.initState();
    _currentSorting =
        _sortings.firstWhere((element) => element.sortType == SortType.datum);
    _lastRefresh = DateTime.now().subtract(
        const Duration(seconds: 60)); // first refresh can happen instantly
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      readFromDb(_currentYear);
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

    super.dispose();
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
              .contains(k.verwendung)) {
        filtered.add(k);
      }
    }

    return filtered;
  }

  Future<void> readFromDb(int year) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    // TODO try login first and otherwise make popup saying logout to fix creds
    KillPage? p;

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
          p = KillPage.fromList(
              kills.first['revier'] as String, year, killList);
          page = p;
          wildChips = p!.wildarten;
          ursacheChips = p!.ursachen;
          verwendungChips = p!.verwendungen;
        } catch (e) {
          print('Error parsing KillPage: ${e.toString()}');
        }
      });
    } catch (e) {
      print('Database exception ${e.toString()}');
    }

    if (p == null) {
      await refresh(year);
    } else {
      refresh(year);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> refresh(int year) async {
    if (await Connectivity()
            .checkConnectivity()
            .timeout(const Duration(seconds: 15)) ==
        ConnectivityResult.none) {
      showSnackBar('Kein Internet!', context);
      return;
    }

    print(
        'Time since last refresh: ${DateTime.now().difference(_lastRefresh).inSeconds}');
    if (DateTime.now().difference(_lastRefresh).inSeconds < 60 &&
        year == _currentYear) {
      return;
    }
    // If last refresh was more than 60 seconds ago we can query again

    print('Refreshing again cooldown is over');
    // Do not await since this should happen in the background
    await RequestMethods.getPage(year).then((page) async {
      if (!mounted) return;
      if (page == null) {
        await showAlertDialog(
          title: 'Fehler',
          description: 'Deine Anmeldedaten sind nicht mehr gültig!',
          yesOption: 'Ok',
          noOption: '',
          onYes: () {},
          icon: Icons.error,
          context: context,
        );

        deletePrefs();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const CredentialsScreen()));
      } else {
        if (this.page != page) {
          if (this.page != null &&
              this.page!.jahr == year &&
              this.page!.kills.isNotEmpty &&
              page.kills.isNotEmpty) {
            newKills = page.kills.where((k) {
              return !this.page!.kills.contains(k);
            }).toList();

            showAlertDialog(
              title: ' Neue Abschüsse',
              description:
                  'Es wurden ${newKills.length} neue Abschüsse gefunden!',
              yesOption: '',
              noOption: 'Schließen',
              onYes: () {},
              icon: Icons.fiber_new_rounded,
              context: context,
            );

            // showSnackBar(
            //     '${newKills.length} neue Abschüsse gefunden!', context);
            print('Changes found!');
          }

          this.page = page;
          wildChips = page.wildarten;
          ursacheChips = page.ursachen;
          verwendungChips = page.verwendungen;
          setState(() {});
          print('Using HTTP page');
        } else {
          print('No changes found');
        }
      }
      _lastRefresh = DateTime.now();
    }).timeout(const Duration(seconds: 15), onTimeout: () {
      _lastRefresh = DateTime.now().subtract(const Duration(
          seconds: 30)); // Can refresh after 30 seconds since error occured
      if (!mounted) return;
      showSnackBar('Fehler: Abschüsse konnten nicht geladen werden!', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (page == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    }

    Size size = MediaQuery.of(context).size;

    filteredKills = chipFilter(page!.kills);

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
      appBar: AppBar(
        //backgroundColor: rehwildFarbe,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.headline1!.color,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        title: _showSearch
            ? buildToolbarSearchbar()
            : InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllMapScreen(page: page!))),
                child: Row(
                  children: [
                    const Icon(Icons.map_rounded),
                    const SizedBox(width: 4),
                    Text(page == null ? 'Revier' : page!.revierName),
                  ],
                )),
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
              // Theme(
              //   data: Theme.of(context)
              //       .copyWith(dividerColor: Colors.transparent),
              //   child: ExpansionTile(
              //     childrenPadding: const EdgeInsets.all(0),
              //     title: buildSearchbar(),
              //     initiallyExpanded: true,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.only(
              //           left: size.width * 0.02,
              //           right: size.width * 0.02,
              //           bottom: size.height * 0.005,
              //           top: size.height * 0.0025,
              //         ),
              //         child: Wrap(
              //           alignment: WrapAlignment.spaceEvenly,
              //           children: buildActionChips(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                //scrollDirection: Axis.horizontal,
                children: buildActionChips(),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
              ),
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
    );
  }

  bool _showSearch = false;

  List<Widget> buildActionButtons() {
    return <Widget>[
      // TODO ENABLE WHEN IMPLEMENTED
      // IconButton(
      //   onPressed: () {
      //     Navigator.of(context).push(CupertinoPageRoute(
      //       builder: (context) => const AddKillScreen(),
      //       fullscreenDialog: true,
      //     ));
      //   },
      //   icon: const Icon(Icons.add_box_rounded),
      // ),
      IconButton(
          onPressed: () {
            if (controller.text.isNotEmpty) controller.text = "";
            setState(() => _showSearch = !_showSearch);
          },
          icon: Icon(_showSearch ? Icons.close : Icons.search)),
      IconButton(
        onPressed: () => Navigator.of(context)
            .push(CupertinoPageRoute(
                builder: (context) => const SettingsScreen()))
            .then((_) => setState(() {})),
        icon: const Icon(Icons.settings),
      ),
    ];
  }

  Widget buildToolbarSearchbar() {
    return Center(
      child: TextField(
        autofocus: true,
        onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: '${filteredKills.length} Abschüsse filtern',
        ),
        onChanged: (query) => setState(() {}),
      ),
    );
  }

  Widget buildSearchbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        autofocus: false,
        onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: const TextStyle(color: rehwildFarbe),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: controller.text.isEmpty
                ? Container()
                : const Icon(Icons.close, color: rehwildFarbe),
            onPressed: () => controller.text.isEmpty
                ? {}
                : setState(() => controller.text = ""),
          ),
          //enabledBorder: InputBorder.none,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: rehwildFarbe, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: rehwildFarbe, width: 1),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: rehwildFarbe,
          ),
          prefixIconColor: rehwildFarbe,
          hintText: '${page!.kills.length} Abschüsse filtern',
        ),
        onChanged: (query) => setState(() {}),
      ),
    );
  }

  List<Widget> buildActionChips() {
    ShapeBorder modalShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
    EdgeInsets chipPadding =
        const EdgeInsets.symmetric(horizontal: 5, vertical: 0);

    int selectedWildChips = wildChips.where((e) => e.isSelected).length;
    int selectedUrsachenChips = ursacheChips.where((e) => e.isSelected).length;
    int selectedVerwendungenChips =
        verwendungChips.where((e) => e.isSelected).length;

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
                      items: List.generate(
                        DateTime.now().year - 2000 + 1,
                        (index) => index + 2000,
                      ).reversed.toList(),
                      selectedItem: _currentYear,
                      onSelect: (selectedYear) async {
                        if (selectedYear != _currentYear) {
                          await readFromDb(selectedYear)
                              .then((value) => setState(() {}));
                          _currentYear = selectedYear;
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
            label: Text('$selectedWildChips Wildarten'),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return ChipSelectorModal(
                        title: 'Wildarten', chips: wildChips);
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
            label: Text('$selectedUrsachenChips Ursachen'),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return ChipSelectorModal(
                        title: 'Ursachen', chips: ursacheChips);
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
            label: Text('$selectedVerwendungenChips Verwendungen'),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return ChipSelectorModal(
                        title: 'Verwendungen', chips: verwendungChips);
                  });
              if (mounted) setState(() {});
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
            label: const Text('Sortierung'),
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
    ];
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
                  fontWeight: s == _currentSorting
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: s == _currentSorting
                      ? Colors.green
                      : Theme.of(context).textTheme.headline1!.color,
                ),
              ),
              const SizedBox(width: 12),
              s.sortType == SortType.kein || s != _currentSorting
                  ? Container()
                  : Icon(
                      s.ascending
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
            'Zeige ${kills.length} von ${page!.kills.length}',
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
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          SharedPreferences prefs = snapshot.data!;
          bool showPerson = prefs.getBool('showPerson') ?? false;
          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            child: Scrollbar(
              controller: _scrollController,
              interactive: true,
              child: ListView.builder(
                controller: _scrollController,
                cacheExtent: 1000, // pixels both directions
                //separatorBuilder: (context, index) => Divider(),
                itemCount: kills.length + 1,
                itemBuilder: ((context, index) {
                  if (index == 0) return buildProgressBar(kills);

                  KillEntry k = kills.elementAt(index - 1);
                  return KillListEntry(
                    key: Key(k.key),
                    kill: k,
                    initiallyExpanded:
                        newKills.isEmpty ? false : newKills.contains(k),
                    showPerson: showPerson,
                    revier: page!.revierName,
                  );
                }),
              ),
            ),
            onRefresh: () async => await refresh(_currentYear),
          );
        }

        return const Center(
            child: CircularProgressIndicator(color: rehwildFarbe));
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class KillListEntry extends StatefulWidget {
  final KillEntry kill;
  final bool showPerson;
  final String revier;
  final bool initiallyExpanded;

  const KillListEntry({
    Key? key,
    required this.kill,
    required this.showPerson,
    this.revier = "",
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  State<KillListEntry> createState() => KillListEntryState();
}

class KillListEntryState extends State<KillListEntry> {
  final GlobalKey expansionTileKey = GlobalKey();

  void _scrollToSelectedContent({required GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    KillEntry k = widget.kill;

    String alter = k.alter.isNotEmpty && k.alterw.isEmpty
        ? k.alter
        : k.alter.isEmpty && k.alterw.isNotEmpty
            ? k.alterw
            : k.alter.isNotEmpty && k.alterw.isNotEmpty
                ? '${k.alter} - ${k.alterw}'
                : "";
    alter = alter.trim();

    Size size = MediaQuery.of(context).size;

    String date = DateFormat('dd.MM.yy').format(k.datetime);
    String time = DateFormat('kk:mm').format(k.datetime);

    List<Widget> iconButtons = [
      IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: k.toString()));
          showSnackBar('In Zwischenablage kopiert!', context);
        },
        icon: const Icon(Icons.copy_rounded, color: primaryColor),
      ),
      IconButton(
        onPressed: () async {
          final box =
              context.findRenderObject() as RenderBox?; // Needed for iPad

          await Share.share(
            'Sieh dir diesen Abschuss in ${widget.revier} an!\n${k.toString()}',
            subject: 'Sieh dir diesen Abschuss in ${widget.revier} an!',
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          );
        },
        icon: const Icon(Icons.share, color: primaryColor),
      ),
    ];

    if (k.gpsLat != null && k.gpsLon != null) {
      iconButtons.add(
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MapScreen(kill: k),
              ),
            );
          },
          icon: const Icon(
            Icons.map_rounded,
            color: primaryColor,
          ),
        ),
      );
    }

    return Container(
      key: expansionTileKey,
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.005),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        color: k.color.withOpacity(0.8),
        elevation: 7,
        clipBehavior: Clip.hardEdge,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (exp) {
              if (exp) {
                // Checking expansion status
                _scrollToSelectedContent(expansionTileKey: expansionTileKey);
              }
            },
            iconColor: primaryColor,
            collapsedIconColor: primaryColor,
            initiallyExpanded: widget.initiallyExpanded,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  k.icon,
                  color: primaryColor,
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Icon(k.ursache == 'erlegt' ? Icons.check : Icons.close),
            //     // Icon(
            //     //   k.verwendung == 'Eigengebrauch'
            //     //       ? Icons.person
            //     //       : k.verwendung == 'verkauf'
            //     //           ? Icons.euro
            //     //           : Icons.close,
            //     // ),
            //   ],
            // ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    k.wildart,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    k.oertlichkeit,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(k.geschlecht, style: TextStyle(color: secondaryColor)),
                Text(
                  date,
                  style: TextStyle(color: secondaryColor),
                ),
              ],
            ),
            // expandedAlignment: Alignment.topLeft,

            childrenPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              //left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.01,
              bottom: 10,
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ExpandedChildKillEntry(
                icon: Icons.numbers_rounded,
                title: 'Nummer',
                value: k.nummer.toString(),
              ),
              ExpandedChildKillEntry(
                icon: Icons.map_rounded,
                title: 'Gebiet',
                value: k.hegeinGebietRevierteil,
              ),
              time == '00:00' || time == '24:00'
                  ? Container()
                  : ExpandedChildKillEntry(
                      icon: Icons.access_time_outlined,
                      title: 'Uhrzeit',
                      value: time,
                    ),
              ExpandedChildKillEntry(
                icon: Icons.calendar_month,
                title: 'Alter',
                value: alter,
              ),
              ExpandedChildKillEntry(
                icon: Icons.scale,
                title: 'Gewicht',
                value: k.gewicht == 0 ? null : '${k.gewicht} kg',
              ),
              widget.showPerson &&
                      k.ursache != 'Fallwild' &&
                      k.ursache != 'Straßenunfall' &&
                      k.ursache != 'vom Zug überfahren'
                  ? ExpandedChildKillEntry(
                      icon: Icons.person,
                      title: 'Erleger',
                      value: k.erleger,
                    )
                  : Container(),
              widget.showPerson
                  ? ExpandedChildKillEntry(
                      icon: Icons.person_add_alt_1,
                      title: 'Begleiter',
                      value: k.begleiter,
                    )
                  : Container(),
              ExpandedChildKillEntry(
                icon: Icons.data_usage,
                title: 'Verwendung',
                value: k.verwendung,
              ),
              ExpandedChildKillEntry(
                icon: Icons.history_edu_rounded,
                title: 'Ursprungszeichen',
                value: k.ursprungszeichen,
              ),
              k.jagdaufseher == null
                  ? Container()
                  : ExpandedChildKillEntry(
                      icon: Icons.admin_panel_settings_outlined,
                      title: k.jagdaufseher!['aufseher']!,
                      value:
                          "${k.jagdaufseher!['datum']}\n${k.jagdaufseher!['zeit']}",
                    ),
              SizedBox(width: double.infinity, height: size.height * 0.0025),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: iconButtons,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedChildKillEntry extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? value;

  const ExpandedChildKillEntry({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return value == null || value!.isEmpty || value == "null"
        ? Container()
        : ListTile(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: value));
              showSnackBar('In Zwischenablage kopiert!', context);
            },
            visualDensity: const VisualDensity(horizontal: 4, vertical: -3.5),
            textColor: secondaryColor,
            iconColor: secondaryColor,
            horizontalTitleGap: 0,
            leading: Icon(
              icon,
              size: size.height * 0.023,
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(title)),
                  ),
                  Flexible(
                    child: Text(
                      value!,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: secondaryColor,
                        fontSize: 15,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ]),
          );
  }
}
