import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({
    required this.entity,
    this.suffixText,
    this.x = false,
    super.key,
  });

  final EntityY entity;
  final String? suffixText;
  final bool x;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Image.asset(
            'asset/image/icon/${entity.iconPath}.png',
            width: 64,
            height: 64,
          ),
          const Gap(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entity.title}${suffixText != null ? ' $suffixText' : ''}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(6),
                Text(x ? entity.subtitleX : entity.subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EntityHomePage extends StatelessWidget {
  const EntityHomePage({
    required this.entity,
    required this.child,
     this.suffixText,
    super.key,
  });

  final Entity entity;
  final Widget child;
  final String? suffixText;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      children: [
        TitlePage(
          entity: entity,
          suffixText: suffixText,
        ),
        const Gap(12),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: child,
        ),
      ],
    );
  }
}
