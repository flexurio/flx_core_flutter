import 'package:easy_localization/easy_localization.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

const applicationName = 'Chiron ERP';

const errorSomethingWentWrong = 'Oops! something went wrong';
const errorInvalidPhonePassword = 'Invalid phone number or password';

const errorUnauthorized = 'ERROR_UNAUTHORIZED';
const errorInternalServer = 'ERROR_INTERNAL_SERVER';
const errorConnectionRefused = 'ERROR_CONNECTION_REFUSED';

const pleaseWait = 'Please Wait...';
const pleaseFillOutThisField = 'error.field_required';

@Deprecated('use `confirmationMessage(...)` ')
const deleteConfirmationMessageOld =
    'Do you really to delete these records?\nThis process '
    'cannot be undone.';

@Deprecated('use `confirmationMessage(...)` ')
const confirmationMessageOld =
    'Do you really to confirm these records?\nThis process '
    'cannot be undone.';

const errorNameValidator = 'Name can only contain letters and spaces';
const errorEmailValidator = 'Enter a valid email address';
const errorPostalCodeValidator = 'Postal Code must be 5 digits';
const errorFaxValidator = 'Fax must be in the format of XXX-XXX XXXX';
const errorNpwpValidator = 'NPWP must be in the format of XX.XXX.XXX.X-XYY.ZZZ';
const errorPhoneValidator = 'Please enter a valid phone number 62XXXXXXXXXXX';
const errorQuantityValidator = 'Quantity can only contain numbers';
const errorOnlyNumberValidator = 'Input Field can only contain numbers';

String confirmationMessage(Entity data, String action, String? label) {
  var text = 'are_you_really_to'
      .tr(namedArgs: {'action': action, 'data': data.id.tr()});
  if (label != null) {
    text += ' $label';
  }
  text += '?';
  if (action == DataAction.delete.title) {
    text += '\n${'cannot_be_undone'.tr()}.';
  }
  return text;
}

String informationMessage(Entity data, DataAction action, String? label) {
  var text = 'you_have_successfully'
      .tr(namedArgs: {'action': action.title, 'data': data.id.tr()});
  if (label != null) {
    text += ' $label.';
  }
  return text;
}
