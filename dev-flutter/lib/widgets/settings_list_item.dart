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
      splashColor: colorTheme?.withAlpha(90),
      highlightColor: colorTheme?.withAlpha(60),
      child: ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        tileColor: colorTheme?.withAlpha(20),
        textColor: colorTheme ?? Theme.of(context).textTheme.bodyText1?.color,
        iconColor: colorTheme ?? Theme.of(context).textTheme.bodyText1?.color,
        title: Text(title),
        leading: Icon(iconGraph),
      ),
      onTap: () => onTap(),
    );
  }
}
