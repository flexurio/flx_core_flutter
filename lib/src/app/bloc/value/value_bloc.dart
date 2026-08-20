import 'package:flutter_bloc/flutter_bloc.dart';

class ValueBloc<T> extends Bloc<T, T> {
  ValueBloc(super.initialState) {
    on<T>((event, emit) {
      emit(event);
    });
  }
}
