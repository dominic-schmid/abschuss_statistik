import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagdstatistik/generated/l10n.dart';
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

  const AddGebiet({
    Key? key,
    required this.hegeringController,
    required this.ursprungszeichenController,
    required this.oertlichkeitController,
    required this.formState,
    required this.initialLatLng,
    required this.onLatLngSelect,
  }) : super(key: key);

  @override
  State<AddGebiet> createState() => _AddGebietState();
}

class _AddGebietState extends State<AddGebiet> {
  List<SelectedListItem>? _hegeringTypesSelect = [];
  List<SelectedListItem>? _ursprungszeichenTypesSelect = [];
  List<SelectedListItem>? _oertlichkeitTypesSelect = [];

  LatLng? _latLng;

  @override
  void initState() {
    super.initState();
    _hegeringTypesSelect = [SelectedListItem(name: 'Wald 1')];
    _ursprungszeichenTypesSelect = [SelectedListItem(name: 'Wald 1')];
    _oertlichkeitTypesSelect = [SelectedListItem(name: 'Wald 1')];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);

    return Form(
      key: widget.formState,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AppTextField(
              onSelect: (_) {},
              textEditingController: widget.oertlichkeitController,
              title: 'Örtlichkeit',
              validator: (_) {
                if (_ == null || _.isEmpty) return "Pflichtfeld!";
              },
              hint: 'Musterwald',
              enableModalBottomSheet: true,
              disableTyping: false,
              listItems: _oertlichkeitTypesSelect,
            ),
          ),
          Flexible(
            // child: Container(
            //   padding: const EdgeInsets.symmetric(vertical: 12.5),
            //   decoration: BoxDecoration(
            //     color: rehwildFarbe,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: InkWell(
            //     onTap: () {
            //       showSnackBar('add', context);
            //       // TODO: navigate to google map and place marker, then return LatLng from the route or null
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.map),
            //         const SizedBox(width: 10),
            //         Text('Ort auf Karte wählen'),
            //       ],
            //     ),
            //   ),
            // ),
            child: ElevatedButton.icon(
              onPressed: () async {
                LatLng? newLatLng = await Navigator.of(context).push(
                  MaterialPageRoute<LatLng>(
                    builder: (context) => AddMapCoordsScreen(
                      initCoords: _latLng ?? widget.initialLatLng,
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
              icon: Icon(_latLng == null ? Icons.map_rounded : Icons.check_rounded),
              label: Text(dg.selectCoordinates),
            ),
          ),
          Divider(height: size.height * 0.05),
          Flexible(
            child: AppTextField(
              textEditingController: widget.hegeringController,
              title: 'Hegering',
              hint: '',
              enableModalBottomSheet: true,
              disableTyping: false,
              listItems: _hegeringTypesSelect,
              onSelect: (_) {},
            ),
          ),
          Flexible(
            child: AppTextField(
              textEditingController: widget.ursprungszeichenController,
              title: 'Ursprungszeichen',
              hint: '',
              enableModalBottomSheet: true,
              disableTyping: false,
              listItems: _ursprungszeichenTypesSelect,
              onSelect: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
