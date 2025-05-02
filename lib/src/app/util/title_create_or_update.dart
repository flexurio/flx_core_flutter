import 'package:flx_core_flutter/flx_core_flutter.dart';

DataAction createOrEdit(dynamic data) {
  return data == null ? DataAction.create : DataAction.edit;
}
