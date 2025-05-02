import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LogoNamed extends StatelessWidget {
  const LogoNamed({
    this.height = 40,
    this.padding = const EdgeInsets.all(12),
    super.key,
    this.logoUrl,
    this.logoNamedUrl,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final String? logoUrl;
  final String? logoNamedUrl;

  @override
  Widget build(BuildContext context) {
    late Widget logo;
    late Widget logoNamed;
    if (logoUrl != null) {
      logo = Image.network(
        logoUrl!,
        height: height,
        width: height,
      );
    } else {
      logo = Image.asset(
        'asset/image/logo-company-${flavorConfig.companyId}.png',
        height: height,
        width: height,
      );
    }

    return Padding(
      padding: padding,
      child: Row(
        children: [
          logo,
          const Gap(12),
          Named(logoNamedUrl: logoNamedUrl),
        ],
      ),
    );
  }
}

class Named extends StatelessWidget {
  const Named({super.key, this.logoNamedUrl});

  final String? logoNamedUrl;

  @override
  Widget build(BuildContext context) {
    late Widget logoNamed;
    if (logoNamedUrl != null) {
      logoNamed = Image.network(
        logoNamedUrl!,
        height: 40,
      );
    } else {
      logoNamed = Image.asset(
        'asset/image/logo-name-company-${flavorConfig.companyId}.png',
        height: 40,
      );
    }
    return logoNamed;
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key, this.logoUrl});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    late Widget logo;
    if (logoUrl != null) {
      logo = Image.network(
        logoUrl!,
        height: 40,
        width: 40,
      );
    } else {
      logo = Image.asset(
        'asset/image/logo-company-${flavorConfig.companyId}.png',
        height: 40,
        width: 40,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: logo,
    );
  }
}
