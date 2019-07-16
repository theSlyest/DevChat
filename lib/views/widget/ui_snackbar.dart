import 'package:flutter/material.dart';
import 'package:seclot/utils/color_conts.dart';
import 'package:seclot/views/widget/ui_loading_snackbar.dart';

abstract class UISnackBarProvider {
  GlobalKey<ScaffoldState> get scaffoldKey;

  void showInSnackBar(
    String value, [
    Duration duration = const Duration(milliseconds: 4000),
  ]) {
    closeLoadingSnackBar();
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: ColorUtils.dark_gray,
        content: Text(
          value,
          textAlign: TextAlign.center,
//          style: mkFontMedium(14.0, Colors.white),
        ),
        duration: duration,
      ),
    );
  }

  void closeLoadingSnackBar() {
    scaffoldKey.currentState?.hideCurrentSnackBar();
  }

  void showLoadingSnackBar([Widget content]) {
    closeLoadingSnackBar();
    scaffoldKey.currentState?.showSnackBar(
      UILoadingSnackBar(
        content: content,
      ),
    );
  }
}
