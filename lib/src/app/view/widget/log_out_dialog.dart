import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';

Future<bool?> showDialogLogout({
  required BuildContext context,
}) async {
  return showDialog<bool?>(
    context: context,
    builder: (context) {
      return CardForm(
        popup: true,
        title: 'logout'.tr(),
        icon: FontAwesomeIcons.triangleExclamation,
        actions: [
          Button(
            isSecondary: true,
            action: DataAction.cancel,
            onPressed: () => Navigator.pop(context),
            permission: null,
          ),
          const SizedBox(width: 10),
          Button(
            permission: null,
            action: DataAction.logout,
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
        child: Text('confirm_logout'.tr()),
      );
    },
  );
}
