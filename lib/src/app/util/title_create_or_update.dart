import 'package:flexurio_erp_core/flexurio_erp_core.dart';

DataAction createOrEdit(dynamic data) {
  return data == null ? DataAction.create : DataAction.edit;
}
