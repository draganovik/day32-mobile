import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:day32/providers/firebase_events_provider.dart';

import '../providers/app_settings_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/google_events_provider.dart';
import '../views/signin_page.dart';
import '../views/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/tabs_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FirebaseEventsProvider()),
        ChangeNotifierProxyProvider<AuthProvider, GoogleEventsProvider>(
          update: (ctx, auth, previous) =>
              GoogleEventsProvider(auth.googleAuthClient),
          create: (ctx) => GoogleEventsProvider(null),
        ),
      ],
      child: MaterialApp(
        title: 'Day32',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: Consumer<AuthProvider>(builder: (context, auth, child) {
          if (auth.isLoading) {
            return const SplashPage();
          }
          if (auth.isSignedIn) {
            return const TabsPage();
          }
          return SignInPage();
        }),
        routes: {
          '/home': (context) => const TabsPage(),
          SignInPage.routeName: (context) => SignInPage()
        },
      ),
    );
  }
}
