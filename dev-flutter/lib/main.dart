import '../providers/app_settings_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/google_events_provider.dart';
import '../views/signin_page.dart';
import '../views/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/tabs_page.dart';

void main() {
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, GoogleEventsProvider>(
          update: (ctx, auth, previous) =>
              GoogleEventsProvider(auth.authClient),
          create: (ctx) => GoogleEventsProvider(null),
        ),
      ],
      child: Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
                title: 'Day32',
                theme: ThemeData(primarySwatch: Colors.teal),
                home: FutureBuilder(
                    future: auth.isAuth,
                    builder: (ctx, authSnap) {
                      if (authSnap.connectionState == ConnectionState.done) {
                        if (auth.authUser == null) {
                          return SignInPage();
                        }
                        return const TabsPage();
                      }
                      return const SplashPage();
                    }),
                routes: {
                  '/home': (context) => const TabsPage(),
                  SignInPage.routeName: (context) => SignInPage()
                },
              )),
    );
  }
}
