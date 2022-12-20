import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class SignInPage extends StatelessWidget {
  static const routeName = 'login';
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Every day, in every way, getting better and better!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/schedule.png',
                width: max(400, MediaQuery.of(context).size.shortestSide / 2),
              ),
              const SizedBox(height: 10),
              Consumer<AuthProvider>(
                  builder: (BuildContext context, auth, Widget? child) {
                return ElevatedButton(
                  onPressed: () => auth.googleSignIn(),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          side: BorderSide(
                              color: Colors.grey[350] ?? Colors.grey)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/google_logo.png', height: 24),
                      const SizedBox(
                        width: 16,
                      ),
                      const Text('Sign in with Google')
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
