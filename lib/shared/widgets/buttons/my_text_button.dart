import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:flutter/material.dart';


class MyTextButton extends StatelessWidget {
  const MyTextButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
    required this.bgColor,
  }) : super(key: key);
  final String buttonName;
  final VoidCallback onPressed;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        height: SizeConfig.blockSizeH! * 15.5,
        width: SizeConfig.blockSizeV! * 100,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            buttonName,
            style: kBodyText2,
          ),
          style: TextButton.styleFrom(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
        ),
      ),
    );
  }
}
