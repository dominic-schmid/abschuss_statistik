import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/chart_app_bar.dart';

class AddJagdaufseherScreen extends StatefulWidget {
  final TextEditingController aufseherController;
  final TextEditingController datumController;
  final TextEditingController zeitController;

  const AddJagdaufseherScreen({
    Key? key,
    required this.aufseherController,
    required this.datumController,
    required this.zeitController,
  }) : super(key: key);

  @override
  State<AddJagdaufseherScreen> createState() => _AddJagdaufseherScreenState();
}

class _AddJagdaufseherScreenState extends State<AddJagdaufseherScreen> {
  final GlobalKey<FormState> formState = GlobalKey();

  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    if (widget.datumController.text.isNotEmpty && widget.zeitController.text.isNotEmpty) {
      print(
          'Trying to parse ${widget.datumController.text} and ${widget.zeitController.text}');
      _dateTime = DateTime.tryParse(
          "${widget.datumController.text.replaceAll('.', '-')} ${widget.zeitController.text}");
      print('Parsed $_dateTime');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final dg = S.of(context);

    return Scaffold(
      appBar: ChartAppBar(title: Text(dg.overseer), actions: [
        IconButton(
          onPressed: () {
            widget.aufseherController.text = "";
            widget.datumController.text = "";
            widget.zeitController.text = "";
            Navigator.of(context).pop(false);
          },
          icon: const Icon(Icons.delete_forever_rounded),
        )
      ]),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.01,
            horizontal: size.width * 0.1,
          ),
          child: Form(
            key: formState,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    AppTextField(
                      textEditingController: widget.aufseherController,
                      title: dg.overseer,
                      hint: 'Josef',
                      enableModalBottomSheet: false,
                      disableTyping: false,
                      validator: (_) {
                        if (_ == null || _.isEmpty) return dg.pflichtfeld;
                      },
                      onSelect: (_) {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 5,
                          child: AppTextField(
                            textEditingController: widget.datumController,
                            title: dg.sortDate,
                            hint: DateFormat.yMd().format(_dateTime ?? DateTime.now()),
                            disableTyping: true,
                            validator: (_) {
                              if (_ == null || _.isEmpty) return dg.timeEmptyError;
                              if (_dateTime != null &&
                                  _dateTime!.isAfter(DateTime.now())) {
                                return dg.dateInFutureError;
                              }
                            },
                            onTextFieldTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _dateTime ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );

                              if (selectedDate != null) {
                                _dateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  _dateTime == null ? 0 : _dateTime!.hour,
                                  _dateTime == null ? 0 : _dateTime!.minute,
                                );
                                widget.datumController.text =
                                    DateFormat.yMd().format(_dateTime!);
                                widget.zeitController.text =
                                    DateFormat.Hm().format(_dateTime!);
                              }
                            },
                            onSelect: (_) {},
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Flexible(
                          flex: 5,
                          child: AppTextField(
                            textEditingController: widget.zeitController,
                            title: dg.time,
                            validator: (_) {
                              if (_ == null || _.isEmpty) return dg.timeEmptyError;
                              if (_dateTime != null &&
                                  _dateTime!.isAfter(DateTime.now())) {
                                return dg.dateInFutureError;
                              }
                            },
                            hint: DateFormat.Hm().format(_dateTime ?? DateTime.now()),
                            disableTyping: true,
                            onTextFieldTap: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(DateTime.now()));

                              if (selectedTime != null) {
                                _dateTime = DateTime(
                                  _dateTime == null
                                      ? DateTime.now().year
                                      : _dateTime!.year,
                                  _dateTime == null
                                      ? DateTime.now().month
                                      : _dateTime!.month,
                                  _dateTime == null ? DateTime.now().day : _dateTime!.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                widget.datumController.text =
                                    DateFormat.yMd().format(_dateTime!);
                                widget.zeitController.text =
                                    DateFormat.Hm().format(_dateTime!);
                              }
                            },
                            onSelect: (_) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //SizedBox(height: size.height * 0.2),
                ElevatedButton.icon(
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      Navigator.of(context).pop(true);
                    }
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: Text(dg.confirm),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(7),
                    maximumSize:
                        MaterialStateProperty.all<Size>(Size(size.width * 0.9, 100)),
                    minimumSize:
                        MaterialStateProperty.all<Size>(Size(size.width * 0.7, 72)),
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
