import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';

class DropDownEmptyCreateAction extends StatelessWidget {
  const DropDownEmptyCreateAction({
    required this.label,
    required this.onPressed,
    this.message = 'No data found',
    super.key,
  });

  final String message;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(
              color: theme.modeCondition(
                Colors.grey.shade600,
                Colors.grey.shade400,
              ),
              fontSize: 14,
            ),
          ),
          const Gap(10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
