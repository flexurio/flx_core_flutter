import 'package:flexurio_erp_core/flexurio_erp_core.dart';

String errorMessage(dynamic error) {
  if (error is ApiException) {
    return error.message;
  } else {
    return errorSomethingWentWrong;
  }
}
