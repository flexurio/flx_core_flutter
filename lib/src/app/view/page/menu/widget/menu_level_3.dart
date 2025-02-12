import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuLevel3 extends StatelessWidget {
  const MenuLevel3({
    required this.menu3,
    required this.isCollapsed,
    super.key,
  });

  final Menu3 menu3;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(6);
    final theme = Theme.of(context);
    return BlocBuilder<MenuBloc, MenuState>(
      bloc: MenuBloc.instance,
      builder: (context, state) {
        final isSelected = menu3.label == state.label;
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 52, right: 24),
                child: InkWell(
                  borderRadius: borderRadius,
                  onTap: () {
                    MenuBloc.instance.add(
                      Menu3Selected(
                        home: menu3.home,
                        label: menu3.label,
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: isSelected
                        ? BoxDecoration(
                            borderRadius: borderRadius,
                            color: theme.modeCondition(
                              theme.colorScheme.primary.lighten(.33),
                              theme.colorScheme.primary.darken(.1),
                            ),
                          )
                        : null,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      menu3.label.tr(),
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : null,
                        color: isSelected
                            ? theme.modeCondition(
                                theme.colorScheme.primary,
                                theme.cardColor,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
