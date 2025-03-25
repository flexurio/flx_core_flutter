import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Tooltip(
        message: errorSomethingWentWrong,
        child: Icon(
          Icons.error_outline,
          size: 32,
          color: Colors.red,
        ),
      ),
    );
  }
}

class WarningIconAnimate extends StatelessWidget {
  const WarningIconAnimate({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('asset/lottie/warning.json', repeat: true); // Warning();
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
