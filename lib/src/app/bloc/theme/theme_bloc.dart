import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeBloc extends HydratedBloc<ThemeMode, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ThemeMode>((event, emit) async {
      emit(event);
    });
  }

  static ThemeBloc instance = ThemeBloc();

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final theme = json['theme'] as String;
    if (theme == 'dark') {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) =>
      {'theme': state == ThemeMode.dark ? 'dark' : 'light'};
}
