import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:http/http.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      CalendarApi.calendarScope,
    ],
  );
  Client httpClient = Client();

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    } finally {
      httpClient = (await _googleSignIn.authenticatedClient())!;
      print(httpClient);
      var calendarApi = await CalendarApi(httpClient);
      print(calendarApi);
      var favorites = await calendarApi.calendarList.list();
      print(json.encode(favorites.items));
      var events = await calendarApi.events
          .list('mladenoneacc@gmail.com', timeMin: DateTime.now());
      print(json.encode(events));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Google Sign In'),
          onPressed: () => _handleSignIn(),
        ),
      ),
    );
  }
}
