import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              // linear-gradient(180deg,#e0f2fe 0,#f1f5f9 100%)
              gradient: theme.modeCondition(
                const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE0F2FE),
                    Color(0xFFF1F5F9),
                  ],
                ),
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.cardColor,
                    theme.cardColor,
                  ],
                ),
              ),
              // 0 10px 30px rgba(2,6,23,.07)
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12020617), // rgba(2,6,23,0.07)
                  offset: Offset(0, 10),
                  blurRadius: 30,
                ),
                BoxShadow(
                  color: Color(0x08020617), // rgba(2,6,23,0.03)
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'asset/image/icon/${entity.iconPath}.png',
                width: 48,
                height: 48,
              ),
            ),
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
