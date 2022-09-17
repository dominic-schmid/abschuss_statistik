import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/constants/cause.dart';
import 'package:jagdstatistik/models/constants/usage.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddDetails extends StatefulWidget {
  final GlobalKey<FormState> formState;

  final TextEditingController ursacheController;
  final TextEditingController verwendungController;
  const AddDetails({
    Key? key,
    required this.ursacheController,
    required this.verwendungController,
    required this.formState,
  }) : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  List<SelectedListItem>? _ursacheTypesSelect = [];
  List<SelectedListItem>? _verwendungTypesSelect = [];

  @override
  void initState() {
    super.initState();
    _ursacheTypesSelect = Cause.all.map((e) {
      return SelectedListItem(name: e.cause);
    }).toList();
    _verwendungTypesSelect = Usage.all.map((e) {
      return SelectedListItem(name: e.usage);
    }).toList();

    widget.ursacheController.text = _ursacheTypesSelect!.first.name;
    widget.verwendungController.text = _verwendungTypesSelect!.first.name;
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
              textEditingController: widget.ursacheController,
              title: 'Ursache',
              hint: 'Erlegt',
              validator: (_) {
                if (_ == null || _.isEmpty) return "Pflichtfeld!";
              },
              enableModalBottomSheet: true,
              disableTyping: true,
              listItems: _ursacheTypesSelect,
              onSelect: (_) {},
            ),
          ),
          Flexible(
            child: AppTextField(
              onSelect: (_) {},
              textEditingController: widget.verwendungController,
              title: 'Verwendung',
              hint: 'Eigengebrauch',
              validator: (_) {
                if (_ == null || _.isEmpty) return "Pflichtfeld!";
              },
              enableModalBottomSheet: true,
              disableTyping: true,
              listItems: _verwendungTypesSelect,
            ),
          ),
        ],
      ),
    );
  }
}
