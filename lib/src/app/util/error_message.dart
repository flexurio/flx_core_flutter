import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';

String errorMessage(dynamic error) {
  if (error is ApiException) {
    return 'error.${error.message}'.tr();
  } else {
    return errorSomethingWentWrong;
  }
}
