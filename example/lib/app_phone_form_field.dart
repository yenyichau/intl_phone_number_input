// Package imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intlphonenumberinputtest/app_constants.dart';
import 'package:intlphonenumberinputtest/app_text.dart';
import 'package:intlphonenumberinputtest/inkwell_wrapper.dart';

class AppPhoneFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isDense;
  final double verticalPadding;
  final double horizontalPadding;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final int errorMaxLines;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final Color? hintTextColor;
  final Color? textColor;
  final Color? labelColor;
  final bool shouldShowVisiblity;
  final Function()? onVisibilityTap;
  final bool enabled;
  final double? hinTextLetterSpacing;
  final Function(PhoneNumber)? onChanged;
  final Color? disableFontColor;
  final double labelTextSpacing;
  final FocusNode? focusNode;
  final String? errorText;
  final bool labelIsRequired;
  final double radius;
  final FontWeight? labelFontWeight;
  final double borderWidth;
  final FontWeight? textFontWeight;
  final Function(PointerDownEvent)? onTapOutside;
  final String? Function(String?)? validator;
  final Color? backgroundColor;
  final double? textSize;
  final double? labelTextSize;
  final double labelPaddingBottom;
  final double? errorTextSize;
  final Color? borderColor;
  final Color? focusBorderColor;
  final AutovalidateMode? autovalidateMode;
  final List<String>? countries;
  final PhoneNumber initPhoneNumber;
  final bool enabledClearText;
  final double? spaceBetweenSelectorAndTextField;
  final bool enabledPhoneOtp;
  final GlobalKey<FormState>? formKey;
  final Function(bool) onChecking;

  const AppPhoneFormField({
    super.key,
    required this.initPhoneNumber,
    required this.onChecking,
    this.focusNode,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isDense = true,
    this.verticalPadding = 13,
    this.horizontalPadding = 5,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.errorMaxLines = 2,
    this.textInputType = TextInputType.text,
    this.textInputFormatter,
    this.hintTextColor,
    this.textColor,
    this.labelColor,
    this.shouldShowVisiblity = false,
    this.onVisibilityTap,
    this.enabled = true,
    this.hinTextLetterSpacing,
    this.onChanged,
    this.disableFontColor,
    this.labelTextSpacing = 0.0,
    this.errorText,
    this.labelIsRequired = false,
    this.radius = 8,
    this.labelFontWeight,
    this.borderWidth = 1.0,
    this.textFontWeight,
    this.onTapOutside,
    this.validator,
    this.backgroundColor,
    this.textSize,
    this.labelTextSize,
    this.labelPaddingBottom = 0.0,
    this.errorTextSize = kFont12,
    this.borderColor,
    this.focusBorderColor,
    this.autovalidateMode,
    this.countries,
    this.enabledClearText = true,
    this.spaceBetweenSelectorAndTextField,
    this.enabledPhoneOtp = false,
    this.formKey,
  });

  @override
  State<AppPhoneFormField> createState() => _AppPhoneFormFieldState();
}

class _AppPhoneFormFieldState extends State<AppPhoneFormField> {
  int resentIn = 60;
  int resentInOriginal = 60;
  Timer? timer;
  bool canResentNow = true;
  bool isPhoneValid = true;
  late FocusNode _focusNode;
  late TextEditingController _textController;
  // ignore: unused_field
  PhoneNumber? _number;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _textController = widget.controller ?? TextEditingController();

