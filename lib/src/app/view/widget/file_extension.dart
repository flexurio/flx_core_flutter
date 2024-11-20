import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

const availableExtensionIcon = [
  'csv',
  'doc',
  'docx',
  'gif',
  'html',
  'mp3',
  'mp4',
  'mpeg',
  'other',
  'pdf',
  'ppt',
  'rar',
  'raw',
  'svg',
  'txt',
  'wav',
  'xml',
  'xls',
  'xlsx',
  'zip',
];

class FileExtension extends StatelessWidget {
  const FileExtension({required this.extension, super.key});

  final String extension;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'asset/svg/extension/${availableExtensionIcon.contains(extension) ? extension : 'other'}.svg',
      height: 64,
    );
  }
}

class FileIcon extends StatelessWidget {
  const FileIcon({required this.extension, required this.name, super.key});
  final String extension;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FileExtension(extension: extension),
        const Gap(6),
        SizedBox(
          width: 150,
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
