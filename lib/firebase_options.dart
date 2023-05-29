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
    apiKey: 'AIzaSyDtn7Fu6N4q5K4mjqwxPjVvi16nC-avluk',
    appId: '1:740668609065:web:0d425a899c14a684080238',
    messagingSenderId: '740668609065',
    projectId: 'chatt-feature',
    authDomain: 'chatt-feature.firebaseapp.com',
    storageBucket: 'chatt-feature.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiBjimeZfANWmgO3gs9sPyHFMJxOjF17M',
    appId: '1:740668609065:android:70da3dc5dc69bf57080238',
    messagingSenderId: '740668609065',
    projectId: 'chatt-feature',
    storageBucket: 'chatt-feature.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbFMq_o_g2EpoSdEYc9RX1d7YEIZLcnt8',
    appId: '1:740668609065:ios:9bdc98fab0032440080238',
    messagingSenderId: '740668609065',
    projectId: 'chatt-feature',
    storageBucket: 'chatt-feature.appspot.com',
    iosBundleId: 'com.example.chatt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbFMq_o_g2EpoSdEYc9RX1d7YEIZLcnt8',
    appId: '1:740668609065:ios:9bdc98fab0032440080238',
    messagingSenderId: '740668609065',
    projectId: 'chatt-feature',
    storageBucket: 'chatt-feature.appspot.com',
    iosBundleId: 'com.example.chatt',
  );
}