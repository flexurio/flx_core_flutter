import 'package:flutter/material.dart';

enum AssetBackground {
  displayLogin('asset/image/login-background.jpg');

  const AssetBackground(this.path);
  final String path;
}

class Background extends StatelessWidget {
  const Background({
    required this.child,
    required this.asset,
    super.key,
  });

  final Widget child;
  final AssetBackground asset;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(asset.path),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
