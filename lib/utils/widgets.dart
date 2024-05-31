import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_guru/utils/helpers.dart';
import 'constants.dart';



Widget buildLoader() {
  return Center(child: SpinKitPulse(color: kBackgroundColor));
}

Widget strokeTextWidget(
    {
      required String fillText,
      required textFontSize,
      required textFontWeight
    }) {
  return Stack(
    children: [
      Text(
        capitalizeFirstLetter(fillText),
        style: TextStyle(
          fontSize: textFontSize,
          fontWeight: textFontWeight,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.black,
        ),
      ),
      Text(
        capitalizeFirstLetter(fillText),
        style:  TextStyle(
          fontSize: textFontSize,
          fontWeight: textFontWeight,
          color: Colors.white,
        ),
      ),
    ],
  );
}
