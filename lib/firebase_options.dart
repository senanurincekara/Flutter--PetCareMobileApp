// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD3W-87w23AOCV37TMGE6l2-Ctsy_P90p0',
    appId: '1:710749273982:web:484ef84018d172aeb43d2f',
    messagingSenderId: '710749273982',
    projectId: 'finalproject-d63b0',
    authDomain: 'finalproject-d63b0.firebaseapp.com',
    storageBucket: 'finalproject-d63b0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTjd_oUXHchl2E19iYQEX2myTSzyLLbTs',
    appId: '1:710749273982:android:e7a7ae0d3237e289b43d2f',
    messagingSenderId: '710749273982',
    projectId: 'finalproject-d63b0',
    storageBucket: 'finalproject-d63b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPuhFG0inK9slizqll88WKbI_hGRThm-4',
    appId: '1:710749273982:ios:a4988a7b5ec87d70b43d2f',
    messagingSenderId: '710749273982',
    projectId: 'finalproject-d63b0',
    storageBucket: 'finalproject-d63b0.appspot.com',
    iosBundleId: 'com.example.flutterApplication2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPuhFG0inK9slizqll88WKbI_hGRThm-4',
    appId: '1:710749273982:ios:e2dc870cc41968e8b43d2f',
    messagingSenderId: '710749273982',
    projectId: 'finalproject-d63b0',
    storageBucket: 'finalproject-d63b0.appspot.com',
    iosBundleId: 'com.example.flutterApplication2.RunnerTests',
  );
}