    _focusNode.addListener(() {
      if (mounted) {
        if (!_focusNode.hasFocus) {
          _focusNode.unfocus();
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    if (widget.focusNode == null) {
      _focusNode.removeListener(() {});
      _focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // label
        if (widget.labelText != null)
          Padding(
            padding: EdgeInsets.only(
              bottom: widget.labelText != null ? 5 : widget.labelPaddingBottom,
            ),
            child: AppText(
              widget.labelText ?? "",
              isRequired: widget.labelIsRequired,
              fontWeight: widget.labelFontWeight ?? FontWeight.w600,
              color: widget.labelColor ?? Colors.white,
              fontSize: widget.labelTextSize ?? kFont12,
            ),
          ),

        // textformfield
        phone(context),

        // error message
        if (!isPhoneValid)
          Padding(
            padding: const EdgeInsets.only(top: 3, left: 20),
            child: AppText(
              "Invalid mobile number",
              color: Colors.red,
              fontSize: kFont12,
            ),
          ),
      ],
    );
  }

  // phone widget
  Widget phone(BuildContext context) {
    TextStyle textModeTextStyle = TextStyle(
      color: Colors.black,
      fontSize: kFont12,
      fontWeight: FontWeight.normal,
    );
    final List<Widget> suffixChildren = [];

    /// Clear Text Button
    if (widget.enabledClearText &&
        _focusNode.hasFocus &&
        _textController.text.isNotEmpty) {
      suffixChildren.add(
        InkWellWrapper(
          onTap: () {
            _textController.clear();
            isPhoneValid = false;
            widget.onChecking(isPhoneValid);
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    /// Custom Suffix Icon
    if (widget.suffixIcon != null) {
      suffixChildren.add(widget.suffixIcon!);
    }

    /// Phone OTP Button
    if (widget.enabledPhoneOtp) {
      suffixChildren.add(
        Container(
          color: Colors.white,
          child: InkWellWrapper(
            onTap: () {
              if (widget.formKey != null &&
                  widget.formKey!.currentState!.validate()) {
                if (isPhoneValid) {
                  _focusNode.unfocus();
                  actionResendCode();
                }
              } else {
                debugPrint("Formkey is missing");
              }
              setState(() {});
            },
            child: AppText(
              textAlign: TextAlign.end,
              canResentNow ? "Send Code" : "$resentIn",
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    /// Spacing (only if something else exists)
    if (suffixChildren.isNotEmpty) {
      suffixChildren.add(SizedBox(width: 10));
    }

    return TapRegion(
      onTapUpInside: (tap) {
        _focusNode.requestFocus();
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        decoration: BoxDecoration(
          color: widget.enabled ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: !isPhoneValid
                ? Colors.red
                : (_focusNode.hasFocus
                    ? const Color.fromRGBO(45, 69, 89, 1)
                    : widget.focusBorderColor ?? Colors.grey),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(useMaterial3: false).copyWith(
                  canvasColor:
                      Colors.white, // Set your desired background color here
                ),
                child: InternationalPhoneNumberInput(
                  // cursorColor: Colors.of(context).primaryText(),
                  isEnabled: widget.enabled,
                  focusNode: _focusNode,
                  onInputChanged: (val) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(val);
                    }

                    _number = val;
                    setState(() {});
                  },
                  onInputValidated: (bool value) {
                    isPhoneValid = value;
                    widget.onChecking(isPhoneValid);
                    debugPrint("isPhoneValid: $value");
                  },
                  onSaved: (PhoneNumber number) {
                    debugPrint("On Saved: $number");
                  },
                  countries: widget.countries,
                  // ??
                  //     const [
                  //       "MY", // Malaysia
                  //       "AU", // Australia
                  //       "BD", // Bangladesh
                  //       "BN", // Brunei
                  //       "KH", // Cambodia
                  //       "CA", // Canada
                  //       "CN", // China
                  //       "EG", // Egypt
                  //       "DE", // Germany
                  //       "HK", // Hong Kong
                  //       "IN", // India
                  //       "ID", // Indonesia
                  //       "IR", // Iran
                  //       "JP", // Japan
                  //       "NZ", // New Zealand
                  //       "NO", // Norway
                  //       "PH", // Philippines
                  //       "SA", // Saudi Arabia
                  //       "SG", // Singapore
                  //       "ZA", // South Africa
                  //       "KR", // South Korea
                  //       "LK", // Sri Lanka
                  //       "TW", // Taiwan
                  //       "TZ", // Tanzania
                  //       "TH", // Thailand
                  //       "TL", // Timor Leste
                  //       "US", // United States
                  //       "VN", // Vietnam
                  //     ]
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                    trailingSpace: false,
                  ),
                  searchBoxDecoration: InputDecoration(
                    hoverColor: Colors.transparent,
                    // hintText: context.tr(AppStrings.search),
                    hintStyle: textModeTextStyle.copyWith(
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  inputDecoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: textModeTextStyle.copyWith(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    errorStyle: const TextStyle(height: 0),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: widget.verticalPadding,
                    ),
                  ),
                  validator: (value) {
                    debugPrint("Phone validator: $value");

                    setState(() {
                      if (value != null) {
                        if (value.isEmpty) {
                          isPhoneValid = false;
                        }
                      }
                    });

                    return null;
                  },
                  selectorTextStyle: textModeTextStyle,
                  initialValue: widget.initPhoneNumber,
                  textFieldController: _textController,
                  formatInput: false,
                  spaceBetweenSelectorAndTextField:
                      widget.spaceBetweenSelectorAndTextField ?? 0,
                  textStyle: textModeTextStyle,
                  errorMessage: null,
                ),
              ),
            ),

            // suffix
            if (suffixChildren.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: suffixChildren,
              ),
          ],
        ),
      ),
    );
  }

  /// Phone OTP
  /// Timer Functions

  void startResentCountDown() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(() {
        if (resentIn < 2) {
          allowResent();
        } else {
          resentIn = resentIn - 1;
        }
      }),
    );
  }

  void allowResent() {
    canResentNow = true;
    timer!.cancel();
  }

  void actionResendCode() async {
    if (!isPhoneValid) return;
    if (!canResentNow) return;

    // await ApiService.api.phoneSendOtp(
    //   showLoader: true,
    //   phoneNo: _number?.phoneNumber?.replaceAll("+", "") ?? "",
    //   onSuccess: (_) {
    //     resetTimer();
    //   },
    // );
  }

  void resetTimer() {
    resentIn = resentInOriginal;
    canResentNow = false;
    startResentCountDown();
    setState(() {});
  }
}
