import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class ContainerGlass extends StatelessWidget {
  const ContainerGlass({
    required this.child,
    super.key,
    this.height,
    this.width,
    this.padding,
    this.elevation,
    this.opacity = .4,
    this.borderRadius,
  });

  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double opacity;
  final double? elevation;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.modeCondition(Colors.white, Colors.black12),
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        color: theme.modeCondition(
          Colors.white.withOpacity(opacity),
          Colors.black.withOpacity(.5),
        ),
      ),
      padding: padding,
      height: height,
      width: width,
      // blur: 60,
      child: child,
    ).asGlass(
      blurX: 70,
      blurY: 70,
      clipBorderRadius: borderRadius ?? BorderRadius.circular(20),
    );
  }
}
