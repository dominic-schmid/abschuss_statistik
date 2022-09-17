import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/material.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/add_kill/add_erleger.dart';
import 'package:jagdstatistik/views/add_kill/add_wild.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';

class AddKillScreen extends StatefulWidget {
  const AddKillScreen({Key? key}) : super(key: key);

  @override
  State<AddKillScreen> createState() => _AddKillScreenState();
}

class _AddKillScreenState extends State<AddKillScreen> {
  // final PageController _pageController =  PageController();

  final List<EnhanceStep> _steps = <EnhanceStep>[];
  int _currentStep = 0;
  int _furthestStep = 0;

  /// This is register text field controllers.
  final TextEditingController _wildartController = TextEditingController();
  final TextEditingController _geschlechtController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _wildartController.dispose();
    _geschlechtController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _steps.addAll(const <EnhanceStep>[
      EnhanceStep(title: Text('Wild'), content: AddWild()),
      EnhanceStep(
        title: Text('Erleger'),
        content: AddErleger(),
      ),
      // EnhanceStep(
      //   title: Text('Abschuss'),
      //   content:
      // ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
                onStepContinue: () {
                  if (_currentStep >= _steps.length - 1) {
                    showSnackBar('Last step', context);
                  } else {
                    setState(() {
                      _currentStep += 1;
                    });
                    if (_furthestStep < _currentStep) {
                      _furthestStep = _currentStep;
                    }
                  }
                },
                onStepCancel: () {
                  if (_currentStep == 0) {
                    showSnackBar('First step', context);
                  } else {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                onStepTapped: (index) {
                  if (index > _furthestStep) {
                    showSnackBar('Cannot skip step', context);
                  } else {
                    setState(() {
                      _currentStep = index;
                    });
                  }
                },
              ),
            ),
          ],
        ));
  }
}
