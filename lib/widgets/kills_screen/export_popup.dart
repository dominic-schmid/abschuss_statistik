import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/kill_entry.dart';
import 'package:jagdstatistik/models/kill_page.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class KillListExport extends StatelessWidget {
  final KillPage? page;
  final List<KillEntry> filteredKills;

  const KillListExport({
    super.key,
    required this.page,
    required this.filteredKills,
  });

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    Size size = MediaQuery.of(context).size;

    return SimpleDialog(
      title: Text(dg.ksExportDialogTitle, textAlign: TextAlign.center),
      children: [
        SimpleDialogOption(
          padding: const EdgeInsets.all(20),
          child: const Text('CSV (;)', textAlign: TextAlign.center),
          onPressed: () async {
            if (page == null || page!.kills.isEmpty) {
              showSnackBar(dg.noKillsFoundError, context);
              return;
            }
            _saveAndShareFile(context, csvDelimiter: ';');
            Navigator.of(context).pop();
          },
        ),
        SimpleDialogOption(
          padding: const EdgeInsets.all(20),
          child: const Text('CSV (,)', textAlign: TextAlign.center),
          onPressed: () async {
            if (page == null || page!.kills.isEmpty) {
              showSnackBar(dg.noKillsFoundError, context);
              return;
            }
            _saveAndShareFile(context, csvDelimiter: ',');

            Navigator.of(context).pop();
          },
        ),
        SimpleDialogOption(
          padding: const EdgeInsets.all(20),
          child: const Text('JSON', textAlign: TextAlign.center),
          onPressed: () {
            if (page == null || page!.kills.isEmpty) {
              showSnackBar(dg.noKillsFoundError, context);
              return;
            }
            _saveAndShareFile(context, isJson: true);

            Navigator.of(context).pop();
          },
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Text(
              dg.ksExportSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveAndShareFile(
    context, {
    String csvDelimiter = ";",
    bool isJson = false,
  }) async {
    final dg = S.of(context);
    if (filteredKills.isEmpty || page == null) {
      showSnackBar(dg.ksExportErrorSnackbar, context);
      return;
    }

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // ONLY AVAILABLE ON ANDROID
    final dir =
        (await getExternalStorageDirectories(type: StorageDirectory.downloads))!
            .first;

    final filteredPage = KillPage(
        jahr: page!.jahr, revierName: page!.revierName, kills: filteredKills);

    String filename =
        '${dir.path}/${filteredPage.revierName}-${DateTime.now().toIso8601String()}';

    filename = isJson ? '$filename.json' : '$filename.csv';

    File f = await File(filename).create(recursive: true);

    if (isJson) {
      f.writeAsStringSync(jsonEncode(filteredPage.toJson(context)),
          encoding: utf8);
    } else {
      f.writeAsStringSync(
          ListToCsvConverter(fieldDelimiter: csvDelimiter)
              .convert(filteredPage.toCSV(context)),
          encoding: utf8);
    }

    await Share.shareFiles([filename]);

    f.delete(); // Delete after sharing
    return;
  }
}
