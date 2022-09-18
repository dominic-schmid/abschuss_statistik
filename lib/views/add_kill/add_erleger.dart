import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/utils/database_methods.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/views/add_kill/add_gebiet.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddErleger extends StatefulWidget {
  final GlobalKey<FormState> formState;

  final TextEditingController erlegerController;
  final TextEditingController begleiterController;

  final TextEditingController datumController;
  final TextEditingController zeitController;

  final DateTime initialDateTime;
  final Function(DateTime) onDateTimeChanged;

  const AddErleger({
    Key? key,
    required this.erlegerController,
    required this.begleiterController,
    required this.datumController,
    required this.zeitController,
    required this.onDateTimeChanged,
    required this.formState,
    required this.initialDateTime,
  }) : super(key: key);

  @override
  State<AddErleger> createState() => _AddErlegerState();
}

class _AddErlegerState extends State<AddErleger> {
  // Make these public so stepper can acces selected values later

  List<SelectedListItem>? _personenSelect;

  late DateTime _dateTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSuggestions();
    //_personenSelect = [SelectedListItem(name: 'Dominic Schmid')];
    _dateTime = widget.initialDateTime;
    widget.datumController.text = DateFormat.yMd().format(_dateTime);
    widget.zeitController.text = DateFormat.Hm().format(_dateTime);
  }

  Future<void> loadSuggestions() async {
    var database = await SqliteDB().db;

    List<Map<String, Object?>> ursprungszeichenRows = await database.transaction(
      (txn) async => await txn.rawQuery('''
        SELECT
        trim(erleger) as erleger,
        count(*) as anzahl
        FROM Kill
        WHERE erleger IS NOT NULL
        GROUP BY trim(erleger)
       '''),
    );

    _personenSelect = ursprungszeichenRows
        .map(
          (r) => SelectorHelper(r['erleger'] as String, r['anzahl'] as int, null),
        )
        .map((e) => SelectedListItem(name: e.name, value: e.value))
        .toList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    return _isLoading
        ? const Center(child: CircularProgressIndicator(color: rehwildFarbe))
        : Form(
            key: widget.formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AppTextField(
                    textEditingController: widget.erlegerController,
                    title: dg.hunter,
                    hint: 'Max Mustermann',
                    validator: (_) {
                      if (_ == null || _.isEmpty) return dg.pflichtfeld;
                    },
                    enableModalBottomSheet: true,
                    disableTyping: false,
                    listItems: _personenSelect,
                    onSelect: (_) {},
                  ),
                ),
                Flexible(
                  child: AppTextField(
                    textEditingController: widget.begleiterController,
                    title: dg.companion,
                    hint: 'Josef',
                    enableModalBottomSheet: true,
                    disableTyping: false,
                    listItems: _personenSelect,
                    onSelect: (_) {},
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: AppTextField(
                        textEditingController: widget.datumController,
                        title: dg.sortDate,
                        hint: DateFormat.yMd().format(_dateTime),
                        disableTyping: true,
                        validator: (_) {
                          if (_ == null) return dg.dateEmptyError;
                          if (_dateTime.isAfter(DateTime.now())) {
                            return dg.dateInFutureError;
                          }
                        },
                        onTextFieldTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _dateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );

                          if (selectedDate != null) {
                            _dateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              _dateTime.hour,
                              _dateTime.minute,
                            );
                            widget.datumController.text =
                                DateFormat.yMd().format(_dateTime);
                            widget.onDateTimeChanged(_dateTime);
                          }
                        },
                        listItems: _personenSelect,
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
                          if (_ == null) return dg.timeEmptyError;
                          if (_dateTime.isAfter(DateTime.now())) {
                            return dg.dateInFutureError;
                          }
                        },
                        hint: DateFormat.Hm().format(_dateTime),
                        disableTyping: true,
                        onTextFieldTap: () async {
                          TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(DateTime.now()));

                          if (selectedTime != null) {
                            _dateTime = DateTime(
                              _dateTime.year,
                              _dateTime.month,
                              _dateTime.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            widget.zeitController.text =
                                DateFormat.Hm().format(_dateTime);
                            widget.onDateTimeChanged(_dateTime);
                          }
                        },
                        listItems: _personenSelect,
                        onSelect: (_) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
