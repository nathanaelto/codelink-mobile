import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:flutter/material.dart';

class MyCheckBox extends StatefulWidget {
  MyCheckBox({
    Key? key,
    required this.text,
    required this.isChecked,
    required this.onChanged
  }) : super(key: key);

  final String text;
  bool isChecked;
  final Function(bool? value) onChanged;

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            activeColor: kPrimaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            value: widget.isChecked,
            onChanged: (value) {
              widget.onChanged(value);
            }),
        Text(
          widget.text,
          style: kBodyText3,
        )
      ],
    );
  }
}
