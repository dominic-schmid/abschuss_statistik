import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/kill_entry.dart';
import 'package:jagdstatistik/utils/hunting_times.dart';
import 'package:jagdstatistik/utils/translation_helper.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';

class HuntingTimeScreen extends StatefulWidget {
  const HuntingTimeScreen({Key? key}) : super(key: key);

  @override
  State<HuntingTimeScreen> createState() => _HuntingTimeScreenState();
}

class _HuntingTimeScreenState extends State<HuntingTimeScreen> {
  DateTime year = DateTime.now();

  List<HuntingTime> huntingTimes = [];

  @override
  void initState() {
    super.initState();
    rebuildHuntingTimes();
  }

  rebuildHuntingTimes() {
    huntingTimes = HuntingTimeCollection(year.year).huntingTimes;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);

    return Scaffold(
      appBar: ChartAppBar(
        title: Text(dg.xJagdzeiten(year.year)),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              // Show custom year dialog
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                  dg.selectYear,
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  // Need to use container to add size constraint.
                  width: size.width * 0.75,
                  height: size.height * 0.425,
                  child: YearPicker(
                    initialDate: year,
                    firstDate: DateTime(2000, 1, 1),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
                    selectedDate: year,
                    onChanged: (DateTime dateTime) {
                      // close the dialog when year is selected.
                      Navigator.pop(context);
                      if (dateTime.year != year.year) {
                        setState(() {
                          year = dateTime;
                          rebuildHuntingTimes();
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            icon: const Icon(Icons.edit_calendar_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          // if (index == 0) {
          //   return Padding(
          //     padding: EdgeInsets.symmetric(
          //         horizontal: size.width * 0.05, vertical: size.height * 0.01),
          //     child: Center(
          //         child: Text(
          //       "${year.year}",
          //       style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          //     )),
          //   );
          // }

          var t = huntingTimes.elementAt(index);
          return HuntingTimeListEntry(
            key: Key('${t.wildart}-${t.geschlecht}-${t.von.year}'),
            time: t,
            year: year.year,
          );
        }),
        itemCount: huntingTimes.length,
      ),
    );
  }
}

class HuntingTimeListEntry extends StatelessWidget {
  final HuntingTime time;
  final int year;

  const HuntingTimeListEntry({Key? key, required this.time, required this.year})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);

    DateFormat df = DateFormat.MMMMd();
    DateFormat dfNxt = DateFormat.yMMMMd();

    bool isOpen = DateTime.now().isAfter(time.von) && DateTime.now().isBefore(time.bis);

    return Container(
      key: key,
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.005),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).textTheme.headline1!.color ?? Colors.red,
            style: isOpen ? BorderStyle.solid : BorderStyle.none,
            width: 4,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        color: KillEntry.getColorFromWildart(time.wildart).withOpacity(0.8),
        elevation: 7,
        clipBehavior: Clip.hardEdge,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
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
                          translateValue(context, time.wildart),
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
                          translateValue(context, time.geschlecht),
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
                          translateValue(context, time.wildart),
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
                    time.von.year == year ? df.format(time.von) : dfNxt.format(time.von),
                    style: TextStyle(
                      color: secondaryColor,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    time.bis.year == year ? df.format(time.bis) : dfNxt.format(time.bis),
                    style: TextStyle(
                      color: secondaryColor,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
