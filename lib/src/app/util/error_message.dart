import 'package:easy_localization/easy_localization.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

bool _isSnakeCase(String input) {
  final regex = RegExp(r'^[a-z]+(_[a-z]+)*$');
  return regex.hasMatch(input);
}

String errorMessage(dynamic error) {
  if (error is ApiException) {
    String message = error.message;
    String prefix = '';

    final regex = RegExp(r'^(\d+::)(.*)');
    final match = regex.firstMatch(message);
    if (match != null) {
      prefix = match.group(1)!;
      message = match.group(2)!;
    }

    if (_isSnakeCase(message)) {
      return '$prefix${'error.$message'.tr()}';
    } else {
      return error.message;
    }
  } else {
    return errorSomethingWentWrong;
  }
}

class ErrorMessage {
  static String noRecords() {
    return 'error.no_records'.tr();
  }

  static String fieldNotFound(String fieldName) {
    return 'error.field_not_found'.tr(namedArgs: {'data': fieldName});
  }

  static String fieldRequired(String fieldName) {
    return 'error.field_required'.tr(namedArgs: {'data': fieldName});
  }

  static String requiredAtLeastOne(String fieldName) {
    return 'error.required_at_least_one'.tr(namedArgs: {'data': fieldName});
  }
}
