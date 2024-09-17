import 'package:form_field_validator/form_field_validator.dart';

class NpwpValidator extends TextFieldValidator {
  NpwpValidator({required String errorText}) : super(errorText);
  final Pattern _npwpPattern = r'^\d{2}\.\d{3}\.\d{3}\.\d{1}-\d{3}\.\d{3}$';

  @override
  bool isValid(String? value) =>
      hasMatch(_npwpPattern.toString(), value!, caseSensitive: false);
}

class PhoneValidator extends TextFieldValidator {
  PhoneValidator({required String errorText}) : super(errorText);
  final Pattern _phonePattern = '[0-9+-]';

  @override
  bool isValid(String? value) =>
      hasMatch(_phonePattern.toString(), value!, caseSensitive: false);
}

class FaxValidator extends TextFieldValidator {
  FaxValidator({required String errorText}) : super(errorText);
  final Pattern _faxPattern = '[0-9+-]';

  @override
  bool isValid(String? value) =>
      hasMatch(_faxPattern.toString(), value!, caseSensitive: false);
}

class PostalCodeValidator extends TextFieldValidator {
  PostalCodeValidator({required String errorText}) : super(errorText);
  final Pattern _postalCodePattern = r'^\d{5}$';

  @override
  bool isValid(String? value) =>
      hasMatch(_postalCodePattern.toString(), value!, caseSensitive: false);
}

class NonZeroPositiveNumberValidator extends TextFieldValidator {
  NonZeroPositiveNumberValidator({required String errorText})
      : super(errorText);

  @override
  bool isValid(String? value) {
    if (value == null) {
      return false;
    }
    final number = num.tryParse(value);
    if (number == null) {
      return false;
    }
    if (number <= 0) {
      return false;
    }
    return true;
  }
}

class NonZeroPositiveNumberValidatorDecimal extends TextFieldValidator {
  NonZeroPositiveNumberValidatorDecimal({required String errorText})
      : super(errorText);

  @override
  bool isValid(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }

    if (value.startsWith('.')) {
      return false;
    }

    final regExp = RegExp(r'^[1-9]\d*(\.\d*)?$');
    if (!regExp.hasMatch(value)) {
      return false;
    }

    final number = num.tryParse(value);
    if (number == null || number <= 0) {
      return false;
    }

    return true;
  }
}
