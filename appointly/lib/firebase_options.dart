import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web not configured',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'This platform is not supported.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsinBN20b9Gy9ikVkL2JHGr3z14reTLm4',
    appId: '1:547136946132:android:a9ce09e8e5c05b1e5a6041',
    messagingSenderId: '547136946132',
    projectId: 'appointly-davag-2025',
    storageBucket: 'appointly-davag-2025.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQNJelVfE5w7ZUqVc5Rm7iORMMmx5X9eE',
    appId: '1:547136946132:ios:7553a597639f3e415a6041',
    messagingSenderId: '547136946132',
    projectId: 'appointly-damvag-2025',
    storageBucket: 'appointly-davag-2025.firebasestorage.app',
    iosBundleId: 'com.example.appointly',
  );
}
