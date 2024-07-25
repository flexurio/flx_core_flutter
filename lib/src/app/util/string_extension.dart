import 'dart:convert' show HtmlEscape;

import 'package:clipboard/clipboard.dart';
import 'package:flexurio_erp_core/src/app/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

extension StringExtension on String {
    String get replaceSymbol {
    return replaceAll('/', '-');
  }
  
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String variableSet(Map<String, dynamic> data) {
    var newData = this;
    const escape = HtmlEscape();
    for (final key in data.keys.toList()) {
      newData = newData.replaceAll(
        '{{$key}}',
        escape.convert(data[key].toString()),
      );
    }
    return newData;
  }
}

extension TextExtension on Text {
  Widget clickable({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        child: this,
      ),
    );
  }

  Widget canCopy() {
    if (data == '') return Container();
    return Builder(
      builder: (context) {
        return Row(
          children: [
            this,
            const Gap(6),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (data != null) {
                  FlutterClipboard.copy(data!).then(
                    (value) => Toast(context).notify('Copied to clipboard'),
                  );
                }
              },
              child: const SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  Icons.copy,
                  size: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget get withTooltip {
    return Tooltip(
      message: data,
      child: this,
    );
  }
}
