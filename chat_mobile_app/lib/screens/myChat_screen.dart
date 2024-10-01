import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_mobile_app/auth/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class mychat extends StatefulWidget {
  static const String root = "chatscreen";
  const mychat({super.key});

  @override
  State<mychat> createState() => _mychatState();
}

TextEditingController? messageController = TextEditingController();
GlobalKey<FormState> key5 = GlobalKey();

class _mychatState extends State<mychat> {
  final _auth = FirebaseAuth.instance;
  User? signinuser;
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('users')
      .orderBy('time')
      .snapshots();
  @override
  void initState() {
    getSigninuser();
    super.initState();
  }

  void getSigninuser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          signinuser = user;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<Map<String, dynamic>> data = [];

  addData() {
    try {
      users.add({
        "message": messageController!.text,
        "sender": signinuser!.email,
        "time": FieldValue.serverTimestamp(),
      }).then((value) {
        print("User Added");
      }).catchError((error) => print("Failed to add user: $error"));

      Navigator.of(context).pushReplacementNamed(
        "homepage",
      );
    } catch (e) {
      print("Error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Container(height: 30, child: Image.asset("images/logo.png")),
            const SizedBox(
              width: 8,
            ),
            Text("Chat")
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: 'Sign Out',
                  desc: 'Are You Sure Signout.',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed(
                      loginScreen.root,
                    );
                  },
                ).show();
              },
              icon: const Icon(Icons.close)),
        ],
      ),
      body: SafeArea(
          child: Form(
        key: key5,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: usersStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print("Error");
                        return Text("Something went wrong!");
                      }

                      // Handle loading state
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        print("loading....");
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ); // Return a loading spinner
                      }

                      // Handle no data or empty collection
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        print("data not valid");
                        return const Text(
                            "No data available"); // Return message for no data
                      }
                      return ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var messageData = snapshot.data!.docs[index];
                            bool isMe =
                                signinuser!.email == messageData["sender"];
                            return Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data!.docs[index]["sender"]}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 243, 136, 43),
                                    fontSize: 12,
                                  ),
                                ),
                                Material(
                                  color: isMe ? Colors.blue[800] : Colors.white,
                                  borderRadius: isMe
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20))
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Text(
                                      "${snapshot.data!.docs[index]["message"]}",
                                      style: TextStyle(
                                        color:
                                            isMe ? Colors.white : Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    }),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                    color: Color.fromARGB(255, 245, 127, 23),
                    width: 3,
                  )),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: messageController,
                      validator: (ValueKey) {
                        if (ValueKey!.isEmpty) {
                          return "this field can't be empty";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        hintText: "Write Your Message Here",
                        border: InputBorder.none,
                      ),
                    )),
                    TextButton(
                        onPressed: () {
                          if (key5.currentState!.validate()) {
                            addData();
                            messageController!.clear();
                          }
                        },
                        child: Text(
                          "send",
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
