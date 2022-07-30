import 'package:flutter/material.dart';

import '../../shared/styles/app_styles.dart';

class OnBoardNavBtn extends StatelessWidget {
  const OnBoardNavBtn({
    Key? key,
    required this.name,
    required this.onPressed,
  }) : super(key: key);
  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        splashColor: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(name, style: kBodyText1),
        ));
  }
}