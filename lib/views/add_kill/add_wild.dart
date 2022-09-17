import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddWild extends StatefulWidget {
  const AddWild({Key? key}) : super(key: key);

  @override
  State<AddWild> createState() => _AddWildState();
}

class _AddWildState extends State<AddWild> {
  // Make these public so stepper can acces selected values later
  final TextEditingController wildartController = TextEditingController();
  final TextEditingController geschlechtController = TextEditingController();

  final TextEditingController alterController = TextEditingController();
  final TextEditingController alterWController = TextEditingController();

  List<SelectedListItem>? _gameTypesSelect = [];

  @override
  void dispose() {
    super.dispose();
    wildartController.dispose();
    geschlechtController.dispose();
    alterController.dispose();
    alterWController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _gameTypesSelect = GameType.all.map((e) {
      return SelectedListItem(name: e.wildart);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: AppTextField(
              textEditingController: wildartController,
              title: 'Wildart',
              hint: 'Rehwild',
              enableModalBottomSheet: true,
              disableTyping: true,
              listItems: _gameTypesSelect,
              onSelect: (oldValue) {
                if (oldValue != wildartController.text) {
                  geschlechtController.clear();
                }
                setState(() {});
              }),
        ),
        Flexible(
          child: AppTextField(
            onSelect: (_) {},
            enabled: wildartController.text.isNotEmpty,
            textEditingController: geschlechtController,
            title: 'Geschlecht',
            hint: wildartController.text.isEmpty
                ? 'Rehbock'
                : GameType.all
                    .firstWhere((g) => g.wildart == wildartController.text)
                    .geschlechter
                    .first,
            enableModalBottomSheet: true,
            disableTyping: true,
            listItems: wildartController.text.isEmpty
                ? []
                : GameType.all
                    .firstWhere((g) => g.wildart == wildartController.text)
                    .geschlechter
                    .map((e) => SelectedListItem(name: e))
                    .toList(),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: AppTextField(
                  onSelect: (_) {},
                  textEditingController: alterController,
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
                  textEditingController: alterController,
                  title: 'Alter W (opt)',
                  hint: 'alt (6+)',
                  enableModalBottomSheet: false,
                  enableMultiSelection: false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
