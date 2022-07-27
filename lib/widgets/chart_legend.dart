import 'package:flutter/material.dart';

class ChartItem {
  final String label;
  final double value;
  final Color color;

  const ChartItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  String toString() {
    return '$label $value $color';
  }
}

class ChartLegend extends StatelessWidget {
  final List<ChartItem> items;
  final bool showValues;

  const ChartLegend({Key? key, required this.items, this.showValues = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          String text = showValues
              ? '${items.elementAt(index).label} (${items.elementAt(index).value})'
              : items.elementAt(index).label;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.025,
              vertical: size.height * 0.01,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: items.elementAt(index).color,
                      borderRadius: BorderRadius.circular(5)),
                  width: size.width * 0.05,
                  height: size.width * 0.05,
                ),
                SizedBox(width: size.width * 0.02),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
