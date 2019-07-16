import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:seclot/utils/color_conts.dart';

class UILoadingSnackBar extends SnackBar {
  UILoadingSnackBar({Key key, Widget content})
      : super(
          key: key,
          backgroundColor: content == null ? Colors.white : ColorUtils.dark_gray,
          content: Row(
            mainAxisAlignment: content == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              SizedBox.fromSize(
                size: Size(48.0, 24.0),
                child: SpinKitThreeBounce(
                  color: content == null ? ColorUtils.dark_gray : Colors.white,
                  size: 24.0,
                ),
              ),
              SizedBox(width: content == null ? 0.0 : 16.0),
              content == null
                  ? SizedBox()
                  : Expanded(
                      child: DefaultTextStyle(
//                        style: mkFontColor(Colors.white),
                        child: content, style: null,
                      ),
                    ),
            ],
          ),
          duration: Duration(days: 1),
        );
}
