// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBkb1x0ovU2asqndPnIiZQ_mLzmctGcFc4',
    appId: '1:327591835002:web:4609ab39fa67c7c23b12c3',
    messagingSenderId: '327591835002',
    projectId: 'design-app-2671f',
    authDomain: 'design-app-2671f.firebaseapp.com',
    storageBucket: 'design-app-2671f.appspot.com',
    measurementId: 'G-77Y5JSFSHR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDv76iyw2IT7ci9VZbj9l_alCuYlf7vPU4',
    appId: '1:327591835002:android:33fb50863c757be43b12c3',
    messagingSenderId: '327591835002',
    projectId: 'design-app-2671f',
    storageBucket: 'design-app-2671f.appspot.com',
  );
}
