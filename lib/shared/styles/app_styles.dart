import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:flutter/material.dart';

Color kPrimaryColor = const Color(0xff076AE1);
Color kSecondaryColor = const Color(0xff525257);
Color kThirdColor = const Color(0xffcccccc);
Color kFourthColor = const Color(0xFFFFFFFF);
Color kScaffoldBackground = const Color(0xFFFFFFFF);

final kTitle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: SizeConfig.blockSizeH! * 7,
  color: kPrimaryColor,
);
final kTitle2 = TextStyle(
  fontFamily: 'Roboto',
  fontSize: SizeConfig.blockSizeH! * 7,
  color: kPrimaryColor,
);

final kBodyText1 = TextStyle(
  color: kSecondaryColor,
  fontSize: SizeConfig.blockSizeH! * 4.5,
  fontWeight: FontWeight.bold,
);

final kBodyText2 = TextStyle(
  color: kFourthColor,
  fontSize: SizeConfig.blockSizeH! * 4.5,
  fontWeight: FontWeight.bold,
);

final kBodyText3 = TextStyle(
  color: Colors.black,
  fontSize: SizeConfig.blockSizeH! * 4,
);

final kInputBorder = OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none);

final kInputHintStyle = kBodyText1.copyWith(
fontWeight: FontWeight.normal,
color: kSecondaryColor.withOpacity(0.5));