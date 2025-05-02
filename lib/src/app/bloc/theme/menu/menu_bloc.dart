import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/widget/keyboard_shortcut_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    String? logoUrl,
    String? logoNamedUrl,
  }) : super(
          MenuState(
            label: 'Home',
            menu2Expanded: '',
            menu3Selected: '',
            home: ContentWithRightPanel(
              rightPanel: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: KeyboardShortcutInfo(),
              ),
              child: Opacity(
                opacity: 0.2,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter: const ColorFilter.matrix(<double>[
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0,
                          0,
                          0,
                          1,
                          0,
                        ]),
                        child: LogoNamed(
                          height: 70,
                          logoUrl: logoUrl,
                          logoNamedUrl: logoNamedUrl,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            triggerCloseDrawer: false,
          ),
        ) {
    on<Menu2Expanded>((event, emit) {
      emit(state.copyWith(menu2Expanded: event.key, triggerCloseDrawer: false));
    });
    on<Menu3Selected>((event, emit) {
      emit(
        state.copyWith(
          home: event.home,
          label: event.label,
          triggerCloseDrawer: true,
        ),
      );
    });
  }
  static MenuBloc instance = MenuBloc();
}
