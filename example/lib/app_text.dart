// Project imports:
import 'package:flutter/material.dart';

import 'app_constants.dart';

class AppText extends StatelessWidget {
  final String data;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool underline;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final bool isOverflow;
  final double? height;
  final bool isRequired;
  final TextOverflow? textOverflow;
  final TextStyle? textStyle;
  final TextDecoration? decoration;

  const AppText(
    this.data, {
    this.color,
    this.fontSize,
    this.fontWeight,
    this.underline = false,
    this.maxLines,
    this.textAlign,
    this.fontStyle,
    this.isOverflow = false,
    this.height,
    this.isRequired = false,
    this.textOverflow,
    this.textStyle,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return !isRequired
        ? textWidget(context)
        : Text.rich(
            TextSpan(
              children: [
                WidgetSpan(child: textWidget(context)),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: const AppText("*", color: Colors.red),
                  ),
                ),
              ],
            ),
          );
  }

  Widget textWidget(BuildContext context) {
    TextStyle textModeTextStyle = TextStyle(
      color: Colors.black,
      fontSize: kFont14,
      fontWeight: FontWeight.normal,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(),
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: underline
      //         ? BorderSide(
      //             color: color ?? textModeTextStyle.color!,
      //           )
      //         : BorderSide.none,
      //   ),
      // ),
      child: Text(
        data,
        maxLines: maxLines,
        overflow: !isOverflow ? null : textOverflow ?? TextOverflow.ellipsis,
        textAlign: textAlign,
        style: textStyle ??
            textModeTextStyle.copyWith(
              color: underline
                  ? Colors.transparent
                  : color ?? textModeTextStyle.color,
              fontSize: fontSize ?? textModeTextStyle.fontSize,
              fontWeight: fontWeight ?? textModeTextStyle.fontWeight,
              fontStyle: fontStyle ?? FontStyle.normal,
              height: height,
              decoration:
                  decoration ?? (underline ? TextDecoration.underline : null),
              decorationColor: color ?? textModeTextStyle.color ?? Colors.black,
              shadows: underline
                  ? [
                      Shadow(
                        color: color ?? textModeTextStyle.color ?? Colors.black,
                        offset: const Offset(0, -4),
                      ),
                    ]
                  : null,
            ),
      ),
    );
  }
}
