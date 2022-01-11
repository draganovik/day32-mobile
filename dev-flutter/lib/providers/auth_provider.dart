import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class AuthProvider with ChangeNotifier {
  AuthClient? _authClient;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      CalendarApi.calendarScope,
    ],
  );

  Future<bool> _googleSignInSilently() async {
    try {
      await _googleSignIn.signInSilently();
      _authClient = (await _googleSignIn.authenticatedClient())!;
      notifyListeners();
    } catch (err) {
      // Handle error
    }
    if (_authClient != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> googleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      // handle error
    } finally {
      if (await _googleSignIn.isSignedIn()) {
        _authClient = (await _googleSignIn.authenticatedClient())!;
        notifyListeners();
      }
    }
  }

  Future<void> googleLogOut() async {
    try {
      await _googleSignIn.signOut();
      _authClient = null;
      notifyListeners();
    } catch (error) {
      // handle error
    }
  }

  GoogleSignInAccount? get authUser {
    return _googleSignIn.currentUser;
  }

  AuthClient? get authClient {
    return _authClient;
  }

  Future<bool> get isAuth async {
    if (_authClient == null) {
      await _googleSignInSilently();
    }
    return await _googleSignIn.isSignedIn();
  }
}
