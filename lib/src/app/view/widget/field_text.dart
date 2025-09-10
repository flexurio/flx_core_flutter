import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_text_form_field.dart';

class Option {
  Option(this.text, this.value);

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(json['value'] as String, json['code'] as String);
  }
  final String text;
  final String value;
}

class FieldOptions extends StatelessWidget {
  const FieldOptions({
    required this.labelText,
    required this.options,
    required this.isRequired,
    super.key,
    this.value,
    this.onSaved,
    this.isLoading = false,
  });

  final bool isLoading;
  final bool isRequired;
  final String? value;
  final String labelText;
  final List<Option> options;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onSaved: onSaved,
      items: options
          .map(
            (option) => DropdownMenuItem(
              value: option.value,
              child: Text(option.text),
            ),
          )
          .toList(),
      validator: isRequired
          ? ((value) =>
              value == '' || value == null ? '$labelText is required' : null)
          : null,
      decoration: InputDecoration(
        hintText: isLoading ? 'Loading...' : null,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {},
    );
  }
}

class FieldText extends StatelessWidget {
  const FieldText({
    this?.labelText,
    super.key,
    this.maxLines = 1,
    this.controller,
    this.errorText,
    this.focusNode,
    this.onEditingComplete,
    this.validator,
    this.isExpanded = false,
    this.obscureText = false,
    this.enabled = true,
    this.showCounter = false,
    this.autoFocus = false,
  });

  final int maxLines;
  final bool isExpanded;
  final bool enabled;
  final bool obscureText;
  final bool autoFocus;
  final bool showCounter;
  final String? labelText;
  final FocusNode? focusNode;
  final String? errorText;
  final TextEditingController? controller;
  final void Function()? onEditingComplete;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final button = FTextFormField(
      key: super.key,
      showCounter: showCounter,
      autoFocus: autoFocus,
      enabled: enabled,
      focusNode: focusNode,
      errorText: errorText,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      onEditingComplete: onEditingComplete,
      labelText: labelText,
    );
    return !isExpanded ? button : Expanded(child: button);
  }
}
