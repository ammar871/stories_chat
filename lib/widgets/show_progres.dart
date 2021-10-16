import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class IndicatorFile {
  static void showProgressIndicatorFile(BuildContext context, double valuepro) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child:CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 5.0,
          percent: valuepro,
          center:  Text("$valuepro %"),
          progressColor: Colors.green,
        ),
      ),
    );

    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }
}
