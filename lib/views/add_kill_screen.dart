import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/cause.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/models/constants/usage.dart';
import 'package:jagdstatistik/models/kill_entry.dart';
import 'package:jagdstatistik/providers/pref_provider.dart';
import 'package:jagdstatistik/utils/constants.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/add_kill/add_details.dart';
import 'package:jagdstatistik/views/add_kill/add_erleger.dart';
import 'package:jagdstatistik/views/add_kill/add_gebiet.dart';
import 'package:jagdstatistik/views/add_kill/add_wild.dart';
import 'package:jagdstatistik/views/add_kill/confirm_add.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';
import 'package:provider/provider.dart';

class AddKillScreen extends StatefulWidget {
  final KillEntry? killEntry;
  const AddKillScreen({Key? key, this.killEntry}) : super(key: key);

  @override
  State<AddKillScreen> createState() => _AddKillScreenState();
}

class _AddKillScreenState extends State<AddKillScreen> {
  List<EnhanceStep> _steps = <EnhanceStep>[];
  final List<GlobalKey<FormState>> _formKeys = [];

  int _currentStep = 0;

  /// Add Kill
  // final GlobalKey<FormState> _killFormKey = GlobalKey<FormState>();
  final TextEditingController _wildartController = TextEditingController();
  final TextEditingController _geschlechtController = TextEditingController();
  final TextEditingController _alterController = TextEditingController();
  final TextEditingController _alterWController = TextEditingController();
  final TextEditingController _gewichtController = TextEditingController();

  List<SelectedListItem> _gameTypeSelectList = [];
  SelectedListItem? _geschlechtSelect;

  /// Add Erleger
  // final GlobalKey<FormState> _erlegerFormKey = GlobalKey<FormState>();
  final TextEditingController _erlegerController = TextEditingController();
  final TextEditingController _begleiterController = TextEditingController();
  final TextEditingController _datumController = TextEditingController();
  final TextEditingController _zeitController = TextEditingController();

  // Add Details
  final TextEditingController _ursacheController = TextEditingController();
  final TextEditingController _verwendungController = TextEditingController();
  final TextEditingController _aufseherController = TextEditingController();
  final TextEditingController _aufseherDatumController = TextEditingController();
  final TextEditingController _aufseherZeitController = TextEditingController();

  List<SelectedListItem> _ursacheSelectList = [];
  List<SelectedListItem> _verwendungSelectList = [];

  // Add Gebiet
  final TextEditingController _hegeringController = TextEditingController();
  final TextEditingController _ursprungszeichenController = TextEditingController();
  final TextEditingController _oertlichkeitController = TextEditingController();

  DateTime _dateTime = DateTime.now();
  LatLng? _latLng;
  bool _saveAufseher = false;

