import 'package:flutter/material.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/custom_drop_down.dart';

/// This is Common App textfiled class.
class AppTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final String hint;
  final Function(String) onSelect;
  final VoidCallback? onTextFieldTap;
  final List<SelectedListItem>? listItems;
  final bool? enableModalBottomSheet;
  final bool? disableTyping;
  final bool? enableMultiSelection;
  final bool? enabled;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final Function(String?)? validator;

  const AppTextField({
    required this.textEditingController,
    required this.title,
    required this.hint,
    required this.onSelect,
    this.onTextFieldTap,
    this.enableModalBottomSheet,
    this.disableTyping,
    this.enableMultiSelection,
    this.listItems,
    this.enabled,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  //final TextEditingController _searchTextEditingController = TextEditingController();

  /// This is on text changed method which will display on city text field on changed.
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: (widget.enableMultiSelection) ?? false
            ? const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Container(),
        data: widget.listItems ?? [],
        selectedItems: (List<dynamic> selectedList) {
          String oldValue = widget.textEditingController.text;
          if (!(widget.enableMultiSelection ?? false)) {
            widget.textEditingController.text = selectedList.first.name;
          } else {
            String placeHolder = "";
            List<String> list = [];
            for (var item in selectedList) {
              if (item is SelectedListItem) {
                list.add(item.name);
                placeHolder += "$placeHolder, ${item.name}";
              }
            }
            widget.textEditingController.text =
                placeHolder.substring(1); // Ignore leading ,
            showSnackBar(list.toString(), context);
          }
          widget.onSelect(oldValue);
        },
        enableMultipleSelection: widget.enableMultiSelection ?? false,
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      widget.validator == null ? null : widget.validator!(value),
                  keyboardType: widget.keyboardType,
                  enabled: widget.enabled,
                  readOnly: widget.disableTyping ?? false,
                  controller: widget.textEditingController,
                  onTap: widget.enableModalBottomSheet == true &&
                          widget.disableTyping == true
                      ? () {
                          FocusScope.of(context).unfocus();
                          onTextFieldTap();
                        }
                      : widget.onTextFieldTap,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    contentPadding:
                        const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
                    hintText: widget.hint,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
              ),
              widget.enableModalBottomSheet == true && widget.disableTyping == false
                  ? const SizedBox(width: 12)
                  : Container(),
              widget.enableModalBottomSheet == true && widget.disableTyping == false
                  ? InkWell(
                      onTap: onTextFieldTap,
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                        child: Icon(widget.suffixIcon ?? Icons.list_rounded),
                      ),
                    )
                  : Container()
            ],
          ),
          // const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
