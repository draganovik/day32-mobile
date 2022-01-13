import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  static const routeName = 'login';
  SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Every day, in every way, getting better and better!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 80),
                  Image.asset(
                    'assets/schedule.png',
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Consumer<AuthProvider>(
                      builder: (BuildContext context, auth, Widget? child) {
                    return ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/google_logo.png', height: 24),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text('Sign in with Google')
                        ],
                      ),
                      onPressed: () => auth.googleSignIn(),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              side: BorderSide(
                                  color: Colors.grey[350] ?? Colors.grey)),
                          primary: Colors.white,
                          onPrimary: Colors.black54,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          padding: const EdgeInsets.all(16)),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
