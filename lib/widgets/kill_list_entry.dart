import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../map_screen.dart';
import '../models/kill_entry.dart';
import '../utils/utils.dart';
import 'expanded_child_kill_entry.dart';

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
        Scrollable.ensureVisible(keyContext, duration: const Duration(milliseconds: 200));
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
          final box = context.findRenderObject() as RenderBox?; // Needed for iPad

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
          onPressed: () async {
            if (await Connectivity()
                    .checkConnectivity()
                    .timeout(const Duration(seconds: 15)) ==
                ConnectivityResult.none) {
              showSnackBar('Kein Internet!', context);
              return;
            }
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
                      value: "${k.jagdaufseher!['datum']}\n${k.jagdaufseher!['zeit']}",
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
