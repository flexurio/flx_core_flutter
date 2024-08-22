import 'package:flutter/material.dart';

class AssetBackground {
  static String displayLogin = 'asset/image/login-background.jpg';
}

class Background extends StatelessWidget {
  const Background({
    required this.child,
    required this.asset,
    super.key,
  });

  final Widget child;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(asset),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
