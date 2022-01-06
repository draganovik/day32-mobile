import 'package:flutter/material.dart';

class ApplicationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  AppBar _appBar = AppBar();
  ApplicationBar({Key? key, this.title = 'Day32'}) : super(key: key) {
    _appBar = AppBar(
      title: Text(title),
      centerTitle: false,
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
