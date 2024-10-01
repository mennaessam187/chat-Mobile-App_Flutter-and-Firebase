import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_mobile_app/auth/Register.dart';
import 'package:chat_mobile_app/screens/myChat_screen.dart';
import 'package:chat_mobile_app/widgets/My_textFormField.dart';
import 'package:chat_mobile_app/widgets/my_Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class loginScreen extends StatefulWidget {
  static const String root = "loginscreen";
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => __registerScreenState();
}

TextEditingController? emailcontroller = TextEditingController();
TextEditingController? passwordcontroller = TextEditingController();
GlobalKey<FormState> key2 = GlobalKey();
bool saving = false;

class __registerScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              child: Image.asset("images/logo.png"),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
                key: key2,
                child: Column(
                  children: [
                    textformfield(
                      controller: emailcontroller,
                      hintText: "Enter Your Email",
                      validator: (ValueKey) {
                        if (ValueKey!.isEmpty) {
                          return "this field can't be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    textformfield(
                      controller: passwordcontroller,
                      hintText: "Enter Your Password",
                      validator: (ValueKey) {
                        if (ValueKey!.isEmpty) {
                          return "this field can't be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    MyButton(
                        color: Colors.yellow[900],
                        title: "Sign in",
                        onPressed: () async {
                          if (key2.currentState!.validate()) {
                            try {
                              setState(() {
                                saving = true;
                              });
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: emailcontroller!.text,
                                password: passwordcontroller!.text,
                              );

                              if (credential.user!.emailVerified) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  mychat.root,
                                  (route) => false,
                                );
                                emailcontroller!.clear();
                                passwordcontroller!.clear();
                                setState(() {
                                  saving = false;
                                });
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Email Verification',
                                  desc: 'Please verify your email.',
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }
                          }
                          return false;
                        }),
                    const Padding(
                      padding: EdgeInsets.only(left: 40.0, right: 40),
                      child: Divider(),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Or Craete New Acount?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(registerScreen.root);
                          },
                          child: Container(
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 21, 101, 192),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
