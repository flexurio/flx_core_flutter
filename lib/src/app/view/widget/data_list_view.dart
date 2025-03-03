import 'package:flexurio_erp_core/src/app/model/page_options.dart';
import 'package:flexurio_erp_core/src/app/view/widget/data_set_action.dart';
import 'package:flexurio_erp_core/src/app/view/widget/f_drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    final children = pageOptions.data.map(builder).toList();
    if (children.length == pageOptions.rowsPerPage) {
      children.add(const LoadMore());
    }
    return DataSetAction(
      onChanged: onChanged,
      pageOptions: pageOptions,
      actionLeft: actionLeft,
      actionRight: actionRight,
      onRefresh: onRefresh,
      status: status,
      child: Column(children: children),
    );
  }
}

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(title: title, subtitle: subtitle, trailing: trailing),
      ),
    );
  }
}

class LoadMore extends StatelessWidget {
  const LoadMore({super.key});

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          print("object");
        }
      },
      child: CupertinoActivityIndicator(),
    );
  }
}
