import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions? get currentPlatformOrNull {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        return null;
    }
  }

  static FirebaseOptions get currentPlatform {
    final options = currentPlatformOrNull;
    if (options == null) {
      throw UnsupportedError(
        'Firebase nie jest wspierany na platformie: $defaultTargetPlatform',
      );
    }
    return options;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBmDm1sLplJkfn99ah72dg7vJzY_GqADUg',
    appId: '1:367973026957:web:9a5d794f7754a33796e6c4',
    messagingSenderId: '367973026957',
    projectId: 'moneymanager-bfdd9',
    authDomain: 'moneymanager-bfdd9.firebaseapp.com',
    storageBucket: 'moneymanager-bfdd9.firebasestorage.app',
    measurementId: 'G-V3BPLN9DHK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCk38i-cXeuIAzavY3rwmzT2-Gd1eUI8-I',
    appId: '1:367973026957:android:8d94efe0b9fc3c9396e6c4',
    messagingSenderId: '367973026957',
    projectId: 'moneymanager-bfdd9',
    storageBucket: 'moneymanager-bfdd9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCp7I8tY5t7PvUcUI-O1oVsmWYozJmoPaM',
    appId: '1:367973026957:ios:e5795dc4bc0e311596e6c4',
    messagingSenderId: '367973026957',
    projectId: 'moneymanager-bfdd9',
    storageBucket: 'moneymanager-bfdd9.firebasestorage.app',
    iosBundleId: 'com.example.moneyManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCp7I8tY5t7PvUcUI-O1oVsmWYozJmoPaM',
    appId: '1:367973026957:ios:e5795dc4bc0e311596e6c4',
    messagingSenderId: '367973026957',
    projectId: 'moneymanager-bfdd9',
    storageBucket: 'moneymanager-bfdd9.firebasestorage.app',
    iosBundleId: 'com.example.moneyManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBmDm1sLplJkfn99ah72dg7vJzY_GqADUg',
    appId: '1:367973026957:web:798cf21d8423ece496e6c4',
    messagingSenderId: '367973026957',
    projectId: 'moneymanager-bfdd9',
    authDomain: 'moneymanager-bfdd9.firebaseapp.com',
    storageBucket: 'moneymanager-bfdd9.firebasestorage.app',
    measurementId: 'G-RR1NCM982Q',
  );
}
