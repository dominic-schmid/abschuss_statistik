import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/sorting.dart';

class KillListSortingModal extends StatelessWidget {
  final Sorting currentSorting;
  final List<Sorting> sortings;
  final void Function(Sorting) onTap;

  const KillListSortingModal({
    super.key,
    required this.sortings,
    required this.currentSorting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonList = [];
    Size size = MediaQuery.of(context).size;

    //_sortings = Sorting.generateDefault(context);

    for (Sorting s in sortings) {
      buttonList.add(
        MaterialButton(
          minWidth: size.width,
          onPressed: () {
            if (currentSorting == s) {
              currentSorting.toggleDirection();
            } else {
              onTap(s);
            }
            Navigator.of(context).pop();
            //_scrollToTop();
          },
          elevation: 2,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1, vertical: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                s.label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      s == currentSorting ? FontWeight.bold : FontWeight.normal,
                  color: s == currentSorting
                      ? Colors.green
                      : Theme.of(context).textTheme.displayLarge!.color,
                ),
              ),
              const SizedBox(width: 12),
              s.sortType == SortType.kein || s != currentSorting
                  ? Container()
                  : Icon(
                      currentSorting.ascending
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: s == currentSorting
                          ? Colors.green
                          : Theme.of(context).textTheme.displayLarge!.color,
                    ),
            ],
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
