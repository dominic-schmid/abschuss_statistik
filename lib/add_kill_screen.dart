import 'package:flutter/material.dart';
import 'package:jagdstatistik/utils/utils.dart';

class AddKillScreen extends StatefulWidget {
  const AddKillScreen({Key? key}) : super(key: key);

  @override
  State<AddKillScreen> createState() => _AddKillScreenState();
}

class _AddKillScreenState extends State<AddKillScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: rehwildFarbe,
        title: GestureDetector(
          onTap: () {
            //print(loadCredentialsFromPrefs());
          },
          child: const Text(
              'Abschuss hinzufügen' //style: TextStyle(color: ThemeData.estimateBrightnessForColor(color)),
              ),
        ),
        //backgroundColor: Colors.green,
        actions: [],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => showSnackBar('Hinzufügen...', context),
      //   child: Icon(Icons.add),
      // ),
      body: Container(
        color: rehwildFarbe,
      ),
    );
  }
}
