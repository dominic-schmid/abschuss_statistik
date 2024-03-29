import 'package:flutter/material.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

/// This is search text field class.
class AppSearchTextField extends StatefulWidget {
  final DropDown dropDown;
  final Function(String) onTextChanged;

  const AppSearchTextField({
    required this.dropDown,
    required this.onTextChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<AppSearchTextField> createState() => _AppSearchTextFieldState();
}

class _AppSearchTextFieldState extends State<AppSearchTextField> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dg = S.of(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: _editingController,
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          contentPadding: const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 15),
          hintText: dg.search,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          prefixIcon: const IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
          suffixIcon: GestureDetector(
            onTap: onClearTap,
            child: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void onClearTap() {
    _editingController.clear();
  }
}
