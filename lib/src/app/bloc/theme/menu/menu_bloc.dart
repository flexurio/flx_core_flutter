import 'package:flexurio_erp_core/src/app/view/widget/keyboard_shortcut_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc()
      : super(
          const MenuState(
            label: 'Home',
            menu2Expanded: '',
            menu3Selected: '',
            home: Center(
              child: KeyboardShortcutInfo(),
            ),
          ),
        ) {
    on<Menu2Expanded>((event, emit) {
      emit(state.copyWith(menu2Expanded: event.key));
    });
    on<Menu3Selected>((event, emit) {
      emit(
        state.copyWith(
          home: event.home,
          label: event.label,
        ),
      );
    });
  }
}
