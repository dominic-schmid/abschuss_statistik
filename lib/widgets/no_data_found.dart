import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String suffix;
  const NoDataFoundWidget({Key? key, this.suffix = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.transparent,
                child: Image.asset('assets/shooter.png'),
              ),
              const SizedBox(height: 20),
              Text(
                '${dg.noDataFoundText}\n$suffix',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
