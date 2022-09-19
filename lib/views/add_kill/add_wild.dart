import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddWild extends StatefulWidget {
  final GlobalKey<FormState> formState;
  final TextEditingController wildartController;
  final TextEditingController geschlechtController;

  final List<SelectedListItem>? gameTypesSelect;

  final TextEditingController alterController;
  final TextEditingController alterWController;

  final TextEditingController gewichtController;
  final Function(SelectedListItem) onSexSelect;

  const AddWild({
    Key? key,
    required this.formState,
    required this.wildartController,
    required this.geschlechtController,
    required this.alterController,
    required this.alterWController,
    required this.gewichtController,
    required this.gameTypesSelect,
    required this.onSexSelect,
  }) : super(key: key);

  @override
  State<AddWild> createState() => _AddWildState();
}

class _AddWildState extends State<AddWild> {
  double gewicht = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);

    var geschlechterList = widget.wildartController.text.isEmpty
        ? <SelectedListItem>[]
        : GameType.all
            .firstWhere((g) =>
                g.wildart ==
                widget.gameTypesSelect
                    ?.firstWhere((element) => element.isSelected ?? false)
                    .value)
            .geschlechter
            .map((e) => SelectedListItem(
                name: GameType.translateGeschlecht(context, e), value: e))
            .toList();

    return Form(
      key: widget.formState,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AppTextField(
                textEditingController: widget.wildartController,
                title: dg.wild,
                hint: dg.rehwild,
                validator: (_) {
                  if (_ == null || _.isEmpty) return dg.pflichtfeld;
                },
                enableModalBottomSheet: true,
                disableTyping: true,
                listItems: widget.gameTypesSelect,
                onSelect: (oldValue) {
                  if (oldValue != widget.wildartController.text) {
                    widget.geschlechtController.clear();
                  }
                  setState(() {});
                }),
          ),
          Flexible(
            child: AppTextField(
              onSelect: (_) {
                widget.onSexSelect(geschlechterList
                    .firstWhere((element) => element.isSelected ?? false));
              },
              enabled: widget.wildartController.text.isNotEmpty,
              textEditingController: widget.geschlechtController,
              title: dg.sortGender,
              validator: (_) {
                if (_ == null || _.isEmpty) return dg.pflichtfeld;
              },
              hint: widget.wildartController.text.isEmpty
                  ? dg.tBock
                  : geschlechterList.first.name,

              // GameType.translateGeschlecht(
              //     context,
              //     GameType.all
              //         .firstWhere((g) =>
              //             g.wildart ==
              //             widget.gameTypesSelect!
              //                 .firstWhere((element) => element.isSelected ?? false)
              //                 .value)
              //         .geschlechter
              //         .first,
              //   ),
              enableModalBottomSheet: true,
              disableTyping: true,
              listItems: widget.wildartController.text.isEmpty
                  ? <SelectedListItem>[]
                  : geschlechterList,
            ),
          ),
          const Divider(),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AppTextField(
                    onSelect: (_) {},
                    textEditingController: widget.alterController,
                    title: dg.age,
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
                    title: "${dg.age} W",
                    hint: '6+',
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
              title: dg.weightInKg,
              hint: '14.8 kg',
              enableModalBottomSheet: false,
              enableMultiSelection: false,
              keyboardType: TextInputType.number,
              validator: (content) {
                if (content == null || content.isEmpty) {
                  return null;
                } else if (double.tryParse(content) == null) {
                  return dg.zahlNichtGelesenError;
                } else if (double.parse(content) < 0) {
                  return dg.zahlNegativError;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
