import 'package:flutter/material.dart';

class FCard extends StatelessWidget {
  const FCard({
    required this.child,
    super.key,
    this.height,
    this.width,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
        ),
        padding: padding,
        height: height,
        width: width,
        // blur: 60,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
