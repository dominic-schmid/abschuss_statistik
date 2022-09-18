import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/models/constants/hunting_time.dart';
import 'package:jagdstatistik/models/filter_chip_data.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:jagdstatistik/widgets/chip_selector_modal.dart';
import 'package:jagdstatistik/widgets/hunting_time_list_entry.dart';
import 'package:jagdstatistik/widgets/no_data_found.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HuntingTimeScreen extends StatefulWidget {
  const HuntingTimeScreen({Key? key}) : super(key: key);

  @override
  State<HuntingTimeScreen> createState() => _HuntingTimeScreenState();
}

class _HuntingTimeScreenState extends State<HuntingTimeScreen> {
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  DateTime year = DateTime.now();

  List<HuntingTime> huntingTimes = [];
  List<FilterChipData> _filters = [];

  Map<String, Color> _colors = {};

  @override
  void initState() {
    super.initState();
    huntingTimes = HuntingTime.all(DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);

    // Init first start
    if (_filters.isEmpty) {
      _filters = [
        FilterChipData(label: dg.open, color: rehwildFarbe),
        FilterChipData(
            label: dg.geschlossen,
            color: rotwildFarbe,
            isSelected: false), // By default, closed filterings are hidden
      ];
    }

    bool showOpen = _filters.firstWhere((e) => e.label == dg.open).isSelected;
    bool showClosed = _filters.firstWhere((e) => e.label == dg.geschlossen).isSelected;

    List<HuntingTime> filteredList = huntingTimes
        .where((ht) => ht.open && showOpen || !ht.open && showClosed)
        .toList();

    return Scaffold(
      appBar: ChartAppBar(
        title: Text(dg.xJagdzeiten(year.year)),
        actions: [
          // IconButton(
          //   onPressed: () => showDialog(
          //     // Show custom year dialog
          //     context: context,
          //     builder: (BuildContext context) => AlertDialog(
          //       title: Text(
          //         dg.selectYear,
          //         textAlign: TextAlign.center,
          //       ),
          //       content: SizedBox(
          //         // Need to use container to add size constraint.
          //         width: size.width * 0.75,
          //         height: size.height * 0.425,
          //         child: YearPicker(
          //           initialDate: year,
          //           firstDate: DateTime(2000, 1, 1),
          //           lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
          //           selectedDate: year,
          //           onChanged: (DateTime dateTime) {
          //             // close the dialog when year is selected.
          //             Navigator.pop(context);
          //             if (dateTime.year != year.year) {
          //               setState(() {
          //                 year = dateTime;
          //                 rebuildHuntingTimes();
          //                 try {
          //                   _scrollToTop();
          //                 } catch (e) {
          //                   /* Not the end of the world, controller not attached */
          //                 }
          //               });
          //             }
          //           },
          //         ),
          //       ),
          //     ),
          //   ),
          //   icon: const Icon(Icons.edit_calendar_rounded),
          // ),
          IconButton(
            onPressed: () async {
              await showMaterialModalBottomSheet(
                context: context,
                builder: (context) =>
                    ChipSelectorModal(title: dg.filter, chips: _filters),
              );
              setState(() {});
            },
            icon: Icon(
              showOpen && showClosed
                  ? Icons.filter_alt_rounded
                  : Icons.filter_alt_off_rounded,
            ),
          ),
        ],
      ),
      body: filteredList.isEmpty
          ? const Center(child: NoDataFoundWidget())
          : ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
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

                var t = filteredList.elementAt(index);
                Color c = Colors.red;

                // Not in map, need to generate it first
                if (!_colors.containsKey(t.wildart)) {
                  // If is translatable game (-> has a color)
                  if (GameType.translate(context, t.wildart, false).isNotEmpty) {
                    c = GameType.all.firstWhere((e) => e.wildart == t.wildart).color;
                  } else {
                    c = Colors.primaries[_colors.length % Colors.primaries.length];
                  }

                  _colors.addAll({t.wildart: c});
                } else {
                  c = _colors[t.wildart]!; // Otherwise get color
                }

                return HuntingTimeListEntry(
                  key: Key('${t.wildart}-${t.geschlecht}-${t.von.year}'),
                  time: t,
                  year: year.year,
                  color: c,
                );
              }),
              itemCount: filteredList.length,
            ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 1500), curve: Curves.decelerate);
  }
}
