import 'package:day32/views/signin_page.dart';
import 'package:flutter/material.dart';

import '../views/tabs_page.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Day32',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: TabsPage(),
    );
  }
}
