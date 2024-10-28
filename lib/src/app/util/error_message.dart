import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';

String errorMessage(dynamic error) {
  if (error is ApiException) {
    return 'error.${error.message}'.tr();
  } else {
    return errorSomethingWentWrong;
  }
}

class ErrorMessage {
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
