import 'package:chat_mobile_app/auth/Login.dart';
import 'package:chat_mobile_app/widgets/My_textFormField.dart';
import 'package:chat_mobile_app/widgets/my_Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class registerScreen extends StatefulWidget {
  static const String root = "registerscreen";
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => __registerScreenState();
}

TextEditingController? emailcontroller = TextEditingController();
TextEditingController? passwordcontroller = TextEditingController();
GlobalKey<FormState> key1 = GlobalKey();
bool saving = false;

class __registerScreenState extends State<registerScreen> {
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
            const SizedBox(
              height: 30,
            ),
            Form(
                key: key1,
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
                        color: Colors.blue[800],
                        title: "Register",
                        onPressed: () async {
                          if (key1.currentState!.validate()) {
                            try {
                              setState(() {
                                saving = true;
                              });
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailcontroller!.text,
                                password: passwordcontroller!.text,
                              );
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              setState(() {
                                saving = false;
                              });
                              Navigator.of(context)
                                  .pushReplacementNamed(loginScreen.root);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                          return false;
                        }),
                  ],
                )),
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
                        .pushReplacementNamed(loginScreen.root);
                  },
                  child: Container(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Login",
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
        ),
      ),
    );
  }
}