  void _submit() async {
    // send to server
    await showSnackBar('Data saved!', context);
    if (mounted) Navigator.of(context).pop();
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

    _gameTypeSelectList = GameType.all.map((e) {
      return SelectedListItem(name: e.wildart, value: e.wildart);
    }).toList();

    _ursacheSelectList = Cause.all.map((e) {
      return SelectedListItem(name: e.cause, value: e.cause);
    }).toList();

    _verwendungSelectList = Usage.all.map((e) {
      return SelectedListItem(name: e.usage, value: e.usage);
    }).toList();

    // If an entry was already sent, it should be edited
    // Pre-set all controller-only values
    if (widget.killEntry != null) {
      _dateTime = widget.killEntry!.datetime;
      _latLng = widget.killEntry!.gpsLat != null || widget.killEntry!.gpsLon != null
          ? LatLng(widget.killEntry!.gpsLat!, widget.killEntry!.gpsLon!)
          : null; // Default bolzano if none selected yet,
      _alterController.text = widget.killEntry!.alter;
      _alterWController.text = widget.killEntry!.alterw;
      _gewichtController.text = widget.killEntry!.gewicht.toString();
      _erlegerController.text = widget.killEntry!.erleger;
      _begleiterController.text = widget.killEntry!.begleiter;
      _datumController.text = DateFormat.yMd().format(_dateTime);
      _zeitController.text = DateFormat.Hm().format(_dateTime);
      _hegeringController.text = widget.killEntry!.hegeinGebietRevierteil;
      _ursprungszeichenController.text = widget.killEntry!.ursprungszeichen;
      _oertlichkeitController.text = widget.killEntry!.oertlichkeit;
      if (widget.killEntry!.jagdaufseher != null) {
        _aufseherController.text = widget.killEntry!.jagdaufseher!['aufseher'] as String;
        _aufseherDatumController.text =
            widget.killEntry!.jagdaufseher!['datum'] as String;
        _aufseherZeitController.text = widget.killEntry!.jagdaufseher!['zeit'] as String;
        _saveAufseher = true;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.killEntry != null) {
        SelectedListItem gt = _gameTypeSelectList
            .firstWhere((g) => g.value == widget.killEntry!.wildart)
          ..isSelected = true;

        SelectedListItem ges = GameType.all
            .firstWhere((g) => g.wildart == gt.value)
            .geschlechter
            .map((e) => SelectedListItem(
                name: GameType.translateGeschlecht(context, e), value: e))
            .firstWhere((ges) => widget.killEntry!.geschlecht == ges.value)
          ..isSelected = true;
        _geschlechtSelect = ges;

        SelectedListItem cause = _ursacheSelectList
            .firstWhere((g) => g.value == widget.killEntry!.ursache)
          ..isSelected = true;

        SelectedListItem usage = _verwendungSelectList
            .firstWhere((g) => g.value == widget.killEntry!.verwendung)
          ..isSelected = true;

        _wildartController.text = gt.name;
        _geschlechtController.text = ges.name;
        _ursacheController.text = cause.name;
        _verwendungController.text = usage.name;
        // try to get the default latLng for the google map if there is not a kill given

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    final defaultLatLng = Provider.of<PrefProvider>(context).latLng;

    Size size = MediaQuery.of(context).size;

    // Translate names in case of context change
    for (var element in _gameTypeSelectList) {
      element.name = GameType.translate(context, element.value);
    }

    for (var element in _ursacheSelectList) {
      element.name = Cause.translate(context, element.value);
    }
    for (var element in _verwendungSelectList) {
      element.name = Usage.translate(context, element.value);
    }

    _steps = <EnhanceStep>[
      EnhanceStep(
        title: Text(dg.wild),
        icon: const Icon(Icons.pets_rounded),
        content: AddWild(
          formState: _formKeys[0],
          alterController: _alterController,
          alterWController: _alterWController,
          geschlechtController: _geschlechtController,
          wildartController: _wildartController,
          gewichtController: _gewichtController,
          gameTypesSelect: _gameTypeSelectList,
          onSexSelect: (s) {
            _geschlechtSelect = s;
          },
        ),
      ),
      EnhanceStep(
        title: Text(dg.hunter),
        icon: const Icon(Icons.person_rounded),
        content: AddErleger(
          formState: _formKeys[1],
          begleiterController: _begleiterController,
          datumController: _datumController,
          erlegerController: _erlegerController,
          zeitController: _zeitController,
          initialDateTime: widget.killEntry?.datetime ?? _dateTime,
          onDateTimeChanged: (dt) => _dateTime = dt,
        ),
      ),
      EnhanceStep(
        title: Text(dg.details),
        icon: const Icon(Icons.edit_rounded),
        content: AddDetails(
          formState: _formKeys[2],
          ursacheController: _ursacheController,
          verwendungController: _verwendungController,
          ursacheTypesSelect: _ursacheSelectList,
          verwendungTypesSelect: _verwendungSelectList,
          aufseherController: _aufseherController,
          aufseherDatumController: _aufseherDatumController,
          aufseherZeitController: _aufseherZeitController,
          onAufseherSave: () => _saveAufseher = true,
        ),
      ),
      EnhanceStep(
        title: Text(dg.area),
        icon: const Icon(Icons.map_rounded),
        content: AddGebiet(
          formState: _formKeys[3],
          hegeringController: _hegeringController,
          oertlichkeitController: _oertlichkeitController,
          ursprungszeichenController: _ursprungszeichenController,
          isLatLngPreset:
              widget.killEntry?.gpsLat != null && widget.killEntry?.gpsLon != null,
          initialLatLng:
              widget.killEntry?.gpsLat != null || widget.killEntry?.gpsLon != null
                  ? LatLng(widget.killEntry!.gpsLat!, widget.killEntry!.gpsLon!)
                  : _latLng ??
                      defaultLatLng ??
                      Constants.bolzanoCoords // Default bolzano if none selected yet,
          ,
          onLatLngSelect: (pos) {
            setState(() {
              _latLng = pos;
            });
          },
        ),
      ),
    ];

    assert(_steps.length == _formKeys.length);

    return WillPopScope(
      onWillPop: () async {
        return await showAlertDialog(
          title: ' ${dg.close}',
          description: dg.confirmAddKillCancel,
          yesOption: dg.dialogYes,
          noOption: dg.dialogNo,
          onYes: () => Navigator.of(context).pop(),
          icon: Icons.warning_rounded,
          context: context,
        );
      },
      child: Scaffold(
        appBar: ChartAppBar(
          title: Text(widget.killEntry == null ? dg.addKill : dg.editKill),
          actions: const [],
        ),
        body: EnhanceStepper(
          steps: _steps,
          currentStep: _currentStep,
          onStepContinue: () async {
            // Only continue if the current step is valid
            if (_formKeys[_currentStep].currentState?.validate() ??
                false || _currentStep >= _steps.length - 1) {
              // Catch 'continue' on the last step
              if (_currentStep >= _steps.length - 1) {
                bool? kState = await Navigator.of(context).push(
                  MaterialPageRoute<bool>(
                    builder: (context) => ConfirmAddKill(
                      kill: KillEntry(
                        nummer: widget.killEntry?.nummer ?? 0,
                        wildart: _gameTypeSelectList
                            .firstWhere((element) => element.isSelected ?? false)
                            .value,
                        geschlecht: _geschlechtSelect!.value,
                        datetime: _dateTime,
                        ursache: _ursacheSelectList
                            .firstWhere((element) => element.isSelected ?? false)
                            .value,
                        verwendung: _verwendungSelectList
                            .firstWhere((element) => element.isSelected ?? false)
                            .value,
                        oertlichkeit: _oertlichkeitController.text,
                        hegeinGebietRevierteil: _hegeringController.text,
                        alter: _alterController.text,
                        alterw: _alterWController.text,
                        gewicht: double.tryParse(_gewichtController.text) ?? 0,
                        erleger: _erlegerController.text,
                        begleiter: _begleiterController.text,
                        ursprungszeichen: _ursprungszeichenController.text,
                        gpsLat: _latLng?.latitude,
                        gpsLon: _latLng?.longitude,
                        jagdaufseher: _saveAufseher &&
                                _aufseherController.text.isNotEmpty &&
                                _aufseherDatumController.text.isNotEmpty &
                                    _aufseherZeitController.text.isNotEmpty
                            ? {
                                'aufseher': _aufseherController.text,
                                'datum': _aufseherDatumController.text,
                                'zeit': _aufseherZeitController.text,
                              }
                            : null,
                      ),
                    ),
                  ),
                );

                if (kState == true) _submit(); // Adds kill to database
              } else {
                setState(() => _currentStep += 1);
              }
            }
          },
          onStepCancel: () async {
            if (_currentStep < 1) {
              await showAlertDialog(
                title: ' ${dg.close}',
                description: dg.confirmAddKillCancel,
                yesOption: dg.dialogYes,
                noOption: dg.dialogNo,
                onYes: () => Navigator.of(context).pop(),
                icon: Icons.warning_rounded,
                context: context,
              );
            } else {
              setState(() => _currentStep -= 1);
            }
          },
          onStepTapped: (index) {
            // Validate every step up until the one just clicked
            if (List.generate(index, (i) => i)
                .every((st) => (_formKeys[st].currentState?.validate() ?? false))) {
              setState(() {
                _currentStep = index;
              });
            }
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            final MaterialLocalizations localizations = MaterialLocalizations.of(context);
            return Row(
              children: [
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.height * 0.2, 36),
                  ),
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
    );
  }
}
