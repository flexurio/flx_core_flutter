import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';

class SearchBoxX extends StatefulWidget {
  const SearchBoxX({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.autoFocus = false,
    this.initial,
  });
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? initial;
  final bool autoFocus;

  @override
  State<SearchBoxX> createState() => _SearchBoxXState();
}

class _SearchBoxXState extends State<SearchBoxX> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initial ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 12, top: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.modeCondition(
            Colors.grey.shade300,
            Colors.grey.shade800,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        color: theme.modeCondition(Colors.white54, MyTheme.black02dp),
      ),
      child: TextField(
        autofocus: widget.autoFocus,
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style:
            TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.search, size: 20),
          hintText: '${'type_here_to_search'.tr()} ...',
          hintStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color
                ?.withOpacity(theme.modeCondition(.7, .3)),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
