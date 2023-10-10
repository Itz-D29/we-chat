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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHX8A6P_qVXY3ymLvyn7XtAlvFZMh1-pk',
    appId: '1:906995647281:android:a20a6d21b9a7661b386610',
    messagingSenderId: '906995647281',
    projectId: 'wechat-f677a',
    storageBucket: 'wechat-f677a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCTUwub1Yc0eFG6HzdzUfQVuoe3emFyO0',
    appId: '1:906995647281:ios:b139949c225dc7ca386610',
    messagingSenderId: '906995647281',
    projectId: 'wechat-f677a',
    storageBucket: 'wechat-f677a.appspot.com',
    androidClientId: '906995647281-ial53h82muhgi60131utqh9osbfsqhg9.apps.googleusercontent.com',
    iosClientId: '906995647281-14vqlvt65278bfteesbg3a69o7q8uep1.apps.googleusercontent.com',
    iosBundleId: 'com.example.wechat',
  );
}