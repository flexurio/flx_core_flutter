import 'package:flx_core_flutter/src/app/model/entity.dart';
import 'package:flx_core_flutter/src/app/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'All Toasts', type: Toast)
Widget toastUseCase(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Toast(context).success('This is a success message');
          },
          child: const Text('Show Success'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Toast(context).fail('This is a fail message');
          },
          child: const Text('Show Fail'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Toast(context).warning('This is a warning message');
          },
          child: const Text('Show Warning'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Toast(context).notify('This is a notification message');
          },
          child: const Text('Show Notify'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            showSuccessWithId(
              context: context,
              entity: Entity.product,
              id: 'PRODUCT-001',
            );
          },
          child: const Text('Show Success with ID'),
        ),
      ],
    ),
  );
}
