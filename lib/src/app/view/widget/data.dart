import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

class SomethingWrong extends StatelessWidget {
  const SomethingWrong({
    this.errorMessage,
    super.key,
  });
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 32,
            color: Colors.red,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? errorSomethingWentWrong,
          ),
        ],
      ),
    );
  }
}

class ProgressingIndicator extends StatelessWidget {
  const ProgressingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
