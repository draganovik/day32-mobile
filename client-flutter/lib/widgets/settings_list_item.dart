import 'package:flutter/material.dart';

class SettingsListItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData iconGraph;
  final Color? colorTheme;
  const SettingsListItem(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.iconGraph,
      this.colorTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      splashColor: colorTheme?.withAlpha(190),
      highlightColor: colorTheme?.withAlpha(160),
      child: ListTile(
        shape: RoundedRectangleBorder(
            side: colorTheme != null
                ? BorderSide(color: colorTheme!.withAlpha(140), width: 1.4)
                : BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        tileColor: colorTheme?.withAlpha(40),
        textColor: colorTheme ?? Theme.of(context).colorScheme.onBackground,
        iconColor: colorTheme ?? Theme.of(context).colorScheme.onBackground,
        title: Text(title),
        leading: Icon(iconGraph),
      ),
      onTap: () => onTap(),
    );
  }
}
