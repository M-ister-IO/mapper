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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAbFyqGjhztiI13tHCpongH-0Clq_5Bp7I',
    appId: '1:774316991258:web:cc84b26c4667d0d9e382a3',
    messagingSenderId: '774316991258',
    projectId: 'mapper-d7bda',
    authDomain: 'mapper-d7bda.firebaseapp.com',
    databaseURL: 'https://mapper-d7bda-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'mapper-d7bda.firebasestorage.app',
    measurementId: 'G-MXDQT11JLK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrqyX6B9EJX2G8N8qPySkglfyAORiR0cA',
    appId: '1:774316991258:android:4a412632061f4af4e382a3',
    messagingSenderId: '774316991258',
    projectId: 'mapper-d7bda',
    databaseURL: 'https://mapper-d7bda-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'mapper-d7bda.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJSS2damlJm6vhuuEzzTpnyfvteSEI5ZQ',
    appId: '1:774316991258:ios:e83daec49e8fd891e382a3',
    messagingSenderId: '774316991258',
    projectId: 'mapper-d7bda',
    databaseURL: 'https://mapper-d7bda-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'mapper-d7bda.firebasestorage.app',
    iosBundleId: 'com.example.mapper',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJSS2damlJm6vhuuEzzTpnyfvteSEI5ZQ',
    appId: '1:774316991258:ios:e83daec49e8fd891e382a3',
    messagingSenderId: '774316991258',
    projectId: 'mapper-d7bda',
    databaseURL: 'https://mapper-d7bda-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'mapper-d7bda.firebasestorage.app',
    iosBundleId: 'com.example.mapper',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAbFyqGjhztiI13tHCpongH-0Clq_5Bp7I',
    appId: '1:774316991258:web:0c3392bc2141c926e382a3',
    messagingSenderId: '774316991258',
    projectId: 'mapper-d7bda',
    authDomain: 'mapper-d7bda.firebaseapp.com',
    databaseURL: 'https://mapper-d7bda-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'mapper-d7bda.firebasestorage.app',
    measurementId: 'G-5S0JNPZ0ZC',
  );

}