import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/model/color_type.dart';
import 'package:gap/gap.dart';

class ChipType extends StatelessWidget {
  const ChipType(this.type, {super.key});

  final ColorType type;

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      side: BorderSide.none,
      backgroundColor: type.color.withOpacity(.1),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: type.color),
          const Gap(6),
          Text(
            type.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: type.color),
          ),
        ],
      ),
    );
  }
}
