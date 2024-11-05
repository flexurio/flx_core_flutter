import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/view/widget/keyboard_shortcut_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  static MenuBloc instance = MenuBloc();
  MenuBloc()
      : super(
          const MenuState(
            label: 'Home',
            menu2Expanded: '',
            menu3Selected: '',
            home: ContentWithRightPanel(
              rightPanel: Padding(
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
                        colorFilter: ColorFilter.matrix(<double>[
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
}
