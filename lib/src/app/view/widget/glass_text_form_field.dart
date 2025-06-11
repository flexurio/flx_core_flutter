import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class GlassTextFormField extends FormField<String> {
  GlassTextFormField({
    required this.labelText,
    super.key,
    this.onEditingComplete,
    this.errorText,
    this.maxLines = 1,
    this.obscureText = false,
    this.controller,
    super.validator,
  }) : super(
          initialValue: '',
          builder: (field) {
            return Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            theme.modeCondition(Colors.white38, Colors.black12),
                        border: Border.all(
                          color: theme.modeCondition(
                            Colors.white,
                            Colors.black12,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: TextField(
                            onChanged: (value) {
                              field.setValue(value);
                            },
                            maxLines: maxLines,
                            controller: controller,
                            obscureText: obscureText,
                            onEditingComplete: onEditingComplete,
                            style: theme.modeCondition(
                              null,
                              const TextStyle(color: Colors.white60),
                            ),
                            decoration: InputDecoration(
                              labelText: labelText,
                              labelStyle: theme.modeCondition(
                                null,
                                const TextStyle(color: Colors.white38),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ErrorTextField(errorText: errorText ?? field.errorText),
                  ],
                );
              },
            );
          },
        );

  final void Function()? onEditingComplete;
  final String? errorText;
  final int? maxLines;
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
}

// class ErrorTextField extends StatelessWidget {
//   const ErrorTextField({
//     super.key,
//     this.errorText,
//   });

//   final String? errorText;

//   @override
//   Widget build(BuildContext context) {
//     if (errorText != null) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//         child: Text(
//           errorText!,
//           style: const TextStyle(color: Colors.red, fontSize: 10),
//         ),
//       );
//     }
//     return const SizedBox();
//   }
// }
