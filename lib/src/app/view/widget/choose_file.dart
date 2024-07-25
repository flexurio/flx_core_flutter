import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';

class ChooseFileFormField extends FormField<PlatformFile> {
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
                  onChange: (file) {
                    field.didChange(file);
                    onChange(file);
                  },
                  type: type,
                  borderColor: field.hasError ? Colors.red : null,
                ),
                ErrorTextField(errorText: field.errorText),
              ],
            );
          },
        );
  final void Function(PlatformFile) onChange;
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
  });

  final void Function(PlatformFile file) onChange;
  final List<String> type;
  final Color? borderColor;
  final OnPickFile onPickFile;

  @override
  State<ChooseFile> createState() => _ChooseFileState();
}

class _ChooseFileState extends State<ChooseFile> {
  PlatformFile? _file;

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
              );
              if (result != null) {
                widget.onChange(result.files.first);
                setState(() {
                  _file = result.files.first;
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
                    child: _file != null
                        ? FileIcon(
                            extension: _file!.extension!,
                            name: _file!.name,
                          )
                        : Column(
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
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

typedef OnPickFile = Future<FilePickerResult?> Function({
  List<String>? file,
  FileType type,
});
