import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/hunting_time.dart';
import 'package:jagdstatistik/utils/utils.dart';

class HuntingTimeListEntry extends StatelessWidget {
  final HuntingTime time;
  final int year;
  final Color color;

  const HuntingTimeListEntry({
    Key? key,
    required this.time,
    required this.year,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);

    DateFormat df = DateFormat.MMMMd();
    DateFormat dfNxt = DateFormat.yMMMMd();

    bool isOpen =
        DateTime.now().isAfter(time.von) && DateTime.now().isBefore(time.bis);

    double progress = time.von.difference(DateTime.now()).inDays.toDouble() /
        time.von.difference(time.bis).inDays.toDouble();

    return Container(
      key: key,
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.005),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).textTheme.displayLarge!.color ?? Colors.red,
            style: isOpen ? BorderStyle.solid : BorderStyle.none,
            width: 3.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        color: color.withOpacity(0.8),
        elevation: 7,
        clipBehavior: Clip.hardEdge,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.075, vertical: size.height * 0.0075),
            iconColor: primaryColor,
            onTap: () {
              showSnackBar(isOpen ? dg.open : dg.geschlossen, context);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: time.geschlecht.isEmpty
                  ? [
                      Flexible(
                        child: Text(
                          time.translateWildart(context),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ]
                  : [
                      Flexible(
                        child: Text(
                          time.translateGeschlecht(context),
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
                          time.translateWildart(context),
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
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        time.von.year == year
                            ? df.format(time.von)
                            : dfNxt.format(time.von),
                        style: TextStyle(
                          color: secondaryColor,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        time.bis.year == year
                            ? df.format(time.bis)
                            : dfNxt.format(time.bis),
                        style: TextStyle(
                          color: secondaryColor,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
                time.note == null
                    ? Container()
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: Text(
                          time.note!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryColor,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                isOpen
                    ? Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: secondaryColor,
                          color: primaryColor,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
