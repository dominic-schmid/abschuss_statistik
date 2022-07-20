import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/credentials_screen.dart';
import 'package:jagdverband_scraper/models/kill_page.dart';
import 'package:jagdverband_scraper/request_methods.dart';
import 'package:jagdverband_scraper/settings_screen.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:jagdverband_scraper/widgets/filter_chip_data.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'models/kill_entry.dart';
import 'package:intl/intl.dart';

import 'models/sorting.dart';

class KillsScreen extends StatefulWidget {
  const KillsScreen({Key? key}) : super(key: key);

  @override
  State<KillsScreen> createState() => _KillsScreenState();
}

class _KillsScreenState extends State<KillsScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  bool _isLoading = true;
  int _currentYear = 2022;
  late Sorting _currentSorting;
  final List<Sorting> _sortings = Sorting.generateDefault();

  KillPage? page;
  List<KillEntry> filteredKills = [];

  List<FilterChipData> wildChips = [];
  List<FilterChipData> ursacheChips = [];
  List<FilterChipData> verwendungChips = [];

  @override
  void initState() {
    super.initState();
    _currentSorting =
        _sortings.firstWhere((element) => element.sortType == SortType.datum);
    refresh(_currentYear);
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

  Future<void> refresh(int year) async {
    if (await Connectivity()
            .checkConnectivity()
            .timeout(const Duration(seconds: 15)) ==
        ConnectivityResult.none) {
      showSnackBar('Fehler: Kein Internet!', context);
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    await RequestMethods.getPage(year).then((page) {
      if (!mounted) return;
      if (page == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CredentialsScreen()));
      } else {
        this.page = page;
        wildChips = page.wildarten;
        ursacheChips = page.ursachen;
        verwendungChips = page.verwendungen;
      }
    }).timeout(const Duration(seconds: 15));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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

    // sortListBy(_currentSorting);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: rehwildFarbe,
        title: GestureDetector(
          onTap: () {
            //print(loadCredentialsFromPrefs());
          },
          child: Text(
            page!.revierName,
            //style: TextStyle(color: ThemeData.estimateBrightnessForColor(color)),
          ),
        ),
        //backgroundColor: Colors.green,
        actions: buildActionButtons(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => showSnackBar('Hinzufügen...', context),
      //   child: Icon(Icons.add),
      // ),
      body: Center(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
              minWidth: 100, maxWidth: 1000, minHeight: 400),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ExpansionTile(
                childrenPadding: const EdgeInsets.all(0),
                title: buildSearchbar(),
                initiallyExpanded: true,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.01),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: buildActionChips(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green))
                  : filteredKills.isEmpty
                      ? Expanded(child: buildNoDataFound())
                      : Expanded(
                          flex: 9, child: buildKillEntries(filteredKills)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildActionButtons() {
    return <Widget>[
      IconButton(
        onPressed: () => showSnackBar('Hinzufügen...', context),
        icon: const Icon(Icons.add_box_rounded),
      ),
      IconButton(
        onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const SettingsScreen())),
        icon: const Icon(Icons.settings),
      ),
    ];
  }

  Widget buildSearchbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        //focusNode: FocusNode(canRequestFocus: false),
        autofocus: false,
        onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: const TextStyle(color: Colors.green),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon:
                controller.text.isEmpty ? Container() : const Icon(Icons.close),
            onPressed: () => setState(() => controller.text = ""),
          ),
          // enabledBorder: InputBorder.none,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 1),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.green,
          ),
          prefixIconColor: Colors.green,
          hintText: '${page!.kills.length} Abschüsse filtern',
        ),
        onChanged: (query) => setState(() {
          //this.query = query;
        }),
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
                    return buildYearModalSheet();
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
                selectedWildChips < FilterChipData.allWild.length
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
                    return buildWildChipModalSheet();
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
                selectedUrsachenChips < FilterChipData.allUrsache.length
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
                    return buildUrsachenChipModalSheet();
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
                selectedVerwendungenChips < FilterChipData.allVerwendung.length
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
                    return buildVerwendungChipModalSheet();
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

  Widget buildYearModalSheet() {
    List<Widget> buttonList = [];
    buttonList.add(_buildHandle(context));
    double w = MediaQuery.of(context).size.width;
    for (int i = 2022; i >= 2000; i--) {
      buttonList.add(
        MaterialButton(
          minWidth: w,
          onPressed: () async {
            _currentYear = i;

            Navigator.of(context).pop();
            await refresh(i);
          },
          elevation: 2,
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.3, vertical: w * 0.02),
          child: Text(
            '$i',
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  i == _currentYear ? FontWeight.bold : FontWeight.normal,
              color: i == _currentYear
                  ? Colors.green
                  : Theme.of(context)
                      .textTheme
                      .headline1!
                      .color, // secondaryColor,
            ),
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

  Widget buildWildChipModalSheet() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: size.height * 0.01,
            left: size.width * 0.075,
            right: size.width * 0.075,
            bottom: size.height * 0.015),
        child: Column(
          children: [
            _buildHandle(context),
            const Text(
              'Wildarten',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: wildChips
                  .map((c) => StatefulBuilder(builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2),
                          child: FilterChip(
                              checkmarkColor: c.color,
                              selectedColor: c.color.withOpacity(0.25),
                              disabledColor: c.color.withOpacity(0.1),
                              labelStyle: TextStyle(color: c.color),
                              onSelected: (selected) {
                                c.isSelected = selected;
                                if (mounted) setState(() {});
                              },
                              selected: c.isSelected,
                              label: Text(c.label)),
                        );
                      }))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUrsachenChipModalSheet() {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(top: 20, left: width * 0.1, right: width * 0.1),
        child: Column(
          children: [
            _buildHandle(context),
            const Text(
              'Ursachen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: ursacheChips
                  .map((c) => StatefulBuilder(builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2),
                          child: FilterChip(
                              checkmarkColor: c.color,
                              selectedColor: c.color.withOpacity(0.25),
                              disabledColor: c.color.withOpacity(0.1),
                              labelStyle: TextStyle(color: c.color),
                              onSelected: (selected) {
                                c.isSelected = selected;
                                setState(() {});
                              },
                              selected: c.isSelected,
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(c.label),
                                  const SizedBox(width: 4),
                                  Icon(
                                    c.icon ?? Icons.question_mark_rounded,
                                    color: c.color,
                                    size: 18,
                                  ),
                                ],
                              )),
                        );
                      }))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerwendungChipModalSheet() {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(top: 20, left: width * 0.1, right: width * 0.1),
        child: Column(
          children: [
            _buildHandle(context),
            const Text(
              'Verwendung',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: verwendungChips
                  .map((c) => StatefulBuilder(builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2),
                          child: FilterChip(
                              checkmarkColor: c.color,
                              selectedColor: c.color.withOpacity(0.25),
                              disabledColor: c.color.withOpacity(0.1),
                              labelStyle: TextStyle(color: c.color),
                              onSelected: (selected) {
                                c.isSelected = selected;
                                setState(() {});
                              },
                              selected: c.isSelected,
                              label: Text(c.label)),
                        );
                      }))
                  .toList(),
            ),
          ],
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
            // TODO maybe sort here
            //sortListBy(_currentSorting);
            _scrollToTop();
          },
          elevation: 2,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1, vertical: size.height * 0.02),
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
    for (int i = 2022; i >= 2000; i--) {}
    return SingleChildScrollView(
      child: Column(
        children: buttonList,
      ),
    );
  }

  Widget buildNoDataFound() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.transparent,
                child: Image.asset('assets/shooter.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hier gibt es nichts zu sehen...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
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
            style: TextStyle(fontWeight: FontWeight.w500),
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
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      child: Scrollbar(
        controller: _scrollController,
        interactive: true,
        child: ListView.builder(
          controller: _scrollController,
          //separatorBuilder: (context, index) => Divider(),
          itemCount: kills.length + 1,
          itemBuilder: ((context, index) {
            if (index == 0) {
              return buildProgressBar(kills);
            }

            KillEntry k = kills.elementAt(index - 1);
            String key = '${k.nummer}-${k.datetime.toIso8601String()}';
            return KillListEntry(key: Key(key), kill: k);
          }),
        ),
      ),
      onRefresh: () async => await refresh(_currentYear),
    );
  }
}

