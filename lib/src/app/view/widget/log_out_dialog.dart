import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';

Future<bool?> showDialogLogout({
  required BuildContext context,
  required void Function() onLogout,
}) async {
  return showDialog<bool?>(
    context: context,
    builder: (context) {
      return CardForm(
        popup: true,
        title: 'logout'.tr(),
        icon: FontAwesomeIcons.triangleExclamation,
        actions: [
          Button.action(
            isSecondary: true,
            action: DataAction.cancel,
            onPressed: () => Navigator.pop(context),
            permission: null,
          ),
          const SizedBox(width: 10),
          Button.action(
            permission: null,
            action: DataAction.logout,
            onPressed: () {
              onLogout();
              Navigator.pop(context);
            },
          ),
        ],
        child: Text('confirm_logout'.tr()),
      );
    },
  );
}
