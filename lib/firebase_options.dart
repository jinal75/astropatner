import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;

      default:
        return android;
    }
  }

  
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDVglHYQKizTEC91HOgzjKcgFaLpn4bubM",
    authDomain: "astromtpatner.firebaseapp.com",
    projectId: "astromtpatner",
    storageBucket: "astromtpatner.appspot.com",
    messagingSenderId: "481476722615",
    appId: "1:665794319149:android:27a14b12df4956e708b9a4",
    //measurementId: "G-KBPRBBZRYC",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDVglHYQKizTEC91HOgzjKcgFaLpn4bubM",
    authDomain: "astromtpatner.firebaseapp.com",
    projectId: "astromtpatner",
    storageBucket: "astromtpatner.appspot.com",
    messagingSenderId: "522488317755",
    appId: "1:665794319149:ios:0fcffe2830284be008b9a4",
    androidClientId:'665794319149-02oh4re817htjn9jv6j6jcv8m7priiri.apps.googleusercontent.com',
    iosClientId:'665794319149-ds6u964f7ifobb0e8599q5jf2hnni9jm.apps.googleusercontent.com',
    iosBundleId: 'com.example.astrologer-app',
    //measurementId: "G-KBPRBBZRYC",
  );
}
