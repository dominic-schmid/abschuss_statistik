import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/main.dart';
import 'package:jagdverband_scraper/providers.dart';
import 'package:jagdverband_scraper/request_methods.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:jagdverband_scraper/widgets/filter_chip_data.dart';
import 'package:provider/provider.dart';

import 'models/kill_entry.dart';

class KillsScreen extends StatefulWidget {
  final String revier;
  final String passwort;

  const KillsScreen({Key? key, required this.revier, required this.passwort})
      : super(key: key);

  @override
  State<KillsScreen> createState() => _KillsScreenState();
}

class _KillsScreenState extends State<KillsScreen> {
  bool _isLoading = true;
  int _currentYear = 2022;

  List<KillEntry> kills = [];
  List<KillEntry> filteredKills = [];

  List<FilterChipData> chips = FilterChipData.all.toList();

  loadCookieAndKills() async {
    await Provider.of<CookieProvider>(context, listen: false)
        .readPrefsOrUpdate()
        .then((cookie) => RequestMethods.loadKills(
                    '5991d3756866e88e2922a3b1873ffbb3', _currentYear)
                .then((kills) {
              if (!mounted) return;
              setState(() {
                this.kills = kills;
                _isLoading = false;
              });
            }));
    // String cookie =
    //     Provider.of<CookieProvider>(context, listen: false).getCookie;
    // print('Init state found cookie $cookie');
    // await ;
  }

  @override
  void initState() {
    super.initState();
    loadCookieAndKills();
  }

  List<KillEntry> chipFilter(List<KillEntry> kills) {
    List<KillEntry> filtered = [];

    chips.forEach((element) {
      if (element.isSelected) {
        filtered.addAll(kills.where((k) => k.wildart == element.label));
      }
    });

    return filtered;
  }

  Future<void> refresh(int year) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<CookieProvider>(context, listen: false)
        .readPrefsOrUpdate()
        .then((cookie) =>
            RequestMethods.loadKills('5991d3756866e88e2922a3b1873ffbb3', year)
                .then((kills) {
              if (!mounted) return;
              setState(() {
                this.kills = kills;
                _isLoading = false;
              });
            }));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String cookie = Provider.of<CookieProvider>(context).getCookie;
    cookie = "5991d3756866e88e2922a3b1873ffbb3"; // TODO REMOVE

