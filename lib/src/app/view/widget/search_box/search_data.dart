import 'package:flutter_bloc/flutter_bloc.dart';

class SearchData<T> {
  SearchData({
    required this.bloc,
    required this.text,
    required this.group,
  });

  final Bloc bloc;
  final String Function(T) text;
  final String group;
}
