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

  List<KillEntry> kills = [];

  List<FilterChipData> chips = FilterChipData.all.toList();

  loadCookieAndKills() async {
    await Provider.of<CookieProvider>(context, listen: false)
        .readPrefsOrUpdate()
        .then((cookie) =>
            RequestMethods.loadKills('5991d3756866e88e2922a3b1873ffbb3')
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

  // Well, she's delighted now! She got a VW Golf from Germany on Tuesday. Quite an expensive car to pick if you ask me but she really had her mind made up about that..

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

  @override
  Widget build(BuildContext context) {
    String cookie = Provider.of<CookieProvider>(context).getCookie;
    cookie = "5991d3756866e88e2922a3b1873ffbb3"; // TODO REMOVE

    List<KillEntry> filteredKills = chipFilter(kills);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              print(loadCredentialsFromPrefs());
            },
            child: const Text('324 - Terenten')), // TODO get from loaded page
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              deletePrefs();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyApp()));
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
        ],
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
          // ListTile(
          //   leading: Text(
          //     '5',
          //     style: TextStyle(fontSize: 24),
          //   ),
          //   title: Text('Wildart'),
          // ),
          _isLoading ? Container() : buildProgressBar(filteredKills),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : Expanded(flex: 9, child: buildKillEntries(filteredKills)),
        ],
      ),
    );
  }

  Widget buildProgressBar(List<KillEntry> kills) {
    double percentage = kills.length / this.kills.length;
    double horizontal = MediaQuery.of(context).size.width * 0.3;
    return Padding(
      padding: EdgeInsets.only(
        left: horizontal,
        right: horizontal,
        top: 0,
        bottom: 15,
      ),
      child: Column(
        children: [
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
    if (kills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search),
            SizedBox(height: 12),
            Text('Hier gibt es nichts zu sehen...'),
          ],
        ),
      );
    }
    return ListView.builder(
      //separatorBuilder: (context, index) => Divider(),
      itemCount: kills.length,
      itemBuilder: ((context, index) {
        KillEntry k = kills.elementAt(index);
        String key = '${k.nummer}-${k.datum}';
        return KillListEntry(key: Key(key), kill: k);
      }),
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
