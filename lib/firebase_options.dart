// File generated for Firebase project: macha-umkm (Latihan Firebase 1122140142)
// ignore_for_file: type=lint
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
        return ios;
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
        return web;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD3qIhEh1NF5JPbR2ZUMRfIFD_boUJS_OA',
    appId: '1:194613325888:web:c0adfb5827635f2948afa5',
    messagingSenderId: '194613325888',
    projectId: 'macha-umkm',
    authDomain: 'macha-umkm.firebaseapp.com',
    storageBucket: 'macha-umkm.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFOFU01I2No4d9KG6gscAV-g2-DluJlMo',
    appId: '1:194613325888:android:3c9e56365f8d878448afa5',
    messagingSenderId: '194613325888',
    projectId: 'macha-umkm',
    storageBucket: 'macha-umkm.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBT9UzFKvVjQJLBCSl4IiUdM-5JSz59Cs',
    appId: '1:194613325888:ios:603a5bd98973ad4e48afa5',
    messagingSenderId: '194613325888',
    projectId: 'macha-umkm',
    storageBucket: 'macha-umkm.firebasestorage.app',
    iosBundleId: 'com.fikribintang.loginFirebase',
  );
}
