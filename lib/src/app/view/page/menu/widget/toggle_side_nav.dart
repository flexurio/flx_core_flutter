import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/bloc/theme/menu_collapse/menu_collapse.dart';
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
                            logoUrl:
                                'https://scontent-cgk1-2.xx.fbcdn.net/v/t39.30808-6/243458652_156392403347958_2075563044658297133_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFUVPG8coJjmc35mpc1Wm6I9p-t9bBMU5b2n631sExTlnv6AdsJLJwkAhu1Oum5zfBt3dbjtv6Wcwxr1NH4AqRF&_nc_ohc=mY3VgVr0Z9IQ7kNvgFfvDKJ&_nc_zt=23&_nc_ht=scontent-cgk1-2.xx&_nc_gid=ApVjrXN4aHfpWib3Zc4Aias&oh=00_AYBS62E21PxJ58IN_B7sOBfb0KCOPRd60IxVZMO8Cd2rTQ&oe=67A5E24D',
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
