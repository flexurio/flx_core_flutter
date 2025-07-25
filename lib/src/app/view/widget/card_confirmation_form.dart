import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/model/data_action.dart';
import 'package:flx_core_flutter/src/app/model/entity.dart';
import 'package:flx_core_flutter/src/app/model/string.dart';
import 'package:flx_core_flutter/src/app/view/widget/button.dart';
import 'package:flx_core_flutter/src/app/view/widget/popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class CardConfirmationForm extends StatefulWidget {
  const CardConfirmationForm({
    required this.isProgress,
    required this.action,
    required this.data,
    required this.label,
    required this.onConfirm,
    required this.children,
    this.title,
    super.key,
  });

  final String? title;
  final bool isProgress;
  final DataAction action;
  final Entity data;
  final String label;
  final List<Widget> children;
  final void Function() onConfirm;

  @override
  State<CardConfirmationForm> createState() => _CardConfirmationFormState();
}

class _CardConfirmationFormState extends State<CardConfirmationForm> {
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final explanationTitle = widget.title ?? 'Form';

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction, // Optional
      child: CardForm(
        popup: true,
        title: 'are_you_sure'.tr(),
        icon: FontAwesomeIcons.exclamationTriangle,
        actions: [
          Button.action(
            permission: null,
            isSecondary: true,
            isInProgress: widget.isProgress,
            onPressed: () => Navigator.pop(context),
            action: DataAction.cancel,
          ),
          const SizedBox(width: 10),
          Button.action(
            permission: null,
            color: primaryColor,
            isInProgress: widget.isProgress,
            onPressed: _submit,
            action: widget.action,
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              confirmationMessage(
                widget.data,
                widget.action.title,
                widget.label,
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(24),
            ...widget.children,
            const Gap(3),
            Text(
              'Please provide ${explanationTitle.toLowerCase()} for '
              '${widget.action.title}.',
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
