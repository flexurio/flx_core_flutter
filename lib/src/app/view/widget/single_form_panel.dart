import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SingleFormPanel extends StatelessWidget {
  const SingleFormPanel({
    required this.children,
    required this.action,
    required this.entity,
    super.key,
    this.actions,
    this.suffixText = '',
    this.formKey,
    this.hideHeader = false,
    this.visibleBackButton = true,
    this.size = SingleFormPanelSize.normal,
    this.padding,
  });

  final DataAction action;
  final EntityY entity;
  final List<Widget> children;
  final List<Widget>? actions;
  final Key? formKey;
  final String suffixText;
  final bool visibleBackButton;
  final SingleFormPanelSize size;
  final bool hideHeader;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: hideHeader ? 0 : 24),
          width: size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Material(
              color: theme.modeCondition(
                theme.scaffoldBackgroundColor.darken(.03),
                theme.cardColor.lighten(.04),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!hideHeader) _buildHeader(),
                  if (padding == null)
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                    ),
                  ColoredBox(
                    color: theme.cardColor,
                    child: Column(
                      children: [
                        Padding(
                          padding: padding ??
                              const EdgeInsets.symmetric(horizontal: 24),
                          child: FormAction(
                            formKey: formKey,
                            actions: actions,
                            children: children,
                          ),
                        ),
                        const Gap(36),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 24,
      ),
      child: BackButtonWithTitle(
        title: '${action.title} ${entity.title} $suffixText',
        visibleBackButton: visibleBackButton,
      ),
    );
  }
}

class FormAction extends StatelessWidget {
  const FormAction({
    required this.children,
    super.key,
    this.formKey,
    this.actions,
    this.isProgress = false,
  });

  final bool isProgress;
  final Key? formKey;
  final List<Widget> children;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...children,
              if (actions != null)
                Padding(
                  padding: const EdgeInsets.only(top: 36),
                  child: RowFields(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
        if (isProgress)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}

enum SingleFormPanelSize {
  normal(600),
  large(900),
  extraLarge(1200);

  const SingleFormPanelSize(this.width);
  final double width;
}
