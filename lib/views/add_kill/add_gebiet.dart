import 'package:flutter/material.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddGebiet extends StatefulWidget {
  final GlobalKey<FormState> formState;

  final TextEditingController hegeringController;
  final TextEditingController ursprungszeichenController;
  final TextEditingController oertlichkeitController;
  const AddGebiet({
    Key? key,
    required this.hegeringController,
    required this.ursprungszeichenController,
    required this.oertlichkeitController,
    required this.formState,
  }) : super(key: key);

  @override
  State<AddGebiet> createState() => _AddGebietState();
}

class _AddGebietState extends State<AddGebiet> {
  List<SelectedListItem>? _hegeringTypesSelect = [];
  List<SelectedListItem>? _ursprungszeichenTypesSelect = [];
  List<SelectedListItem>? _oertlichkeitTypesSelect = [];

  @override
  void initState() {
    super.initState();
    _hegeringTypesSelect = [SelectedListItem(name: 'Wald 1')];
    _ursprungszeichenTypesSelect = [SelectedListItem(name: 'Wald 1')];
    _oertlichkeitTypesSelect = [SelectedListItem(name: 'Wald 1')];
  }

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.5),
              decoration: BoxDecoration(
                color: rehwildFarbe,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () {
                  showSnackBar('add', context);
                  // TODO: navigate to google map and place marker, then return LatLng from the route or null
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map),
                    const SizedBox(width: 10),
                    Text('Ort auf Karte wählen'),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
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
