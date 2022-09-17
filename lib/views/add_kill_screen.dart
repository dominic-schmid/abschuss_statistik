import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:jagdstatistik/models/kill_entry.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/add_kill/add_details.dart';
import 'package:jagdstatistik/views/add_kill/add_erleger.dart';
import 'package:jagdstatistik/views/add_kill/add_gebiet.dart';
import 'package:jagdstatistik/views/add_kill/add_wild.dart';
import 'package:jagdstatistik/widgets/kill_list_entry.dart';

class AddKillScreen extends StatefulWidget {
  const AddKillScreen({Key? key}) : super(key: key);

  @override
  State<AddKillScreen> createState() => _AddKillScreenState();
}

class _AddKillScreenState extends State<AddKillScreen> {
  final List<EnhanceStep> _steps = <EnhanceStep>[];
  final List<GlobalKey<FormState>> _formKeys = [];

  int _currentStep = 0;

  /// Add Kill
  // final GlobalKey<FormState> _killFormKey = GlobalKey<FormState>();
  final TextEditingController _wildartController = TextEditingController();
  final TextEditingController _geschlechtController = TextEditingController();
  final TextEditingController _alterController = TextEditingController();
  final TextEditingController _alterWController = TextEditingController();
  final TextEditingController _gewichtController = TextEditingController();

  /// Add Erleger
  // final GlobalKey<FormState> _erlegerFormKey = GlobalKey<FormState>();
  final TextEditingController _erlegerController = TextEditingController();
  final TextEditingController _begleiterController = TextEditingController();
  final TextEditingController _datumController = TextEditingController();
  final TextEditingController _zeitController = TextEditingController();

  // Add Details
  final TextEditingController _ursacheController = TextEditingController();
  final TextEditingController _verwendungController = TextEditingController();

  // Add Gebiet
  final TextEditingController _hegeringController = TextEditingController();
  final TextEditingController _ursprungszeichenController = TextEditingController();
  final TextEditingController _oertlichkeitController = TextEditingController();

  DateTime _dateTime = DateTime.now();

  ValueNotifier<KillEntry> k = ValueNotifier<KillEntry>(KillEntry(
    nummer: 0,
    wildart: "",
    geschlecht: "",
    datetime: DateTime.now(),
    ursache: "",
    verwendung: "",
    oertlichkeit: "",
    hegeinGebietRevierteil: "",
    alter: "",
    alterw: "",
    gewicht: 0,
    erleger: "",
    begleiter: "",
    ursprungszeichen: "",
    //gpsLat = 0,
    //gpsLon = 0,
  ));

  void _submit() {
    // send to server
    showSnackBar('Data saved!', context);
  }

  @override
  void dispose() {
    super.dispose();
    _wildartController.dispose();
    _geschlechtController.dispose();
    _alterController.dispose();
    _alterWController.dispose();
    _gewichtController.dispose();
    _erlegerController.dispose();
    _begleiterController.dispose();
    _datumController.dispose();
    _zeitController.dispose();
    _ursacheController.dispose();
    _verwendungController.dispose();
    _hegeringController.dispose();
    _ursprungszeichenController.dispose();
    _oertlichkeitController.dispose();
  }