    filteredKills = chipFilter(kills);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              print(loadCredentialsFromPrefs());
            },
            child: const Text('324 - Terenten')), // TODO get from loaded page
        backgroundColor: Colors.green,
        actions: buildActionButtons(),
      ),
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: double.infinity,
            // child: Wrap(
            //     children: chips
            //         .map((c) => FilterChip(
            //             selectedColor: c.color.withOpacity(0.25),
            //             disabledColor: c.color.withOpacity(0.1),
            //             labelStyle: TextStyle(color: c.color),
            //             onSelected: (selected) {
            //               c.isSelected = selected;
            //             },
            //             selected: c.isSelected,
            //             label: Text(c.label)))
            //         .toList()),

            // Horizontal chip listview
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              itemBuilder: ((context, index) {
                FilterChipData chip = chips.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilterChip(
                      selectedColor: chip.color.withOpacity(0.25),
                      disabledColor: chip.color.withOpacity(0.1),
                      checkmarkColor: chip.color,
                      labelStyle: TextStyle(color: chip.color),
                      onSelected: (selected) {
                        setState(() {
                          chip.isSelected = selected;
                        });
                      },
                      selected: chip.isSelected,
                      label: Text(chip.label)),
                );
              }),
            ),
          ),
          Center(
            child: Wrap(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buildActionChips(),
            ),
          ),
          _isLoading
              ? Container()
              : filteredKills.isEmpty
                  ? Container()
                  : buildProgressBar(filteredKills),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : filteredKills.isEmpty
                  ? Expanded(child: buildNoDataFound())
                  : Expanded(flex: 9, child: buildKillEntries(filteredKills)),
        ],
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
        const EdgeInsets.symmetric(horizontal: 5, vertical: 2);
    return [
      Padding(
        padding: chipPadding,
        child: ActionChip(
            label: Text('$_currentYear'),
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return buildYearModalSheet();
                  });
              setState(() {
                print('SET tHE STATE');
              });
            }),
      ),
      Padding(
        padding: chipPadding,
        child: ActionChip(
            label: Text('${chips.where((e) => e.isSelected).length} Wildarten'),
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  shape: modalShape,
                  builder: (BuildContext context) {
                    return buildChipModalSheet();
                  });
              setState(() {
                print('SET tHE STATE');
              });
            }),
      ),
    ];
  }

  Widget buildNoDataFound() {
    return Padding(
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
    );
  }

  List<Widget> buildActionButtons() {
    return <Widget>[
      IconButton(
        onPressed: () async {
          await showAlertDialog(
              title: 'Abmelden',
              description: 'Möchtest du dich wirklich abmelden?',
              yesOption: 'Ja',
              noOption: 'Nein',
              onYes: () async {
                await deletePrefs();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyApp()));
              },
              icon: Icons.warning,
              context: context);
        },
        icon: Icon(Icons.logout),
      ),
      IconButton(
        onPressed: () async {
          print(
              'Cookie: ${Provider.of<CookieProvider>(context, listen: false).getCookie}');

          print(
              'New cookie: ${await Provider.of<CookieProvider>(context, listen: false).refreshCookie()}');
        },
        icon: Icon(Icons.http),
      ),
      IconButton(
        onPressed: () async {
          await showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              builder: (BuildContext context) {
                return buildYearModalSheet();
              });
          setState(() {
            print('SET tHE STATE');
          });
        },
        icon: Icon(Icons.access_time_filled_outlined),
      ),
      IconButton(
        onPressed: () async {
          await showModalBottomSheet(
              elevation: 2,
              enableDrag: true,
              isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              builder: (BuildContext context) {
                return buildChipModalSheet();
              });
          setState(() {
            print('SET tHE STATE');
          });
        },
        icon: Icon(Icons.filter_list_rounded),
      ),
    ];
  }

  Widget buildYearModalSheet() {
    List<Widget> buttonList = [];
    double w = MediaQuery.of(context).size.width;
    for (int i = 2022; i >= 2000; i--) {
      buttonList.add(
        MaterialButton(
          minWidth: w,
          onPressed: () {
            _currentYear = i;

            Navigator.of(context).pop();
            refresh(i);
            showSnackBar('Lade Abschüsse aus $i', context);
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
              color: i == _currentYear ? Colors.green : Colors.black,
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

  Widget buildChipModalSheet() {
    // List<MaterialButton> buttonList = [];

    // for (int i = 2022; i > 2000; i--) {
    //   buttonList.add(MaterialButton(
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //       showSnackBar('Lade $i ...', context);
    //       refresh(i);
    //     },
    //     child: Text('$i'),
    //     padding: const EdgeInsets.all(10),
    //   ));
    // }

    // Wrap(
    //     children:);
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(top: 20, left: width * 0.1, right: width * 0.1),
        child: Wrap(
          children: chips
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
      ),
    );
  }

  Widget buildProgressBar(List<KillEntry> kills) {
    double percentage = kills.length / this.kills.length;
    double horizontal = MediaQuery.of(context).size.width * 0.2;
    return Padding(
      padding: EdgeInsets.only(
        left: horizontal,
        right: horizontal,
        top: 0,
        bottom: 15,
      ),
      child: Column(
        children: [
          //#c4 > h1
          const SizedBox(height: 10),
          Text('Zeige ${kills.length} von ${this.kills.length}'),
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
      child: kills.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search),
                  SizedBox(height: 12),
                  Text('Hier gibt es nichts zu sehen...'),
                ],
              ),
            )
          : ListView.builder(
              //separatorBuilder: (context, index) => Divider(),
              itemCount: kills.length,
              itemBuilder: ((context, index) {
                KillEntry k = kills.elementAt(index);
                String key = '${k.nummer}-${k.datum}';
                return KillListEntry(key: Key(key), kill: k);
              }),
            ),
      onRefresh: () async {
        await refresh(_currentYear);
        print('refreshed)');
      },
    );
  }
}

class KillListEntry extends StatefulWidget {
  final KillEntry kill;

  const KillListEntry({Key? key, required this.kill}) : super(key: key);

  @override
  State<KillListEntry> createState() => KillListEntryState();
}

class KillListEntryState extends State<KillListEntry> {
  @override
  Widget build(BuildContext context) {
    KillEntry k = widget.kill;

    // IconData id = Icons.close;
    // switch (k.ursache) {
    //   case 'erlegt':
    //     id = Icons.person;
    //     break;
    //   case 'Fallwild':
    //     id = Icons.cloudy_snowing;
    //     break;
    //   case 'Straßenunfall':
    //     id = Icons.car_crash;
    //     break;
    //   case 'Hegeabschuss':
    //     id = Icons.admin_panel_settings_outlined;
    //     break;
    // }

    String alter = k.alter.isNotEmpty && k.alterw.isEmpty
        ? k.alter
        : k.alter.isEmpty && k.alterw.isNotEmpty
            ? k.alterw
            : k.alter.isNotEmpty && k.alterw.isNotEmpty
                ? k.alter
                : k.alterw;

    return ExpansionTile(
      // trailing: Text(k.oertlichkeit),
      // iconColor: k.color,
      // collapsedIconColor: k.color,
      collapsedBackgroundColor: k.color.withOpacity(0.2),
      leading: Icon(k.icon),

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
        children: [
          Text(
            k.wildart,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k.geschlecht),
          Text('${k.datum}'),
        ],
      ),
      expandedAlignment: Alignment.topLeft,
      childrenPadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.2, bottom: 10),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${k.nummer} - ${k.oertlichkeit}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        k.alter.isEmpty ? Container() : Text(k.hegeinGebietRevierteil),
        k.zeit == '00:00' ? Container() : Text('Uhrzeit: ${k.zeit}'),
        k.alter.trim().isEmpty ? Container() : Text('Alter: ${k.alter}'),
        k.alterw.isEmpty ? Container() : Text('Alter W: ${k.alterw}'),
        k.gewicht == null ? Container() : Text('Gewicht: ${k.gewicht} kg'),
        k.begleiter.isEmpty ? Container() : Text('Begleiter: ${k.begleiter}'),
        Text('Verwendung: ${k.verwendung}'),
        k.urpsrungszeichen.isEmpty
            ? Container()
            : Text('Urpsrungszeichen: ${k.urpsrungszeichen}'),
      ],
    );
  }
}
