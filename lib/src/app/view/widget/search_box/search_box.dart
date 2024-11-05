import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/menu/menu_bloc.dart';
import 'package:flexurio_erp_core/src/app/view/widget/search_box/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SearchBoxLarge extends StatelessWidget {
  const SearchBoxLarge({
    required this.menu,
    required this.permissions,
    required this.searchData,
    super.key,
  });

  final List<Menu1> menu;
  final List<String> permissions;
  final List<Widget> Function(String query) searchData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Material(
        color: Colors.black12,
        child: InkWell(
          onTap: () {
            showSearchDialog(
              context: context,
              menu: menu,
              accountPermissions: permissions,
              searchData: searchData,
            );
          },
          child: Container(
            height: 50,
            color: theme.scaffoldBackgroundColor.darken(.08),
            padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontalPage,
            ),
            child: Row(
              children: [
                const Icon(Icons.search),
                const Gap(12),
                Text('${'search'.tr()} ...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showSearchDialog({
  required BuildContext context,
  required List<Menu1> menu,
  required List<String> accountPermissions,
  required List<Widget> Function(String query) searchData,
}) {
  final menuBloc = context.read<MenuBloc>();
  return showDialog<void>(
    context: context,
    builder: (context) {
      return SearchDialog(
        searchData: searchData,
        menu: menu,
        permissions: accountPermissions,
        onTap: (menu, menu2) {
          menuBloc
            ..add(Menu2Expanded(menu2))
            ..add(
              Menu3Selected(
                home: menu.home,
                label: menu.label,
              ),
            );
          Navigator.pop(context);
        },
      );
    },
  );
}

class SearchIntent extends Intent {}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    this.onChanged,
  });
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: '${'type_here_to_search'.tr()} ...',
          hintStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color
                ?.withOpacity(theme.modeCondition(.7, .3)),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
