import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAftEPfILGJTE4VY42RXzNUa8Rd2sxaITA',
    appId: '1:956939898418:web:b3333753b237cadd8f762b',
    messagingSenderId: '956939898418',
    projectId: 'ocu-care-app',
    authDomain: 'ocu-care-app.firebaseapp.com',
    storageBucket: 'ocu-care-app.firebasestorage.app',
    measurementId: 'G-3XN1LTZM61',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCN0mKNFbeheXgi1nAFYZf2YoFXpyMzmOE',
    appId: '1:956939898418:android:e0a2bdf92f86daf98f762b',
    messagingSenderId: '956939898418',
    projectId: 'ocu-care-app',
    storageBucket: 'ocu-care-app.firebasestorage.app',
  );

}