import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/model/page_options.dart';
import 'package:gap/gap.dart';

class PaginationControl<T> extends StatelessWidget {
  const PaginationControl({
    required this.pageOptions,
    required this.changePage,
    super.key,
  });
  final PageOptions<T> pageOptions;
  final void Function(int) changePage;

  @override
  Widget build(BuildContext context) {
    final currentPage = pageOptions.page;
    final totalPage = pageOptions.lastPage;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        children: [
          Text(pageOptions.info),
          const Spacer(),
          _buildIconButton(
            context: context,
            icon: const Icon(Icons.first_page_rounded),
            onPressed: () => changePage(1),
          ),
          const Gap(6),
          _buildIconButton(
            context: context,
            icon: const Icon(Icons.keyboard_arrow_left_rounded),
            onPressed: pageOptions.page > 1
                ? () => changePage(pageOptions.page - 1)
                : null,
          ),
          const Gap(6),
          Text(
            '$currentPage / $totalPage',
            style: const TextStyle(color: Color(0xff849198)),
          ),
          const Gap(6),
          _buildIconButton(
            context: context,
            icon: const Icon(Icons.keyboard_arrow_right_rounded),
            onPressed: pageOptions.page < pageOptions.lastPage
                ? () => changePage(pageOptions.page + 1)
                : null,
          ),
          const Gap(6),
          _buildIconButton(
            context: context,
            icon: const Icon(Icons.last_page_rounded),
            onPressed: () => changePage(pageOptions.lastPage),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context,
    required Widget icon,
    required VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.modeCondition(
              Colors.grey.shade300.withOpacity(.8),
              Colors.white12,
            ),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(
              size: 18,
              color: theme.modeCondition(
                isDisabled ? Colors.grey : Colors.blueGrey.shade700,
                isDisabled ? Colors.white12 : Colors.grey,
              ),
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
