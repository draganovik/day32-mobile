// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA0eLJrSwqJgXUdMFq8ymQeQCMNC66fPnM',
    appId: '1:834050956628:web:5a899d0627952dd5dabcc1',
    messagingSenderId: '834050956628',
    projectId: 'day-32',
    authDomain: 'day-32.firebaseapp.com',
    databaseURL: 'https://day-32.firebaseio.com',
    storageBucket: 'day-32.appspot.com',
    measurementId: 'G-N7TQ8DD1MF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeMEUUA9FL2MWS4x-zsflKYxVg_QbHGfg',
    appId: '1:834050956628:android:ba71718ccac13fe2dabcc1',
    messagingSenderId: '834050956628',
    projectId: 'day-32',
    databaseURL: 'https://day-32.firebaseio.com',
    storageBucket: 'day-32.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLfW-ocrAnsJm0fAwe-EUpMVvKi7M_K9E',
    appId: '1:834050956628:ios:fe134380b89b0c40dabcc1',
    messagingSenderId: '834050956628',
    projectId: 'day-32',
    databaseURL: 'https://day-32.firebaseio.com',
    storageBucket: 'day-32.appspot.com',
    iosClientId: '834050956628-5iqv9cgs21699t4htplpeb71sujtm9tf.apps.googleusercontent.com',
    iosBundleId: 'com.draganovik.day32',
  );
}
