import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/menu_collapse/menu_collapse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screen_identifier/screen_identifier.dart';

class ToggleSideNav extends StatelessWidget {
  const ToggleSideNav({
    required this.isCollapsed,
    required this.noCollapse,
    super.key,
  });

  final bool isCollapsed;
  final bool noCollapse;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ScreenIdentifierBuilder(
            builder: (context, screenIdentifier) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: isCollapsed
                    ? const Logo()
                    : Row(
                        children: [
                          const LogoNamed(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 6,
                              bottom: 6,
                              top: 6,
                            ),
                          ),
                          if (!noCollapse)
                            screenIdentifier.conditions(
                              md: const SizedBox(),
                              lg: const _ButtonToggle(),
                            ),
                        ],
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ButtonToggle extends StatelessWidget {
  const _ButtonToggle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<MenuCollapseBloc, bool>(
      builder: (context, collapsed) {
        final action = collapsed ? 'show' : 'hide';
        final hideIcon = SvgPicture.asset(
          'asset/svg/sidebar-$action.svg',
          height: 20,
          colorFilter: ColorFilter.mode(
            theme.modeCondition<Color>(
              theme.iconTheme.color!.lighten(0.45),
              theme.iconTheme.color!,
            ),
            BlendMode.srcATop,
          ),
        );
        return IconButton(
          tooltip: '${action}_sidebar'.tr(),
          onPressed: () {
            context.read<MenuCollapseBloc>().add(!collapsed);
          },
          icon: hideIcon,
        );
      },
    );
  }
}
