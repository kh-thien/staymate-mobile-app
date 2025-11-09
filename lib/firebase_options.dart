// File generated manually from google-services.json
// For production, use FlutterFire CLI: flutterfire configure

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7_9bbCwHJik7NtFnGrJG41LV_roy3A2Y',
    appId: '1:368416591679:android:f36ac203d7dd3960680d8a',
    messagingSenderId: '368416591679',
    projectId: 'staymate-d0282',
    storageBucket: 'staymate-d0282.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCP1OB2bmj7Pql4-rRNC2KSQhd6fcutbwc',
    appId: '1:368416591679:ios:c7603ada6662b96c680d8a',
    messagingSenderId: '368416591679',
    projectId: 'staymate-d0282',
    storageBucket: 'staymate-d0282.firebasestorage.app',
    iosBundleId: 'com.staymate.mobile',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAWS5WBY2J5gs81-JHEpgIPitcQ6gryFIo',
    appId: '1:368416591679:web:9daf553eb206fd95680d8a',
    messagingSenderId: '368416591679',
    projectId: 'staymate-d0282',
    authDomain: 'staymate-d0282.firebaseapp.com',
    storageBucket: 'staymate-d0282.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCP1OB2bmj7Pql4-rRNC2KSQhd6fcutbwc',
    appId: '1:368416591679:ios:1b5caf140894803a680d8a',
    messagingSenderId: '368416591679',
    projectId: 'staymate-d0282',
    storageBucket: 'staymate-d0282.firebasestorage.app',
    iosBundleId: 'com.example.stayMate',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAWS5WBY2J5gs81-JHEpgIPitcQ6gryFIo',
    appId: '1:368416591679:web:3158e227feda04fb680d8a',
    messagingSenderId: '368416591679',
    projectId: 'staymate-d0282',
    authDomain: 'staymate-d0282.firebaseapp.com',
    storageBucket: 'staymate-d0282.firebasestorage.app',
  );

}
