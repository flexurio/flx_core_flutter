import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
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
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Logo(
            logoUrl: logoUrl,
            size: height,
            padding: EdgeInsets.zero,
          ),
          const Gap(12),
          Flexible(
            child: Named(
              logoNamedUrl: logoNamedUrl,
            ),
          ),
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
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface.withOpacity(0.9),
      letterSpacing: 0.5,
    );

    if (logoNamedUrl != null && logoNamedUrl!.isNotEmpty) {
      return Image.network(
        logoNamedUrl!,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _NamedFallback(style: textStyle),
      );
    }

    return Image.asset(
      'asset/image/logo-name-company-${flavorConfig.companyId}.png',
      height: 40,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          _NamedFallback(style: textStyle),
    );
  }
}

class _NamedFallback extends StatelessWidget {
  const _NamedFallback({required this.style});
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      flavorConfig.companyName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    this.logoUrl,
    this.size = 40,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    super.key,
  });

  final String? logoUrl;
  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (logoUrl != null && logoUrl!.isNotEmpty) {
      image = Image.network(
        logoUrl!,
        height: size,
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _LogoFallback(size: size),
      );
    } else {
      image = Image.asset(
        'asset/image/logo-company-${flavorConfig.companyId}.png',
        height: size,
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _LogoFallback(size: size),
      );
    }

    return Padding(
      padding: padding,
      child: image,
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = flavorConfig.companyName.trim().isNotEmpty
        ? flavorConfig.companyName.trim()[0].toUpperCase()
        : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            flavorConfig.color,
            flavorConfig.color.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: flavorConfig.color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
