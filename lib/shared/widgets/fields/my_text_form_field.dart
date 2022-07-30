import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:flutter/material.dart';


class MyTextFormField extends StatelessWidget {

  const MyTextFormField({
    Key? key,
    required this.hint,
    required this.icon,
    required this.fillColor,
    required this.inputType,
    required this.inputAction,
    required this.focusNode,
    required this.validator,
    this.controller
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final Color fillColor;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final String? Function(String?) ?validator;
  final TextEditingController ?controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: kBodyText1.copyWith(color: kPrimaryColor),
        cursorColor: kSecondaryColor,
        keyboardType: inputType,
        textInputAction: inputAction,
        focusNode: focusNode,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            border: kInputBorder,
            enabledBorder: kInputBorder,
            hintText: hint,
            hintStyle: kInputHintStyle,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.5, color: kPrimaryColor))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    icon,
                    color: focusNode.hasFocus ? kPrimaryColor : kSecondaryColor.withOpacity(0.5 ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}