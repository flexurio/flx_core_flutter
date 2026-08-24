import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';

class SlidingSwitch<T> extends StatefulWidget {
  const SlidingSwitch({
    required this.onToggle,
    required this.options,
    required this.getLabel,
    required this.value,
    super.key,
  });
  final void Function(T value) onToggle;
  final List<T> options;
  final String Function(T) getLabel;
  final T value;

  @override
  State<SlidingSwitch<T>> createState() => _SlidingSwitchState<T>();
}

class _SlidingSwitchState<T> extends State<SlidingSwitch<T>> {
  @override
  void initState() {
    children = _generateChildrenInit(option: widget.value);
    super.initState();
  }

  late Map<T, Widget> children;

  Map<T, Widget> _generateChildrenInit({required T option}) {
    final a = <T, Widget>{};
    for (final option in widget.options) {
      final label = widget.getLabel(option);
      a[option] = _TextLabel(
        label: label,
        selected: option == widget.value,
      );
    }
    return a;
  }

  Map<T, Widget> _generateChildren({required T option}) {
    final a = <T, Widget>{};
    for (final option in widget.options) {
      final label = widget.getLabel(option);
      a[option] = _TextLabel(
        label: label,
        selected: option == valueCategory,
      );
    }
    return a;
  }

  late T valueCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 150,
      child: CustomSlidingSegmentedControl<T>(
        initialValue: widget.value,
        children: children,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        thumbDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 1,
              spreadRadius: 0.5,
              offset: const Offset(
                0,
                2,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInToLinear,
        onValueChanged: (category) {
          setState(() {
            valueCategory = category;
            widget.onToggle(category);
            if (valueCategory != widget.value) {
              children = _generateChildren(
                option: category,
              );
            }
          });
        },
      ),
    );
  }
}

class _TextLabel extends StatelessWidget {
  const _TextLabel({required this.label, required this.selected});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color: selected ? Colors.black : Colors.grey.shade400,
      ),
    );
  }
}
