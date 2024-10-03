import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:easy_localization/easy_localization.dart';

class RequiredObjectValidator<T> extends FieldValidator<T> {
  RequiredObjectValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(T? value) {
    return value != null;
  }
}

class MinNumberValidator extends TextFieldValidator {
  MinNumberValidator({required this.minNumber})
      : super('Value must be greater than or equal to $minNumber');

  final int minNumber;

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    final parseValue = int.parse(value!);
    return parseValue >= minNumber;
  }

  @override
  String? call(String? value) {
    return isValid(value)
        ? null
        : 'Value must be greater than or equal to $minNumber';
  }
}

class RequiredValidatorMinute extends TextFieldValidator {
  RequiredValidatorMinute({
    required String errorText,
  }) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    final parseValue = int.parse(value!);
    return parseValue < 60;
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }
}

class RequiredValidatorHour extends TextFieldValidator {
  RequiredValidatorHour({
    required String errorText,
  }) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    final parseValue = int.parse(value!);
    return parseValue < 24;
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }
}

class RequiredValidatorDayMonth extends TextFieldValidator {
  RequiredValidatorDayMonth({
    required String errorText,
  }) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    final parseValue = int.parse(value!);
    return parseValue < 32;
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }
}

class RequiredValidatorMonth extends TextFieldValidator {
  RequiredValidatorMonth({
    required String errorText,
  }) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    final parseValue = int.parse(value!);
    return parseValue < 13;
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }
}

class RequiredValidatorBatch extends TextFieldValidator {
  RequiredValidatorBatch({
    required String errorText,
  }) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    final regex = RegExp(r'\d{5}(01|02|03|04|05|06|07|08|09|10|11|12)\d{2}');
    return regex.hasMatch(value!);
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }
}

class RequiredValidatorDayWeek extends TextFieldValidator {
  RequiredValidatorDayWeek({
    required String errorText,
  }) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    final parseValue = int.parse(value!);
    return parseValue < 7;
  }

  @override
  String? call(String? value) {
    return isValid(value) ? null : errorText;
  }
}

final requiredValidator = RequiredValidator(
  errorText: pleaseFillOutThisField.tr(),
);

final requiredObjectValidator = RequiredObjectValidator<dynamic>(
  errorText: pleaseFillOutThisField.tr(),
);

final requiredValidatorMinute = RequiredValidatorMinute(
  errorText: 'Value cannot exceed 60',
);

final requiredValidatorHour = RequiredValidatorHour(
  errorText: 'Value cannot exceed 24',
);

final requiredValidatorDayMonth = RequiredValidatorDayMonth(
  errorText: 'Value cannot exceed 32',
);

final requiredValidatorMonth = RequiredValidatorMonth(
  errorText: 'Value cannot exceed 13',
);

final requiredValidatorDayWeek = RequiredValidatorDayWeek(
  errorText: 'Value cannot exceed 7',
);
String? validateYear(String? year) {
  final yearRegex = RegExp(r'^[12]\d{3}$');
  if (!yearRegex.hasMatch(year!)) {
    return 'Invalid year format. Year should be between 1000 and 2999';
  }
  return null;
}
