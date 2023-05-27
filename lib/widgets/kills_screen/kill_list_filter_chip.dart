import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/filter_chip_data.dart';
import 'package:jagdstatistik/utils/constants.dart';
import 'package:jagdstatistik/widgets/chip_selector_modal.dart';

class KillListFilterChip extends StatelessWidget {
  final IconData? iconData;
  final Color? iconColor;
  final String chipLabel;
  final String modalLabel;
  final List<FilterChipData> chips;
  final VoidCallback onClose;
  final Widget Function(BuildContext)? modalBuilder;

  static const EdgeInsets chipPadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 0);

  const KillListFilterChip({
    super.key,
    required this.chipLabel,
    required this.modalLabel,
    required this.chips,
    this.modalBuilder,
    required this.onClose,
    this.iconData,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: chipPadding,
      child: ActionChip(
          avatar: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              iconData,
              color: iconColor,
              size: 18,
            ),
          ),
          backgroundColor: iconColor?.withOpacity(0.25),
          labelStyle: TextStyle(color: iconColor),
          label: Text(modalLabel),
          onPressed: () async {
            await showModalBottomSheet(
                showDragHandle: true,
                context: context,
                shape: Constants.modalShape,
                builder: modalBuilder ??
                    (BuildContext context) {
                      return ChipSelectorModal(
                        key: Key(chipLabel),
                        title: chipLabel,
                        chips: chips,
                      );
                    });
            onClose.call();
          }),
    );
  }
}
