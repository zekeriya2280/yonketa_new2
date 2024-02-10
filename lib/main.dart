
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yonketa_new/pages/wrapper.dart';
main() async {
  //final configurations = Configurations();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAjoPwB4SRBJ6hifgvK8nUxXOXH6WOafT0', 
      appId: 'yonkate-new', 
      messagingSenderId: '373796966807', 
      projectId: '1:373796966807:android:17e46647c79ae96c55b4d2')
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Wrapper(),
    );
  }
}

