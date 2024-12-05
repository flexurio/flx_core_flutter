import 'package:flexurio_erp_core/src/app/view/widget/file_extension.dart';
import 'package:flutter/material.dart';

class FileButton extends StatelessWidget {
  const FileButton({
    required this.fileName,
    required this.bytes,
    required this.onTap,
    this.onRemove,
    super.key,
  });
  final String fileName;
  final List<int> bytes;
  final void Function(List<int> bytes, String fileName) onTap;
  final void Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    const boxSize = 150.0;
    return Stack(
      children: [
        InkWell(
          child: Container(
            width: boxSize,
            height: boxSize,
            padding: const EdgeInsets.all(12),
            child: Center(
              child: FileIcon(
                extension: 'pdf',
                name: fileName,
              ),
            ),
          ),
          onTap: () {
            onTap(bytes, fileName);
          },
        ),
        if (onRemove != null)
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: onRemove,
              child: const Icon(Icons.close),
            ),
          ),
      ],
    );
  }
}
