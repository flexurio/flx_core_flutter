import 'package:flexurio_erp_core/src/app/model/data_action.dart';
import 'package:flexurio_erp_core/src/app/model/page_options.dart';
import 'package:flexurio_erp_core/src/app/view/widget/button.dart';
import 'package:flexurio_erp_core/src/app/view/widget/f_drop_down.dart';
import 'package:flexurio_erp_core/src/app/view/widget/search_box/search_box_x.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:screen_identifier/screen_identifier.dart';

class DataSetAction<T> extends StatelessWidget {
  const DataSetAction({
    required this.child,
    required this.actionLeft,
    required this.actionRight,
    required this.status,
    required this.onRefresh,
    required this.pageOptions,
    required this.onChanged,
    super.key,
  });

  final Widget child;
  final Status? status;
  final VoidCallback? onRefresh;
  final List<Widget> actionLeft;
  final List<Widget> Function(Widget) actionRight;
  final void Function(PageOptions<T> pageOptions) onChanged;
  final PageOptions<T> pageOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenIdentifierBuilder(
          builder: (context, screenIdentifier) {
            return screenIdentifier.conditions(
              sm: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [_buildActionRight()],
                  ),
                  if (actionLeft.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(children: [_buildActionLeft()]),
                    ),
                ],
              ),
              md: Row(
                children: [
                  _buildActionLeft(),
                  Expanded(child: _buildActionRight()),
                ],
              ),
            );
          },
        ),
        const Gap(12),
        Align(alignment: Alignment.centerRight, child: _buildSearchBox()),
        const Gap(24),
        child,
      ],
    );
  }

  Widget _buildActionLeft() {
    return Wrap(spacing: 12, children: actionLeft);
  }

  Widget _buildActionRight() {
    return Wrap(
      spacing: 12,
      crossAxisAlignment: WrapCrossAlignment.end,
      runAlignment: WrapAlignment.end,
      alignment: WrapAlignment.end,
      children: actionRight(
        LightButtonSmall(
          permission: null,
          status: status,
          action: DataAction.refresh,
          onPressed: onRefresh,
        ),
      )
          .map(
            (e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [e],
            ),
          )
          .toList(),
    );
  }

  Widget _buildSearchBox() {
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        return SizedBox(
          width: screenIdentifier.conditions(sm: true, md: false) ? null : 300,
          child: SearchBoxX(
            onSubmitted: _searchBoxOnChange,
            initial: pageOptions.search,
          ),
        );
      },
    );
  }

  void _searchBoxOnChange(String value) {
    onChanged(pageOptions.copyWith(search: value, data: []));
  }
}
