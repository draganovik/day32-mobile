import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  static const routeName = 'login';
  SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AuthProvider>(
          builder: (BuildContext context, auth, Widget? child) {
            return ElevatedButton(
              child: const Text('Google Sign In'),
              onPressed: () => auth.googleSignIn(),
            );
          },
        ),
      ),
    );
  }
}
