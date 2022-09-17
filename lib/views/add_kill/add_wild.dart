import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddWild extends StatefulWidget {
  final GlobalKey<FormState> formState;
  final TextEditingController wildartController;
  final TextEditingController geschlechtController;

  final TextEditingController alterController;
  final TextEditingController alterWController;

  final TextEditingController gewichtController;

  const AddWild({
    Key? key,
    required this.formState,
    required this.wildartController,
    required this.geschlechtController,
    required this.alterController,
    required this.alterWController,
    required this.gewichtController,
  }) : super(key: key);

  @override
  State<AddWild> createState() => _AddWildState();
}

class _AddWildState extends State<AddWild> {
  List<SelectedListItem>? _gameTypesSelect = [];

  @override
  void initState() {
    super.initState();
    _gameTypesSelect = GameType.all.map((e) {
      return SelectedListItem(name: e.wildart);
    }).toList();
    widget.wildartController.text = _gameTypesSelect!.first.name;
    widget.geschlechtController.text = GameType.all
        .map((e) {
          return e.geschlechter.first;
        })
        .toList()
        .first;
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
                textEditingController: widget.wildartController,
                title: 'Wildart',
                hint: 'Rehwild',
                validator: (_) {
                  if (_ == null || _.isEmpty) return "Pflichtfeld!";
                },
                enableModalBottomSheet: true,
                disableTyping: true,
                listItems: _gameTypesSelect,
                onSelect: (oldValue) {
                  if (oldValue != widget.wildartController.text) {
                    widget.geschlechtController.clear();
                  }
                  setState(() {});
                }),
          ),
          Flexible(
            child: AppTextField(
              onSelect: (_) {},
              enabled: widget.wildartController.text.isNotEmpty,
              textEditingController: widget.geschlechtController,
              title: 'Geschlecht',
              validator: (_) {
                if (_ == null || _.isEmpty) return "Pflichtfeld!";
              },
              hint: widget.wildartController.text.isEmpty
                  ? 'Rehbock'
                  : GameType.all
                      .firstWhere((g) => g.wildart == widget.wildartController.text)
                      .geschlechter
                      .first,
              enableModalBottomSheet: true,
              disableTyping: true,
              listItems: widget.wildartController.text.isEmpty
                  ? []
                  : GameType.all
                      .firstWhere((g) => g.wildart == widget.wildartController.text)
                      .geschlechter
                      .map((e) => SelectedListItem(name: e))
                      .toList(),
            ),
          ),
          Divider(),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AppTextField(
                    onSelect: (_) {},
                    textEditingController: widget.alterController,
                    title: 'Alter (opt)',
                    hint: '4-5',
                    enableModalBottomSheet: false,
                    enableMultiSelection: false,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: AppTextField(
                    onSelect: (_) {},
                    textEditingController: widget.alterWController,
                    title: 'Alter W (opt)',
                    hint: 'alt (6+)',
                    enableModalBottomSheet: false,
                    enableMultiSelection: false,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: AppTextField(
              onSelect: (_) {},
              textEditingController: widget.gewichtController,
              title: 'Gewicht in kg (opt)',
              hint: '14.8 kg',
              enableModalBottomSheet: false,
              enableMultiSelection: false,
              keyboardType: TextInputType.number,
              validator: (content) {
                if (content == null || content.isEmpty) {
                  return null;
                } else if (double.tryParse(content) == null) {
                  return 'Zahl konnte nicht gelesen werden!';
                } else if (double.parse(content) < 0) {
                  return 'Negative Zahlen sind nicht erlaubt!';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
