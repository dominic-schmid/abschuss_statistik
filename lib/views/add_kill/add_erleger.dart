import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/widgets/app_text_field.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

class AddErleger extends StatefulWidget {
  const AddErleger({Key? key}) : super(key: key);

  @override
  State<AddErleger> createState() => _AddErlegerState();
}

class _AddErlegerState extends State<AddErleger> {
  // Make these public so stepper can acces selected values later
  final TextEditingController erlegerController = TextEditingController();
  final TextEditingController begleiterController = TextEditingController();

  DateTime dateTime = DateTime.now();

  List<SelectedListItem>? _personenSelect;

  @override
  void dispose() {
    super.dispose();
    erlegerController.dispose();
    begleiterController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _personenSelect = [SelectedListItem(name: 'Dominic Schmid')];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: AppTextField(
            textEditingController: erlegerController,
            title: 'Erleger',
            hint: 'Max Mustermann',
            enableModalBottomSheet: true,
            disableTyping: false,
            listItems: _personenSelect,
            onSelect: (_) {},
          ),
        ),
        Flexible(
          child: AppTextField(
            textEditingController: erlegerController,
            title: 'Begleiter (opt)',
            hint: 'Frieda Feuerstein',
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
                textEditingController: TextEditingController(),
                title: 'Datum',
                hint: DateFormat.yMd().format(dateTime),
                disableTyping: true,
                onTextFieldTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (selectedDate != null) {
                    dateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      dateTime.hour,
                      dateTime.minute,
                    );
                    setState(() {});
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
                textEditingController: TextEditingController(),
                title: 'Zeit',
                hint: DateFormat.Hm().format(dateTime),
                disableTyping: true,
                onTextFieldTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(DateTime.now()));

                  if (selectedTime != null) {
                    dateTime = DateTime(
                      dateTime.year,
                      dateTime.month,
                      dateTime.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    setState(() {});
                  }
                },
                listItems: _personenSelect,
                onSelect: (_) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
