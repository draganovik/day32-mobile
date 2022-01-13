import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '../providers/firebase_events_provider.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.white,
          brightness: Brightness.light,
          backgroundColor: const Color(0xFFE5E5E5),
          accentColor: Colors.black,
          dividerColor: Colors.white54,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.black,
          brightness: Brightness.dark,
          backgroundColor: const Color(0xFF212121),
          accentColor: Colors.white,
          dividerColor: Colors.white38,
        ),
        themeMode: ThemeMode.system,
        home: Consumer<AuthProvider>(builder: (context, auth, child) {
          switch (auth.status) {
            case AuthState.registrated:
              return const TabsPage();
            case AuthState.unregistrated:
            case AuthState.error:
              return SignInPage();
            default:
              return const SplashPage();
          }
        }),
        routes: {
          '/home': (context) => const TabsPage(),
          SignInPage.routeName: (context) => SignInPage()
        },
      ),
    );
  }
}
