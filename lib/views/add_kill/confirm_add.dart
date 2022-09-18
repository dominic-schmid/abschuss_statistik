import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/kill_entry.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:jagdstatistik/widgets/kill_list_entry.dart';

class ConfirmAddKill extends StatelessWidget {
  final KillEntry kill;
  const ConfirmAddKill({Key? key, required this.kill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final dg = S.of(context);

    return Scaffold(
      appBar: ChartAppBar(title: Text(dg.confirm), actions: const []),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KillListEntry(
                  initiallyExpanded: true,
                  kill: kill,
                  showPerson: true,
                  showEdit: false,
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.check_rounded),
                  label: Text(dg.confirm),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(7),
                    maximumSize: MaterialStateProperty.all<Size>(
                        Size(size.width * 0.9, size.height * 0.2)),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(size.width * 0.7, size.height * 0.1)),
                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //   RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
