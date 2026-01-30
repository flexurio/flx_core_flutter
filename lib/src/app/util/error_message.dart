import 'package:easy_localization/easy_localization.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

bool _isSnakeCase(String input) {
  final regex = RegExp(r'^[a-z]+(_[a-z]+)*$');
  return regex.hasMatch(input);
}

String errorMessage(dynamic error) {
  if (error is ApiException) {
    if (_isSnakeCase(error.message)) {
      return 'error.${error.message}'.tr();
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
