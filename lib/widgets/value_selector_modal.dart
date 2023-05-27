import 'package:flutter/material.dart';

class ValueSelectorModal<T> extends StatelessWidget {
  final Function(T) onSelect;
  final T selectedItem;
  final List<T> items;
  final bool padding;
  const ValueSelectorModal({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onSelect,
    this.padding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonList = [];
    //buttonList.add(_buildHandle(context));
    Size size = MediaQuery.of(context).size;

    for (T i in items) {
      buttonList.add(
        MaterialButton(
          minWidth: size.width,
          onPressed: () {
            Navigator.of(context).pop();
            onSelect(i);
          },
          elevation: 2,
          padding: padding
              ? EdgeInsets.symmetric(
                  horizontal: size.width * 0.2, vertical: size.height * 0.02)
              : EdgeInsets.symmetric(
                  horizontal: 0, vertical: size.height * 0.02),
          child: Text(
            '$i',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  i == selectedItem ? FontWeight.bold : FontWeight.normal,
              color: i == selectedItem
                  ? Colors.green
                  : Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .color, // secondaryColor,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: buttonList,
      ),
    );
  }
}
