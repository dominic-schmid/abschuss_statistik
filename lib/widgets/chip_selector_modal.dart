import 'package:flutter/material.dart';
import 'package:jagdstatistik/utils/translation_helper.dart';

import '../models/filter_chip_data.dart';

class ChipSelectorModal extends StatefulWidget {
  final Set<FilterChipData> chips;
  final String title;
  final EdgeInsets? padding;

  const ChipSelectorModal({
    Key? key,
    required this.title,
    required this.chips,
    this.padding,
  }) : super(key: key);

  @override
  State<ChipSelectorModal> createState() => _ChipSelectorModalState();
}

class _ChipSelectorModalState extends State<ChipSelectorModal> {
  bool _selectAll = false;

  @override
  void initState() {
    _selectAll = widget.chips.every((element) => element.isSelected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: widget.padding ??
            EdgeInsets.only(
              top: size.height * 0.01,
              left: size.width * 0.075,
              right: size.width * 0.075,
              bottom: size.height * 0.015,
            ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (_selectAll) {
                  for (var element in widget.chips) {
                    element.isSelected = false;
                  }
                } else {
                  for (var element in widget.chips) {
                    element.isSelected = true;
                  }
                }
                setState(() => _selectAll = !_selectAll);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: widget.chips
                  .map((c) => StatefulBuilder(builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2),
                          child: FilterChip(
                            checkmarkColor: c.color,
                            selectedColor: c.color.withOpacity(0.25),
                            disabledColor: c.color.withOpacity(0.1),
                            labelStyle: TextStyle(color: c.color),
                            onSelected: (selected) {
                              c.isSelected = selected;
                              if (mounted) setState(() {});
                            },
                            label: c.icon == null
                                ? Text(translateValue(context, c.label))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(translateValue(context, c.label)),
                                      const SizedBox(width: 4),
                                      Icon(
                                        c.icon,
                                        color: c.color,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                            selected: c.isSelected,
                          ),
                        );
                      }))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
