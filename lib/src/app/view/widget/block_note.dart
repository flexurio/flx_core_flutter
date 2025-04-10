import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BlockNote extends StatelessWidget {
  const BlockNote({
    required this.title,
    required this.subtitle,
    super.key,
    this.color,
  });

  final String title;
  final String subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainColor = color ?? theme.colorScheme.primary;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: mainColor.withOpacity(.5),
                  width: 4,
                ),
              ),
              color: mainColor.withOpacity(.08),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Gap(6),
                SelectableText(subtitle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
