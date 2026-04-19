import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAeGJqdXpAHv1KLsmjPoLcxOfJvYv3jGWo",
    appId: "1:1033065664887:web:66343286755187981ed172",
    messagingSenderId: "1033065664887",
    projectId: "taskmanagment-5dda9",
    authDomain: "taskmanagment-5dda9.firebaseapp.com",
    storageBucket: "taskmanagment-5dda9.firebasestorage.app",
  );

}