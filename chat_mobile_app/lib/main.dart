import 'package:chat_mobile_app/auth/Login.dart';
import 'package:chat_mobile_app/auth/Register.dart';
import 'package:chat_mobile_app/screens/myChat_screen.dart';
import 'package:chat_mobile_app/screens/welcom_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  // No need for manual Firebase initialization if using google-services.json
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDYoulnSVs_eDx_uECOreK5yVk2s8ZNNcY',
      appId: '1:485343571253:android:1827095d9f0710906ab07c',
      messagingSenderId: '485343571253',
      projectId: 'chat-mobile-app-3305c',
      storageBucket: 'chat-mobile-app-3305c.appspot.com',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: mychat(),
      initialRoute: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? mychat.root
          : welcomScreen.root,
      routes: {
        mychat.root: (context) => mychat(),
        registerScreen.root: (context) => registerScreen(),
        loginScreen.root: (context) => loginScreen(),
        welcomScreen.root: (context) => welcomScreen(),
      },
    );
  }
}
