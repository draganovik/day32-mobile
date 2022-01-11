import 'package:flutter/material.dart';

class ApplicationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  AppBar _appBar = AppBar();
  ApplicationBar({Key? key, this.title = 'Day32', required context})
      : super(key: key) {
    _appBar = AppBar(
      title: Text(title),
      titleTextStyle:
          Theme.of(context).textTheme.headline6!.copyWith(fontSize: 26),
      toolbarHeight: 80,
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 2,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.notifications_outlined))
      ],
    );
  }

  // ignore: prefer_final_fields

  @override
  Widget build(BuildContext context) {
    return _appBar;
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => _appBar.preferredSize;
}