  @override
  void initState() {
    super.initState();

    /// Generate a separate GlobalKey for every step
    /// Make SURE to have the same amount as steps
    _formKeys.addAll([
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
    ]);

    _steps.addAll(<EnhanceStep>[
      EnhanceStep(
        title: Text('Wild'),
        content: AddWild(
          formState: _formKeys[0],
          alterController: _alterController,
          alterWController: _alterWController,
          geschlechtController: _geschlechtController,
          wildartController: _wildartController,
          gewichtController: _gewichtController,
        ),
      ),
      EnhanceStep(
        title: Text('Erleger'),
        content: AddErleger(
          formState: _formKeys[1],
          begleiterController: _begleiterController,
          datumController: _datumController,
          erlegerController: _erlegerController,
          zeitController: _zeitController,
          onDateTimeChanged: (dt) => _dateTime = dt,
        ),
      ),
      EnhanceStep(
        title: Text('Details'),
        content: AddDetails(
          formState: _formKeys[2],
          ursacheController: _ursacheController,
          verwendungController: _verwendungController,
        ),
      ),
      EnhanceStep(
        title: Text('Gebiet'),
        content: AddGebiet(
          formState: _formKeys[3],
          hegeringController: _hegeringController,
          oertlichkeitController: _oertlichkeitController,
          ursprungszeichenController: _ursacheController,
        ),
      ),
      // EnhanceStep(
      //     title: Text('Übersicht'),
      // content: KillListEntry(
      //   initiallyExpanded: true,
      //   kill: KillEntry(
      //     nummer: 0,
      //     wildart: _wildartController.text,
      //     geschlecht: _geschlechtController.text,
      //     datetime: _dateTime,
      //     ursache: _ursacheController.text,
      //     verwendung: _verwendungController.text,
      //     oertlichkeit: _oertlichkeitController.text,
      //     hegeinGebietRevierteil: _hegeringController.text,
      //     alter: _alterController.text,
      //     alterw: _alterWController.text,
      //     gewicht: double.tryParse(_gewichtController.text) ?? 0,
      //     erleger: _erlegerController.text,
      //     begleiter: _begleiterController.text,
      //     ursprungszeichen: _ursprungszeichenController.text,
      //     //gpsLat = 0,
      //     //gpsLon = 0,
      //   ),
      //   showPerson: true,
      // )

// _formKeys.every((element) => element.currentState!.validate())
//               ? const Card(
//                   child: NoDataFoundWidget(
//                     suffix: 'Du musst zuerst alle benötigten Daten eingeben.',
//                   ),
//                 )

      // return Center(child: Text("") // k.toString()),
      //     );

      // return allValid
      //     ? KillListEntry(
      //         initiallyExpanded: true,
      //         kill: KillEntry(
      //           nummer: 0,
      //           wildart: _wildartController.text,
      //           geschlecht: _geschlechtController.text,
      //           datetime: _dateTime,
      //           ursache: _ursacheController.text,
      //           verwendung: _verwendungController.text,
      //           oertlichkeit: _oertlichkeitController.text,
      //           hegeinGebietRevierteil: _hegeringController.text,
      //           alter: _alterController.text,
      //           alterw: _alterWController.text,
      //           gewicht: double.tryParse(_gewichtController.text) ?? 0,
      //           erleger: _erlegerController.text,
      //           begleiter: _begleiterController.text,
      //           ursprungszeichen: _ursprungszeichenController.text,
      //           //gpsLat = 0,
      //           //gpsLon = 0,
      //         ),
      //         showPerson: true,
      //       )
      //     :
      // }),
      // ),
    ]);
    assert(_steps.length == _formKeys.length); // Overview page doesn't count as form
  }

  @override
  Widget build(BuildContext context) {
// Update valuenotifier kill entry
    // k.value = KillEntry(
    //   nummer: 0,
    //   wildart: _wildartController.text,
    //   geschlecht: _geschlechtController.text,
    //   datetime: _dateTime,
    //   ursache: _ursacheController.text,
    //   verwendung: _verwendungController.text,
    //   oertlichkeit: _oertlichkeitController.text,
    //   hegeinGebietRevierteil: _hegeringController.text,
    //   alter: _alterController.text,
    //   alterw: _alterWController.text,
    //   gewicht: double.tryParse(_gewichtController.text) ?? 0,
    //   erleger: _erlegerController.text,
    //   begleiter: _begleiterController.text,
    //   ursprungszeichen: _ursprungszeichenController.text,
    //   //gpsLat = 0,
    //   //gpsLon = 0,
    // );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: rehwildFarbe,
        title: const Text(
            'Abschuss hinzufügen' //,style: TextStyle(color: ThemeData.estimateBrightnessForColor(color)),
            ),
        actions: const [],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: EnhanceStepper(
              steps: _steps,
              currentStep: _currentStep,
              onStepContinue: () async {
                if (_formKeys[_currentStep].currentState?.validate() ??
                    false || _currentStep >= _steps.length - 1) {
                  if (_currentStep >= _steps.length - 1) {
                    showSnackBar('Clicked next on the last step', context);
                    await showDialog(
                        barrierColor: Colors.black,
                        context: context,
                        builder: (context) {
                          return Center(
                            child: KillListEntry(
                              initiallyExpanded: true,
                              kill: KillEntry(
                                nummer: 0,
                                wildart: _wildartController.text,
                                geschlecht: _geschlechtController.text,
                                datetime: _dateTime,
                                ursache: _ursacheController.text,
                                verwendung: _verwendungController.text,
                                oertlichkeit: _oertlichkeitController.text,
                                hegeinGebietRevierteil: _hegeringController.text,
                                alter: _alterController.text,
                                alterw: _alterWController.text,
                                gewicht: double.tryParse(_gewichtController.text) ?? 0,
                                erleger: _erlegerController.text,
                                begleiter: _begleiterController.text,
                                ursprungszeichen: _ursprungszeichenController.text,
                                //gpsLat = 0,
                                //gpsLon = 0,
                              ),
                              showPerson: true,
                            ),
                          );
                        });
                    // TODO
                    _submit();
                  } else {
                    setState(() => _currentStep += 1);
                  }
                }
              },
              onStepCancel: () {
                if (_currentStep < 1) {
                  showSnackBar('First step. Cannot go back any further', context);
                } else {
                  setState(() => _currentStep -= 1);
                }
              },
              onStepTapped: (index) {
                // TODO
                setState(() {
                  _currentStep = index;
                });
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final MaterialLocalizations localizations =
                    MaterialLocalizations.of(context);
                return Row(
                  children: [
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(localizations.continueButtonLabel),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(localizations.cancelButtonLabel),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
