import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/views/add_kill/add_jagdaufseher.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddDetails extends StatefulWidget {
  final GlobalKey<FormState> formState;

  final TextEditingController ursacheController;
  final TextEditingController verwendungController;

  final TextEditingController aufseherController;
  final TextEditingController aufseherDatumController;
  final TextEditingController aufseherZeitController;
  final VoidCallback onAufseherSave;

  final List<SelectedListItem> ursacheTypesSelect;
  final List<SelectedListItem> verwendungTypesSelect;

  const AddDetails({
    Key? key,
    required this.ursacheController,
    required this.verwendungController,
    required this.aufseherController,
    required this.aufseherDatumController,
    required this.aufseherZeitController,
    required this.onAufseherSave,
    required this.formState,
    required this.ursacheTypesSelect,
    required this.verwendungTypesSelect,
  }) : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  bool? _saveAufseher = false;

  @override
  void initState() {
    super.initState();
    widget.ursacheController.text = widget.ursacheTypesSelect.first.name;
    widget.verwendungController.text = widget.verwendungTypesSelect.first.name;
    widget.ursacheTypesSelect.first.isSelected = true;
    widget.verwendungTypesSelect.first.isSelected = true;
    if (widget.aufseherController.text.isNotEmpty &&
        widget.aufseherDatumController.text.isNotEmpty &&
        widget.aufseherZeitController.text.isNotEmpty) {
      _saveAufseher = true;
    }
    // if (widget.aufsehe.containsKey('aufseher') &&
    //     widget.jagdaufseher.containsKey('datum') &&
    //     widget.jagdaufseher.containsKey('zeit')) {
    //   aufseherController.text = widget.jagdaufseher['aufseher'] as String;
    //   _aufseherDt = DateTime.tryParse(
    //       "${widget.jagdaufseher['datum'] as String} ${widget.jagdaufseher['zeit'] as String}");
    //   print(
    //       'Parsed Jagdaufseher:  ${widget.jagdaufseher['aufseher'] as String} $_aufseherDt');
    // }
  }

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    Size size = MediaQuery.of(context).size;

    return Form(
      key: widget.formState,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AppTextField(
              textEditingController: widget.ursacheController,
              title: dg.sortCause,
              hint: dg.sortCause,
              validator: (_) {
                if (_ == null || _.isEmpty) return dg.pflichtfeld;
              },
              enableModalBottomSheet: true,
              disableTyping: true,
              listItems: widget.ursacheTypesSelect,
              onSelect: (_) {},
            ),
          ),
          Flexible(
            child: AppTextField(
              onSelect: (_) {},
              textEditingController: widget.verwendungController,
              title: dg.usage,
              hint: dg.usage,
              validator: (_) {
                if (_ == null || _.isEmpty) return dg.pflichtfeld;
              },
              enableModalBottomSheet: true,
              disableTyping: true,
              listItems: widget.verwendungTypesSelect,
            ),
          ),
          Divider(height: size.height * 0.05),
          Flexible(
            child: ElevatedButton.icon(
              onPressed: () async {
                _saveAufseher = await Navigator.of(context).push(
                  MaterialPageRoute<bool>(
                    builder: (context) => AddJagdaufseherScreen(
                      aufseherController: widget.aufseherController,
                      datumController: widget.aufseherDatumController,
                      zeitController: widget.aufseherZeitController,
                    ),
                  ), // Bolzano default
                );

                if (_saveAufseher == true) {
                  widget.onAufseherSave();
                }
                setState(() {});
              },
              icon: Icon(
                _saveAufseher != true
                    ? Icons.admin_panel_settings_rounded
                    : Icons.check_rounded,
              ),
              label: Text(dg.overseer),
            ),
          ),
        ],
      ),
    );
  }
}
