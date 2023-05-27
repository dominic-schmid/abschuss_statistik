import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/utils.dart';

class KillListProgressBar extends StatelessWidget {
  const KillListProgressBar({
    super.key,
    required this.showing,
    required this.total,
  });

  final int showing;
  final int total;

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    double percentage = showing / (total * 1.0);
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        left: w * 0.1,
        right: w * 0.1,
        top: 0,
        bottom: 15,
      ),
      child: Column(
        children: [
          //#c4 > h1
          const SizedBox(height: 10),
          Text(
            dg.ksShowXFromYProgressBar(showing, total),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            child: LinearProgressIndicator(
              color: rehwildFarbe,
              value: percentage,
            ),
          )
        ],
      ),
    );
  }
}
