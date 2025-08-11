import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

final currencyFormatter = CurrencyTextInputFormatter.currency(
  symbol: '',
  decimalDigits: 2,
  locale: 'en',
);

final currencyFormatterNoDecimal = CurrencyTextInputFormatter.currency(
  symbol: '',
  decimalDigits: 0,
  locale: 'en',
);

class FTextFormField extends FormField<String> {
  FTextFormField({
    super.key,
    this.suffixText,
    this.onEditingComplete,
    this.errorText,
    this.maxLines = 1,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.controller,
    this.showCounter = false,
    this.helperText,
    this.autoFocus = false,
    this.inputFormatters,
    this.focusNode,
    this.maxLength,
    this.hintText,
    this.onChanged,
    super.validator,
    super.enabled,
    this.onTapOutside,
    this.onSubmitted,
    this.isNumeric = false,
  }) : super(
          initialValue: controller?.text ?? '',
          builder: (field) {
            final error = errorText ?? field.errorText;

            return Builder(
              builder: (context) {
                final theme = Theme.of(context);
                final border = OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: error != null
                        ? Colors.red
                        : theme.modeCondition(
                            Colors.blueGrey.shade100,
                            const Color(0xff343640),
                          ),
                  ),
                );

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      autofocus: autoFocus,
                      textAlign: isNumeric ? TextAlign.right : TextAlign.left,
                      focusNode: focusNode,
                      readOnly: readOnly,
                      enabled: enabled,
                      onChanged: (value) {
                        field.setValue(value);
                        onChanged?.call(value);
                      },
                      inputFormatters: inputFormatters,
                      maxLength: maxLength,
                      maxLines: maxLines,
                      controller: controller,
                      obscureText: obscureText,
                      onEditingComplete: onEditingComplete,
                      onTapOutside: onTapOutside,
                      onSubmitted: onSubmitted,
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        counterText: showCounter ? null : '',
                        labelText:
                            (labelText ?? '') + (enabled ? '' : ' (Read Only)'),
                        hintText: hintText,
                        filled: true,
                        fillColor: enabled
                            ? theme.modeCondition(
                                Colors.blueGrey.shade50.withOpacity(.6),
                                MyTheme.black00dp,
                              )
                            : theme.modeCondition(
                                Colors.blueGrey.shade100.withOpacity(.8),
                                MyTheme.black00dp,
                              ),
                        suffixText: suffixText,
                        suffixIcon: suffixIcon,
                        suffixStyle: TextStyle(
                          color: theme.modeCondition(
                            Colors.black87,
                            Colors.white60,
                          ),
                        ),
                        enabledBorder: border,
                        disabledBorder: border,
                        border: border,
                      ),
                    ),
                    _HelperText(helperText),
                    ErrorTextField(errorText: error),
                  ],
                );
              },
            );
          },
        );
  static Widget decimal({
    required String labelText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return FTextFormField(
      enabled: enabled,
      labelText: labelText,
      controller: controller,
      validator: validator,
      isNumeric: true,
      inputFormatters: [
        DecimalInputFormatter(),
      ],
    );
  }

  final void Function()? onEditingComplete;
  final String? errorText;
  final int? maxLines;
  final String? labelText;
  final String? helperText;
  final int? maxLength;
  final bool obscureText;
  final bool showCounter;
  final bool readOnly;
  final bool autoFocus;
  final Widget? suffixIcon;
  final String? suffixText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  void Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatters;
  void Function(PointerDownEvent)? onTapOutside;
  void Function(String)? onSubmitted;
  final bool isNumeric;
}

class ErrorTextField extends StatelessWidget {
  const ErrorTextField({
    super.key,
    this.errorText,
  });

  final String? errorText;

  @override
  Widget build(BuildContext context) {
    if (errorText != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 6, top: 6),
        child: Text(
          errorText!,
          style: const TextStyle(color: Colors.red, fontSize: 10),
        ),
      );
    }
    return const SizedBox();
  }
}

class _HelperText extends StatelessWidget {
  const _HelperText(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 6),
      child: Text(
        text!,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
      ),
    );
  }
}

final inputLetterOnly = [
  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
];

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regExp = RegExp(r'^\d*\.?\d*$');
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
