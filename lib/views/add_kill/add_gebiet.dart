import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/database_methods.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/add_kill/add_map_coordinates.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddGebiet extends StatefulWidget {
  final GlobalKey<FormState> formState;

  final TextEditingController hegeringController;
  final TextEditingController ursprungszeichenController;
  final TextEditingController oertlichkeitController;
  final LatLng initialLatLng;
  final Function(LatLng) onLatLngSelect;
  final bool isLatLngPreset;

  const AddGebiet({
    Key? key,
    required this.hegeringController,
    required this.ursprungszeichenController,
    required this.oertlichkeitController,
    required this.formState,
    required this.initialLatLng,
    required this.onLatLngSelect,
    this.isLatLngPreset = false,
  }) : super(key: key);

  @override
  State<AddGebiet> createState() => _AddGebietState();
}

class _AddGebietState extends State<AddGebiet> {
  List<SelectedListItem>? _hegeringTypesSelect = [];
  List<SelectedListItem>? _ursprungszeichenTypesSelect = [];
  List<SelectedListItem>? _oertlichkeitTypesSelect = [];

  LatLng? _latLng;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    var database = await SqliteDB().db;

    List<Map<String, Object?>> oertlichkeitenRows = await database.transaction(
      (txn) async => await txn.rawQuery('''
        SELECT
        trim(oertlichkeit) as oertlichkeit,
        count(*) as anzahl,
        avg(gpsLat) as gpsLat,
        avg(gpsLon) as gpsLon
        FROM Kill
        WHERE gpsLat IS NOT NULL AND gpsLon IS NOT NULL
        AND oertlichkeit IS NOT NULL AND oertlichkeit <> ""
        GROUP BY trim(oertlichkeit)
       '''),
    );

    _oertlichkeitTypesSelect = oertlichkeitenRows
        .map(
          (r) => SelectorHelper(
            r['oertlichkeit'] as String,
            r['anzahl'] as int,
            LatLng(
              r['gpsLat'] as double,
              r['gpsLon'] as double,
            ),
          ),
        )
        .map(
          (e) => SelectedListItem(name: e.name, value: e.value),
        ) //SelectedListItem(name: "${e.name} (${e.amount})", value: e.value))
        .toList();

    // -------------

    List<Map<String, Object?>> gebietRows = await database.transaction(
      (txn) async => await txn.rawQuery('''
        SELECT
        trim(hegeinGebietRevierteil) as gebiet,
        count(*) as anzahl
        FROM Kill
        WHERE hegeinGebietRevierteil IS NOT NULL ANd hegeinGebietRevierteil <> ""
        GROUP BY trim(hegeinGebietRevierteil)
       '''),
    );

    _hegeringTypesSelect = gebietRows
        .map(
          (r) => SelectorHelper(
            r['gebiet'] as String,
            r['anzahl'] as int,
            null,
          ),
        )
        .map((e) => SelectedListItem(name: e.name, value: e.value))
        .toList();

    // -------------

    List<Map<String, Object?>> ursprungszeichenRows = await database.transaction(
      (txn) async => await txn.rawQuery('''
        SELECT
        trim(ursprungszeichen) as ursprungszeichen,
        count(*) as anzahl
        FROM Kill
        WHERE ursprungszeichen IS NOT NULL AND ursprungszeichen <> ""
        GROUP BY trim(ursprungszeichen)
       '''),
    );

    _ursprungszeichenTypesSelect = ursprungszeichenRows
        .map(
          (r) =>
              SelectorHelper(r['ursprungszeichen'] as String, r['anzahl'] as int, null),
        )
        .map((e) => SelectedListItem(name: e.name, value: e.value))
        .toList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);

    return _isLoading
        ? const Center(child: CircularProgressIndicator(color: rehwildFarbe))
        : Form(
            key: widget.formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AppTextField(
                    onSelect: (_) {
                      setState(() {
                        _latLng = _oertlichkeitTypesSelect!
                            .firstWhere((element) => element.isSelected ?? false)
                            .value as LatLng;
                      });
                    },
                    textEditingController: widget.oertlichkeitController,
                    title: dg.sortPlace,
                    validator: (_) {
                      if (_ == null || _.isEmpty) return dg.pflichtfeld;
                    },
                    hint: 'Musterwald',
                    enableModalBottomSheet: true,
                    disableTyping: false,
                    listItems: _oertlichkeitTypesSelect,
                  ),
                ),
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      LatLng? newLatLng = await Navigator.of(context).push(
                        MaterialPageRoute<LatLng>(
                          builder: (context) => AddMapCoordsScreen(
                            initCoords: _latLng ?? widget.initialLatLng,
                            zoom: _latLng == null && !widget.isLatLngPreset ? 12 : 15,
                          ),
                        ), // Bolzano default
                      );
                      if (newLatLng != null) {
                        setState(() {
                          _latLng = newLatLng; // don't need this except for icon below
                        });
                        widget.onLatLngSelect(newLatLng);
                      }
                    },
                    icon: Icon(_latLng == null && !widget.isLatLngPreset
                        ? Icons.map_rounded
                        : Icons.check_rounded),
                    label: Text(dg.selectCoordinates),
                  ),
                ),
                //Divider(height: size.height * 0.05),
                const Divider(),
                Flexible(
                  child: AppTextField(
                    textEditingController: widget.hegeringController,
                    title: dg.area,
                    hint: dg.area,
                    enableModalBottomSheet: true,
                    disableTyping: false,
                    listItems: _hegeringTypesSelect,
                    onSelect: (_) {},
                  ),
                ),
                Flexible(
                  child: AppTextField(
                    textEditingController: widget.ursprungszeichenController,
                    title: dg.signOfOrigin,
                    hint: dg.signOfOrigin,
                    enableModalBottomSheet: true,
                    disableTyping: false,
                    listItems: _ursprungszeichenTypesSelect,
                    onSelect: (_) {},
                  ),
                ),
                const Divider(),
              ],
            ),
          );
  }
}

class SelectorHelper {
  final String name;
  final int amount;
  final dynamic value;

  const SelectorHelper(this.name, this.amount, this.value);
}
