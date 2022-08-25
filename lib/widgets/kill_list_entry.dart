import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/cause.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/models/constants/usage.dart';
import 'package:share_plus/share_plus.dart';

import '../views/map_screen.dart';
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
    final dg = S.of(context);
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
          Clipboard.setData(ClipboardData(text: k.localizedToString(context)));
          showSnackBar(dg.copiedToClipboardSnackbar, context);
        },
        icon: const Icon(Icons.copy_rounded, color: primaryColor),
      ),
      IconButton(
        onPressed: () async {
          final box = context.findRenderObject() as RenderBox?; // Needed for iPad

          await Share.share(
            dg.checkOutThisKillXY(widget.revier, k.localizedToString(context)),
            subject: dg.checkOutThisKillXY(widget.revier, ""),
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
              showSnackBar(dg.noInternetError, context);
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
                    GameType.translate(context, k.wildart),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      overflow: TextOverflow.fade,
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
                Flexible(
                  child: Text(
                    GameType.translateGeschlecht(context, k.geschlecht),
                    style: TextStyle(
                      color: secondaryColor,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    date,
                    style: TextStyle(color: secondaryColor),
                  ),
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
                title: dg.number,
                value: k.nummer.toString(),
              ),
              ExpandedChildKillEntry(
                icon: Icons.map_rounded,
                title: dg.area,
                value: k.hegeinGebietRevierteil,
              ),
              time == '00:00' || time == '24:00'
                  ? Container()
                  : ExpandedChildKillEntry(
                      icon: Icons.access_time_outlined,
                      title: dg.time,
                      value: time,
                    ),
              ExpandedChildKillEntry(
                icon: Icons.calendar_month,
                title: dg.age,
                value:
                    alter, // TODO CHECK IF REALLY TRANSLATABLE translateValue(context, alter),
              ),
              ExpandedChildKillEntry(
                icon: Icons.scale,
                title: dg.weight,
                value: k.gewicht == 0 ? null : '${k.gewicht} kg',
              ),
              widget.showPerson &&
                      k.ursache != 'Fallwild' &&
                      k.ursache != 'Straßenunfall' &&
                      k.ursache != 'vom Zug überfahren'
                  ? ExpandedChildKillEntry(
                      icon: Icons.person,
                      title: dg.killer,
                      value: k.erleger,
                    )
                  : Container(),
              widget.showPerson
                  ? ExpandedChildKillEntry(
                      icon: Icons.person_add_alt_1,
                      title: dg.companion,
                      value: k.begleiter,
                    )
                  : Container(),
              ExpandedChildKillEntry(
                icon: Icons.data_usage,
                title: dg.sortCause,
                value: Cause.translate(context, k.ursache),
              ),
              ExpandedChildKillEntry(
                icon: Icons.data_usage,
                title: dg.usage,
                value: Usage.translate(context, k.verwendung),
              ),
              ExpandedChildKillEntry(
                icon: Icons.history_edu_rounded,
                title: dg.signOfOrigin,
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
