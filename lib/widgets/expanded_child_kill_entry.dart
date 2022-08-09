import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/utils.dart';

class ExpandedChildKillEntry extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? value;

  const ExpandedChildKillEntry({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return value == null || value!.isEmpty || value == "null"
        ? Container()
        : ListTile(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: value));
              showSnackBar('In Zwischenablage kopiert!', context);
            },
            visualDensity: const VisualDensity(horizontal: 4, vertical: -3.5),
            textColor: secondaryColor,
            iconColor: secondaryColor,
            horizontalTitleGap: 0,
            leading: Icon(
              icon,
              size: size.height * 0.023,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5), child: Text(title)),
                ),
                Flexible(
                  child: Text(
                    value!,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                      fontSize: 15,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
