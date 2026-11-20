import 'package:hydrated_bloc/hydrated_bloc.dart';

enum SidebarMenuDisplay {
  iconsAndLabels,
  iconsOnly;

  String get label {
    switch (this) {
      case SidebarMenuDisplay.iconsAndLabels:
        return 'Icons & Labels';
      case SidebarMenuDisplay.iconsOnly:
        return 'Icons Only';
    }
  }

  String get description {
    switch (this) {
      case SidebarMenuDisplay.iconsAndLabels:
        return 'Display menu names along with their icons in the sidebar '
            '(Default)';
      case SidebarMenuDisplay.iconsOnly:
        return 'Display only icons in the sidebar';
    }
  }

  bool get showMenuName => this == SidebarMenuDisplay.iconsAndLabels;
}

class SidebarMenuDisplayBloc
    extends HydratedBloc<SidebarMenuDisplay, SidebarMenuDisplay> {
  SidebarMenuDisplayBloc([
    super.initial = SidebarMenuDisplay.iconsAndLabels,
  ]) {
    on<SidebarMenuDisplay>((event, emit) {
      emit(event);
    });
  }

  static SidebarMenuDisplayBloc? _instance;
  // ignore: prefer_constructors_over_static_methods
  static SidebarMenuDisplayBloc get instance =>
      _instance ??= SidebarMenuDisplayBloc();
  static set instance(SidebarMenuDisplayBloc bloc) => _instance = bloc;

  @override
  SidebarMenuDisplay? fromJson(Map<String, dynamic> json) {
    try {
      final value = json['value'] as String?;
      if (value == 'iconsOnly') {
        return SidebarMenuDisplay.iconsOnly;
      }
      return SidebarMenuDisplay.iconsAndLabels;
    } catch (_) {
      return SidebarMenuDisplay.iconsAndLabels;
    }
  }

  @override
  Map<String, dynamic>? toJson(SidebarMenuDisplay state) {
    return {'value': state.name};
  }
}
