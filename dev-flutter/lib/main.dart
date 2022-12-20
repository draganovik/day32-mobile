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

import '../layouts/tabs_page_layout.dart';

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
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepPurple,
                accentColor: Colors.deepPurpleAccent,
                brightness: Brightness.light)),
        darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepPurple,
                accentColor: Colors.deepPurpleAccent,
                brightness: Brightness.dark)),
        themeMode: ThemeMode.system,
        home: Consumer<AuthProvider>(builder: (context, auth, child) {
          switch (auth.status) {
            case AuthState.registrated:
              return const TabsPageLayout();
            case AuthState.unregistrated:
            case AuthState.error:
              return const SignInPage();
            default:
              return const SplashPage();
          }
        }),
        routes: {
          '/home': (context) => const TabsPageLayout(),
          SignInPage.routeName: (context) => const SignInPage()
        },
      ),
    );
  }
}
