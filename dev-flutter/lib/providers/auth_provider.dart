import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class AuthProvider with ChangeNotifier {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      CalendarApi.calendarScope,
    ],
  );
  GoogleSignInAccount? _googleUser;
  OAuthCredential? _googleCredential;
  AuthClient? _googleAuthClient;
  AuthState status = AuthState.unset;

  AuthProvider() {
    _googleSignInSilently();
  }

  Future<void> _firebaseGoogleAuth() async {
    status = AuthState.waiting;
    _googleAuthClient = (await _googleSignIn.authenticatedClient())!;
    // Obtain the _auth details from the request.
    final GoogleSignInAuthentication googleAuth =
        await _googleUser!.authentication;
    // Create a new credential.
    _googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        status = AuthState.unregistrated;
      } else {
        status = AuthState.registrated;
      }
      notifyListeners();
    });
    await FirebaseAuth.instance.signInWithCredential(_googleCredential!);
  }

  Future<void> googleSignIn() async {
    _googleUser = await _googleSignIn.signIn();
    if (_googleUser == null) {
      status = AuthState.unregistrated;
      notifyListeners();
    } else {
      await _firebaseGoogleAuth();
    }
  }

  Future<void> _googleSignInSilently() async {
    _googleUser = await _googleSignIn.signInSilently();
    if (_googleUser == null) {
      status = AuthState.unregistrated;
      notifyListeners();
    } else {
      await _firebaseGoogleAuth();
    }
  }

  Future<void> firebaseSignOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  GoogleSignInAccount? get googleUser {
    return _googleUser;
  }

  AuthClient? get googleAuthClient {
    return _googleAuthClient;
  }
}

enum AuthState {
  unset,
  waiting,
  unregistrated,
  registrated,
  error,
}
