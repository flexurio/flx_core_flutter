import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/model/data_action.dart';
import 'package:flx_core_flutter/src/app/model/entity.dart';
import 'package:flx_core_flutter/src/app/model/string.dart';
import 'package:flx_core_flutter/src/app/view/widget/button.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_text_form_field.dart';
import 'package:flx_core_flutter/src/app/view/widget/popup.dart';
import 'package:gap/gap.dart';

class CardConfirmationReason extends StatefulWidget {
  const CardConfirmationReason({
    required this.isProgress,
    required this.action,
    required this.data,
    required this.label,
    required this.onConfirm,
    this.title,
    this.reasonLabel,
    this.hintText,
    this.danger = false,
    super.key,
  });

  final bool isProgress;
  final DataAction action;
  final Entity data;
  final String label;
  final String? title;
  final String? reasonLabel;
  final String? hintText;
  final bool danger;
  final void Function(String reason) onConfirm;

  @override
  State<CardConfirmationReason> createState() => _CardConfirmationReasonState();
}

class _CardConfirmationReasonState extends State<CardConfirmationReason> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirm(_reasonController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.danger || widget.action == DataAction.reject
        ? Colors.red
        : theme.colorScheme.primary;
    final titleText = widget.title ?? 'are_you_sure'.tr();

    return Form(
      key: _formKey,
      child: CardForm(
        popup: true,
        danger: widget.danger,
        title: titleText,
        icon: Icons.warning_amber_rounded,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              confirmationMessage(
                widget.data,
                widget.action.title,
                widget.label,
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(16),
            FTextFormField(
              controller: _reasonController,
              labelText: widget.reasonLabel ?? 'reason'.tr(),
              hintText: widget.hintText ?? 'input_reason'.tr(),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'field_required'.tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
