import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LogoNamed extends StatelessWidget {
  const LogoNamed({
    this.height = 40,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Image.asset(
            'asset/image/logo-company-${flavorConfig.companyId}.png',
            height: height,
            width: height,
          ),
          const Gap(12),
          Image.asset(
            'asset/image/logo-name-company-${flavorConfig.companyId}.png',
            height: height,
          ),
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Image.asset(
        'asset/image/logo-company-${flavorConfig.companyId}.png',
        height: 40,
        width: 40,
      ),
    );
  }
}
