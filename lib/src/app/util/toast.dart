import 'package:animated_check/animated_check.dart';
import 'package:animated_cross/animated_cross.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class Message {
  static String successCreated(Entity data) =>
      'Success! The new ${data.id.tr()} has been created and added to the database.';

  static String successUpdated(Entity data) =>
      'Success! The ${data.id.tr()} information has been successfully updated.';

  static String successDeleted(Entity data) =>
      'Success! The ${data.id.tr()} has been deleted from the database.';
}

class Toast {
  Toast(BuildContext context) : _toast = FToast().init(context);
  final FToast _toast;

  /// Shows a success toast with the given [message].
  ///
  /// The toast will be displayed for 3 seconds.
  void success(String message) {
    // Sound.success();
    _toast
      ..removeCustomToast()
      ..showToast(
        child: ToastSuccess(message: message),
        fadeDuration: const Duration(milliseconds: 200),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
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
    _toast
      ..removeCustomToast()
      ..showToast(
        child: ToastFail(message: message),
        fadeDuration: const Duration(milliseconds: 200),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 7),
      );
  }

  void notify(String message) {
    _toast
      ..removeCustomToast()
      ..showToast(
        child: ToastNotify(message: message),
        fadeDuration: const Duration(milliseconds: 200),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 1),
      );
  }
}

class ToastSuccess extends StatefulWidget {
  const ToastSuccess({
    required this.message,
    super.key,
  });
  final String message;

  @override
  State<ToastSuccess> createState() => _ToastSuccessState();
}

class _ToastSuccessState extends State<ToastSuccess>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCirc,
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.greenAccent[200],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCheck(
            progress: _animation,
            color: Colors.black,
            size: 40,
          ),
          const Gap(6),
          Flexible(
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class ToastNotify extends StatelessWidget {
  const ToastNotify({
    required this.message,
    super.key,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.black.withOpacity(.7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ToastFail extends StatefulWidget {
  const ToastFail({
    required this.message,
    super.key,
  });
  final String message;

  @override
  State<ToastFail> createState() => _ToastFailState();
}

class _ToastFailState extends State<ToastFail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCirc,
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.redAccent[100],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCross(
            progress: _animation,
            color: Colors.black,
            size: 40,
          ),
          const Gap(6),
          Text(
            widget.message,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
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
