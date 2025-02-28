import 'package:flexurio_erp_core/src/app/model/page_options.dart';
import 'package:flexurio_erp_core/src/app/view/widget/data_set_action.dart';
import 'package:flexurio_erp_core/src/app/view/widget/f_drop_down.dart';
import 'package:flutter/material.dart';

class DataListView<T> extends StatelessWidget {
  const DataListView({
    required this.status,
    required this.pageOptions,
    required this.builder,
    required this.onRefresh,
    required this.actionRight,
    required this.onChanged,
    required this.actionLeft,
    super.key,
  });

  final Status status;
  final PageOptions<T> pageOptions;
  final Widget Function(T data) builder;
  final void Function() onRefresh;
  final List<Widget> Function(Widget refreshButton) actionRight;
  final void Function(PageOptions<T> pageOptions) onChanged;
  final List<Widget> actionLeft;

  @override
  Widget build(BuildContext context) {
    return DataSetAction(
      onChanged: onChanged,
      pageOptions: pageOptions,
      actionLeft: actionLeft,
      actionRight: actionRight,
      onRefresh: onRefresh,
      status: status,
      child: Column(
        children: pageOptions.data.map(builder).toList(),
      ),
    );
  }
}

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: title,
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}
