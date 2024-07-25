import 'package:hydrated_bloc/hydrated_bloc.dart';

class MenuCollapseBloc extends HydratedBloc<bool, bool> {
  MenuCollapseBloc() : super(true) {
    on<bool>((event, emit) {
      emit(event);
    });
  }

  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json['value'] as bool;
  }

  @override
  Map<String, dynamic> toJson(bool state) {
    return {'value': state};
  }
}
