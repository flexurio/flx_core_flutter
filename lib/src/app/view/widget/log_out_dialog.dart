import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

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
              Navigator.pop(context, true);
            },
          ),
        ],
        child: Text('confirm_logout'.tr()),
      );
    },
  );
}
