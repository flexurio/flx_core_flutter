import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardForm extends StatelessWidget {
  const CardForm({
    required this.title,
    required this.icon,
    required this.actions,
    required this.child,
    super.key,
    this.popup = false,
    this.danger = false,
  });
  final String title;
  final IconData icon;
  final Widget child;
  final List<Widget> actions;
  final bool popup;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: danger ? Colors.white : null,
                    ),
                  ),
                  const Spacer(),
                  Icon(icon, color: danger ? Colors.white : Color(0XFFAFABBC)),
                ],
              ),
              const SizedBox(height: 20),
              DefaultTextStyle(
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  color: danger ? Colors.red.shade50 : null,
                ),
                child: child,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: danger
                ? Colors.red.shade100
                : (theme.isDark
                    ? const Color.fromARGB(255, 81, 81, 82)
                    : const Color(0XFFF8F7FB)),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions,
          ),
        ),
      ],
    );

    if (popup) {
      const borderRadiusCard = 20.0;
      return SimpleDialog(
        backgroundColor: danger ? Colors.red : theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusCard),
        ),
        contentPadding: EdgeInsets.zero,
        children: [body],
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: body,
      );
    }
  }
}

class CardConfirmation extends StatelessWidget {
  const CardConfirmation({
    required this.isProgress,
    required this.action,
    required this.data,
    required this.onConfirm,
    super.key,
    this.label,
    this.danger = false,
  });

  final bool isProgress;
  final DataAction action;
  final Entity data;
  final String? label;
  final bool danger;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    Sound.alert();
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return CardForm(
      popup: true,
      danger: danger,
      title: 'are_you_sure'.tr(),
      icon: FontAwesomeIcons.exclamationTriangle,
      actions: [
        Button(
          permission: null,
          isSecondary: true,
          isInProgress: isProgress,
          onPressed: () {
            Navigator.pop(context);
          },
          action: DataAction.cancel,
        ),
        const SizedBox(width: 10),
        Button(
          permission: null,
          color:
              action == DataAction.delete || danger ? Colors.red : primaryColor,
          isInProgress: isProgress,
          onPressed: onConfirm,
          action: action,
        ),
      ],
      child: Text(confirmationMessage(data, action, label)),
    );
  }
}

class CardConfirmationAnyAction extends StatelessWidget {
  const CardConfirmationAnyAction({
    required this.isProgress,
    required this.actionOne,
    required this.actionTwo,
    required this.data,
    required this.onActionOne,
    required this.onConfirm,
    super.key,
    this.label,
  });

  final bool isProgress;
  final DataAction actionTwo;
  final Entity data;
  final DataAction actionOne;
  final String? label;
  final void Function() onActionOne;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    Sound.alert();
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return CardForm(
      popup: true,
      title: 'are_you_sure'.tr(),
      icon: FontAwesomeIcons.exclamationTriangle,
      actions: [
        Button(
          permission: null,
          isSecondary: true,
          isInProgress: isProgress,
          onPressed: () {
            Navigator.pop(context);
          },
          action: DataAction.cancel,
        ),
        const SizedBox(width: 10),
        Button(
          permission: null,
          isSecondary: true,
          isInProgress: isProgress,
          onPressed: onActionOne.call,
          action: actionOne,
        ),
        const SizedBox(width: 10),
        Button(
          permission: null,
          color: actionTwo == DataAction.delete ? Colors.red : primaryColor,
          isInProgress: isProgress,
          onPressed: onConfirm,
          action: actionTwo,
        ),
      ],
      child: Text(confirmationMessage(data, actionTwo, label)),
    );
  }
}

class CardSuccessInfo extends StatelessWidget {
  const CardSuccessInfo({
    required this.isProgress,
    required this.action,
    required this.data,
    super.key,
    this.label,
  });

  final bool isProgress;
  final DataAction action;
  final Entity data;
  final String? label;

  @override
  Widget build(BuildContext context) {
    Sound.alert();
    return CardForm(
      popup: true,
      title: 'information'.tr(),
      icon: FontAwesomeIcons.info,
      actions: [
        Button(
          permission: null,
          isSecondary: true,
          isInProgress: isProgress,
          onPressed: () {
            Navigator.pop(context);
          },
          action: DataAction.confirm,
        ),
      ],
      child: Text(informationMessage(data, action, label)),
    );
  }
}

class CardConfirmationWithExplanation extends StatefulWidget {
  const CardConfirmationWithExplanation({
    required this.isProgress,
    required this.action,
    required this.data,
    required this.label,
    required this.onConfirm,
    this.title,
    super.key,
  });

  final String? title;
  final bool isProgress;
  final DataAction action;
  final Entity data;
  final String label;
  final void Function(String reason) onConfirm;

  @override
  State<CardConfirmationWithExplanation> createState() =>
      _CardConfirmationWithExplanationState();
}

class _CardConfirmationWithExplanationState
    extends State<CardConfirmationWithExplanation> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirm(_reasonController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final title = widget.title ?? 'Explanation';
    return Form(
      key: _formKey,
      child: CardForm(
        popup: true,
        title: 'are_you_sure'.tr(),
        icon: FontAwesomeIcons.exclamationTriangle,
        actions: [
          Button(
            permission: null,
            isSecondary: true,
            isInProgress: widget.isProgress,
            onPressed: () {
              Navigator.pop(context);
            },
            action: DataAction.cancel,
          ),
          const SizedBox(width: 10),
          Button(
            permission: null,
            color: widget.action.title.toLowerCase().contains('delete') ||
                    widget.action.title.toLowerCase().contains('reject')
                ? Colors.red
                : primaryColor,
            isInProgress: widget.isProgress,
            onPressed: _submit,
            action: widget.action,
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(confirmationMessage(widget.data, widget.action, widget.label)),
            const Gap(24),
            FTextFormField(
              maxLength: 100,
              controller: _reasonController,
              labelText: title,
              maxLines: widget.title != null ? 1 : 3,
              validator: requiredValidator.call,
              showCounter: true,
            ),
            const Gap(3),
            Text(
              'Please provide ${title.toLowerCase()} for '
              '${widget.action.title}.',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
