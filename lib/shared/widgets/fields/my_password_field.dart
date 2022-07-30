import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:flutter/material.dart';


class MyPasswordField extends StatefulWidget {
  const MyPasswordField({
    Key? key,
    required this.fillColor,
    required this.focusNode,
    required this.validator,
    this.controller
  }) : super(key: key);

  final Color fillColor;
  final FocusNode focusNode;
  final String? Function(String?) validator;
  final TextEditingController ?controller;

  @override
  State<MyPasswordField> createState() => _MyPasswordFieldState();
}

class _MyPasswordFieldState extends State<MyPasswordField> {

  bool hidePassword = true;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: kBodyText1.copyWith(color: kPrimaryColor),
        cursorColor: kSecondaryColor,
        textInputAction: TextInputAction.done,
        focusNode: widget.focusNode,
        obscureText: hidePassword,
        validator: widget.validator,
        controller: widget.controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor,
            border: kInputBorder,
            enabledBorder: kInputBorder,
            hintText: 'Password',
            hintStyle: kInputHintStyle,
            // contentPadding: const EdgeInsets.all(0),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.5, color: kPrimaryColor))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    Icons.lock_outline,
                    color: widget.focusNode.hasFocus ? kPrimaryColor : kSecondaryColor.withOpacity(0.5 ),
                  ),
                ),
              ),
            ),
            suffix: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    hidePassword = hidePassword == true ? false : true;
                  });
                },
                child: Text('Show',style: kBodyText3.copyWith(
                  decoration: TextDecoration.underline
                )),
              ),
            ),

        ),
      ),
    );
  }
}