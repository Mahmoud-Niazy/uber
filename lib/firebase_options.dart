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
    apiKey: 'AIzaSyD2055TYngP0L-jq7Tw30eOTTsc5JnfnB4',
    appId: '1:385386557932:web:e6ba634873341a5ce590c9',
    messagingSenderId: '385386557932',
    projectId: 'uber-final-ca7ec',
    authDomain: 'uber-final-ca7ec.firebaseapp.com',
    storageBucket: 'uber-final-ca7ec.appspot.com',
    measurementId: 'G-MHBLBJ2WE7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3UMvR74T-RUwuh9R2GNOvqLVcRmmhzWg',
    appId: '1:385386557932:android:415ba2754812044ee590c9',
    messagingSenderId: '385386557932',
    projectId: 'uber-final-ca7ec',
    storageBucket: 'uber-final-ca7ec.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxFmoOxkNzhHMxF5Kyxzv6Y85SZUoQY2U',
    appId: '1:385386557932:ios:cc4cac0dee7abd1ee590c9',
    messagingSenderId: '385386557932',
    projectId: 'uber-final-ca7ec',
    storageBucket: 'uber-final-ca7ec.appspot.com',
    iosClientId: '385386557932-0ds9jiim9dnaio2o3eelibjl9432qdve.apps.googleusercontent.com',
    iosBundleId: 'com.example.uberFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxFmoOxkNzhHMxF5Kyxzv6Y85SZUoQY2U',
    appId: '1:385386557932:ios:cc4cac0dee7abd1ee590c9',
    messagingSenderId: '385386557932',
    projectId: 'uber-final-ca7ec',
    storageBucket: 'uber-final-ca7ec.appspot.com',
    iosClientId: '385386557932-0ds9jiim9dnaio2o3eelibjl9432qdve.apps.googleusercontent.com',
    iosBundleId: 'com.example.uberFinal',
  );
}