class KillListEntry extends StatefulWidget {
  final KillEntry kill;
  final bool showPerson; // TODO make this a setting or something

  const KillListEntry({Key? key, required this.kill, this.showPerson = false})
      : super(key: key);

  @override
  State<KillListEntry> createState() => KillListEntryState();
}

class KillListEntryState extends State<KillListEntry> {
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

    Size size = MediaQuery.of(context).size;

    String date = DateFormat('dd.MM.yy').format(k.datetime);
    String time = DateFormat('kk:mm').format(k.datetime);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.01),
      decoration: BoxDecoration(
          color: k.color.withOpacity(0.8),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          )),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            k.icon,
            color: primaryColor,
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
              Text(
                k.wildart,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              Text(
                k.oertlichkeit,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                  fontSize: 12,
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
          expandedAlignment: Alignment.topLeft,
          childrenPadding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.2,
            bottom: 10,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fortlaufende Nummer: ${k.nummer}',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: secondaryColor),
            ),
            k.hegeinGebietRevierteil.isEmpty
                ? Container()
                : Text(k.hegeinGebietRevierteil,
                    style: TextStyle(color: secondaryColor)),
            time == '00:00' || time == '24:00'
                ? Container()
                : Text('Uhrzeit: $time',
                    style: TextStyle(color: secondaryColor)),
            k.alter.trim().isEmpty
                ? Container()
                : Text('Alter: $alter',
                    style: TextStyle(color: secondaryColor)),
            k.gewicht == null
                ? Container()
                : Text('Gewicht: ${k.gewicht} kg',
                    style: TextStyle(color: secondaryColor)),
            k.erleger.isNotEmpty && widget.showPerson
                ? Text('Erleger: ${k.erleger}',
                    style: TextStyle(color: secondaryColor))
                : Container(),
            k.begleiter.isNotEmpty && widget.showPerson
                ? Text('Begleiter: ${k.begleiter}',
                    style: TextStyle(color: secondaryColor))
                : Container(),
            Text('Verwendung: ${k.verwendung}',
                style: TextStyle(color: secondaryColor)),
            k.ursprungszeichen.isEmpty
                ? Container()
                : Text('Ursprungszeichen: ${k.ursprungszeichen}',
                    style: TextStyle(color: secondaryColor)),
            k.jagdaufseher == null
                ? Container()
                : Wrap(
                    children: [
                      Text(
                        "Gesehen von: ${k.jagdaufseher!['aufseher']} am ${k.jagdaufseher!['datum']} um ${k.jagdaufseher!['zeit']}",
                        style: TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
