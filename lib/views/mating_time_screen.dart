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

class MatingTimeScreen extends StatefulWidget {
  const MatingTimeScreen({Key? key}) : super(key: key);

  @override
  State<MatingTimeScreen> createState() => _MatingTimeScreenState();
}

class _MatingTimeScreenState extends State<MatingTimeScreen> {
  List<HuntingTime> huntingTimes = [];
  List<FilterChipData> _filters = [];

  final Map<String, Color> _colors = {};

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    final dg = S.of(context);
    _colors.clear();

    huntingTimes = HuntingTime.matingTimes(DateTime.now().year, context);

    // Init first start
    if (_filters.isEmpty) {
      _filters = [
        FilterChipData(label: dg.open, color: rehwildFarbe),
        FilterChipData(label: dg.geschlossen, color: rotwildFarbe),
      ];
    }

    bool showOpen = _filters.firstWhere((e) => e.label == dg.open).isSelected;
    bool showClosed = _filters.firstWhere((e) => e.label == dg.geschlossen).isSelected;

    List<HuntingTime> filteredList = huntingTimes
        .where((ht) => ht.open && showOpen || !ht.open && showClosed)
        .toList();

    return Scaffold(
      appBar: ChartAppBar(
        title: Text(dg.paarungszeiten),
        actions: [
          IconButton(
            onPressed: () async {
              await showMaterialModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                context: context,
                builder: (context) =>
                    ChipSelectorModal(title: dg.filter, chips: _filters),
              );
              // Only refresh if changes (so as to not rebuild colors)
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
              itemBuilder: ((context, index) {
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
                  year: DateTime.now().year,
                  color: c,
                );
              }),
              itemCount: filteredList.length,
            ),
    );
  }
}
