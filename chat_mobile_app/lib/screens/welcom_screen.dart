import 'package:chat_mobile_app/auth/Login.dart';
import 'package:chat_mobile_app/auth/Register.dart';
import 'package:chat_mobile_app/widgets/my_Button.dart';
import 'package:flutter/material.dart';

class welcomScreen extends StatefulWidget {
  static const String root = "welcomscreen";
  const welcomScreen({super.key});

  @override
  State<welcomScreen> createState() => _welcomScreenState();
}

class _welcomScreenState extends State<welcomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(height: 180, child: Image.asset("images/logo.png")),
              const Text(
                "MessageMe",
                style: TextStyle(
                    fontSize: 35,
                    color: Color(0xff2e386b),
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          MyButton(
              color: Colors.yellow[900],
              title: "Sign in",
              onPressed: () {
                Navigator.of(context).pushNamed(loginScreen.root);
              }),
          MyButton(
              color: Colors.blue[800],
              title: "Register",
              onPressed: () {
                Navigator.of(context).pushNamed(registerScreen.root);
              })
        ],
      ),
    );
  }
}
