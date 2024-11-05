import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({
    required this.onTap,
    required this.group,
    required this.query,
    required this.title,
    required this.icon,
    super.key,
  });

  final void Function() onTap;
  final String group;
  final String query;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 36),
        leading: IconTheme(
          data: IconThemeData(
            size: 14,
            color: theme.modeCondition(Colors.black54, Colors.white60),
          ),
          child: icon,
        ),
        title: Row(
          children: [
            buildHighlightedText(context, title, query),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              width: 30,
              child: const Divider(),
            ),
            Text(
              group,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildHighlightedText(BuildContext context, String text, String query) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme.bodyMedium!;

  final spans = <TextSpan>[];
  var queryIndex = 0;

  for (var i = 0; i < text.length; i++) {
    if (queryIndex < query.length &&
        text[i].toLowerCase() == query[queryIndex].toLowerCase()) {
      spans.add(
        TextSpan(
          text: text[i],
          style: textTheme.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      queryIndex++;
    } else {
      spans.add(
        TextSpan(
          text: text[i],
          style: textTheme,
        ),
      );
    }
  }

  return RichText(text: TextSpan(children: spans));
}
