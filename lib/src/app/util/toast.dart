import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:toastification/toastification.dart';

class Message {
  static String successCreated(Entity data) =>
      'Success! The new ${data.id.tr()} has been created and added to the '
      'database.';

  static String successUpdated(Entity data) =>
      'Success! The ${data.id.tr()} information has been successfully updated.';

  static String successDeleted(Entity data) =>
      'Success! The ${data.id.tr()} has been deleted from the database.';
}

class Toast {
  Toast(this.context);
  final BuildContext context;

  void success(String message) {
    // Sound.success();
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 7),
    );
  }

  void dataChanged(DataAction action, Entity data) {
    if (action == DataAction.create) {
      success(Message.successCreated(data));
    } else if (action == DataAction.delete) {
      success(Message.successDeleted(data));
    } else {
      success(Message.successUpdated(data));
    }
  }

  void fail(String message) {
    // Sound.fail();
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 10),
    );
  }

  void notify(String message) {
    toastification.show(
      applyBlurEffect: true,
      context: context,
      title: Text(message),
      type: ToastificationType.info,
      style: ToastificationStyle.simple,
      backgroundColor: Colors.black.withOpacity(.7),
      foregroundColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}

class ToastRepository {
  static void errorRequiredAtLeastOne({
    required BuildContext context,
    required String data,
  }) {
    Toast(context)
        .fail('error.required_at_least_one'.tr(namedArgs: {'data': data.tr()}));
  }

  static void errorMustBeGreaterThanZero({
    required BuildContext context,
    required String data,
  }) {
    Toast(context).fail(
      'error.must_be_greater_than_zero'.tr(namedArgs: {'data': data.tr()}),
    );
  }
}

Future<void> showSuccessWithId({
  required BuildContext context,
  required Entity entity,
  required String id,
}) async {
  final textStyle = Theme.of(context).textTheme.bodyLarge;
  await showDialog<bool?>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return CardForm(
        popup: true,
        title: 'Success',
        icon: Icons.check,
        actions: [
          Button(
            action: DataAction.close,
            permission: null,
            isSecondary: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'The ${entity.id.tr()} has been created!\nwith ID: ',
                    style: textStyle,
                  ),
                  TextSpan(
                    text: id,
                    style: textStyle!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            LightButton(
              action: DataAction.copyId,
              permission: null,
              onPressed: () {
                FlutterClipboard.copy(id).then(
                  (value) => Toast(context).notify('Copied to clipboard'),
                );
              },
            ).pullRight(),
          ],
        ),
      );
    },
  );
}
