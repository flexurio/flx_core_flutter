import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flutter/material.dart';

class ChooseFileFormField extends FormField<List<PlatformFile>> {
  ChooseFileFormField({
    required this.type,
    required this.onPickFile,
    required this.onChange,
    super.key,
    super.validator,
  }) : super(
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChooseFile(
                  onPickFile: onPickFile,
                  onChange: (files) {
                    field.didChange(files);
                    onChange(files);
                  },
                  type: type,
                  borderColor: field.hasError ? Colors.red : null,
                ),
                ErrorTextField(errorText: field.errorText),
              ],
            );
          },
        );
  final void Function(List<PlatformFile> files) onChange;
  final List<String> type;
  final OnPickFile onPickFile;
}

class ChooseFile extends StatefulWidget {
  const ChooseFile({
    required this.onChange,
    required this.onPickFile,
    required this.type,
    super.key,
    this.borderColor,
    this.multiple = false,
  });

  final void Function(List<PlatformFile> files) onChange;
  final List<String> type;
  final Color? borderColor;
  final bool multiple;
  final OnPickFile onPickFile;

  @override
  State<ChooseFile> createState() => _ChooseFileState();
}

class _ChooseFileState extends State<ChooseFile> {
  List<PlatformFile> _files = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final result = await widget.onPickFile(
                file: widget.type,
                type: FileType.custom,
                allowedMultiple: widget.multiple,
              );
              if (result != null) {
                widget.onChange(result.files);
                setState(() {
                  _files = result.files;
                });
              }
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.modeCondition(
                  primaryColor.lighten(.5),
                  primaryColor.darken(.33),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DottedBorder(
                dashPattern: const [8, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: widget.borderColor ?? primaryColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: _files.isNotEmpty
                        ? Wrap(
                            children: _files.map(_buildFileIcon).toList(),
                          )
                        : _buildUploadIcon(primaryColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileIcon(PlatformFile file) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        clipBehavior: Clip.none, // Pastikan widget tidak dipotong
        children: [
          FileIcon(
            extension: file.extension!,
            name: file.name,
          ),
          Positioned(
            right: -6,
            top: -6,
            child: InkWell(
              onTap: () {
                setState(() {
                  _files.remove(file);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadIcon(Color primaryColor) {
    return Column(
      children: [
        Icon(
          Icons.file_upload_outlined,
          color: primaryColor,
        ),
        Text(
          'choose_file'.tr(),
          style: TextStyle(color: primaryColor),
        ),
      ],
    );
  }
}

typedef OnPickFile = Future<FilePickerResult?> Function({
  List<String>? file,
  FileType type,
  bool allowedMultiple,
});
