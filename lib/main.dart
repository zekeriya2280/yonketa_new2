import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yonketa_new/pages/Intro.dart';
class Configurations {
   //  static const _apiKey = "AIzaSyAEHJp9wPFin0LR3af0bHX5UUuhNN0NpE4";
   //  static const _authDomain = "new-yonketa.firebaseapp.com";
   //  static const _projectId = "new-yonketa";
   //  //static const _storageBucket = "Your values";
   //  static const _messagingSenderId ="503272143078";
   //  static const _appId = "1:503272143078:android:a92bb8f6344a9338cf2327";
    
//Make some getter functions
   //   String get apiKey => _apiKey;
   //   String get authDomain => _authDomain;
   //   String get projectId => _projectId;
   //   //String get storageBucket => _storageBucket;
   //   String get messagingSenderId => _messagingSenderId;
   //   String get appId => _appId;
    }
main() async {
  //final configurations = Configurations();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 //await Firebase.initializeApp(
 //       options: FirebaseOptions(
 //           apiKey: configurations.apiKey,
 //           appId: configurations.appId,
 //           messagingSenderId: configurations.messagingSenderId,
 //              projectId: configurations.projectId));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yonketa',
      home: IntroPage(),
    );
  }
}


