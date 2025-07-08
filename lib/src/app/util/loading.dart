import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> dialogLoadingBloc<T extends BlocBase<S>, S>({
  required BuildContext context,
  required T bloc,
  required void Function(BuildContext context, S state) listener,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => BlocProvider<T>.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          return BlocListener<T, S>(
            listener: listener,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    ),
  );
}
