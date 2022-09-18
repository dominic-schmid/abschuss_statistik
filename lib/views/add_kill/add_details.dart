import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/cause.dart';
import 'package:jagdstatistik/models/constants/usage.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddDetails extends StatefulWidget {
  final GlobalKey<FormState> formState;

  final TextEditingController ursacheController;
  final TextEditingController verwendungController;

  final List<SelectedListItem> ursacheTypesSelect;
  final List<SelectedListItem> verwendungTypesSelect;
  const AddDetails({
    Key? key,
    required this.ursacheController,
    required this.verwendungController,
    required this.formState,
    required this.ursacheTypesSelect,
    required this.verwendungTypesSelect,
  }) : super(key: key);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  // List<SelectedListItem>? _ursacheTypesSelect = [];
  // List<SelectedListItem>? _verwendungTypesSelect = [];

  @override
  void initState() {
    super.initState();
    widget.ursacheController.text = widget.ursacheTypesSelect.first.name;
    widget.verwendungController.text = widget.verwendungTypesSelect.first.name;
    widget.ursacheTypesSelect.first.isSelected = true;
    widget.verwendungTypesSelect.first.isSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
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
        ],
      ),
    );
  }
}
