import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtEmailTemp = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: txtEmail,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: txtPassword,
              decoration: InputDecoration(hintText: "Password"),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                collectionReference
                    .where('email', isEqualTo: txtEmail.text)
                    .get()
                    .then((value) {
                  print(value.docs);
                  if (value.docs.isNotEmpty) {
                    collectionReference
                        .where('password', isEqualTo: txtPassword.text)
                        .get()
                        .then((value) {
                      if (value.docs.isNotEmpty) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(
                              body: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Text(("Here ${txtEmail.text}")))
                                  ],
                                ),
                              ),
                            );
                          },
                        ));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Your enter password is wrong",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            "This email is not register please enter registered email",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                });
              },
              child: Container(
                height: 50,
                color: Colors.blue,
                child: const Center(child: Text("Login")),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const MyHomePage();
                  },
                ));
              },
              child: Container(
                height: 50,
                color: Colors.blue,
                child: const Center(child: Text("Register")),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Wrap(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: txtEmailTemp,
                                  decoration:
                                      const InputDecoration(hintText: 'Email'),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  collectionReference
                                      .where('email',
                                          isEqualTo: txtEmailTemp.text)
                                      .get()
                                      .then((value) async {
                                    if (value.docs.isNotEmpty) {
                                      await showDialog(
                                        context: navKey.currentState!.context,
                                        builder: (context) {
                                          return Dialog(
                                              child: Wrap(children: [
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(children: [
                                                // const SizedBox(
                                                //   height: 15,
                                                // ),
                                                // const TextField(
                                                //   decoration: InputDecoration(
                                                //       hintText:
                                                //           'Current Password'),
                                                // ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                TextField(
                                                  controller: txtNewPassword,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              'New Password'),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    // print("object");
                                                    //
                                                    // print(value.docs[0].data());
                                                    // print(jsonDecode(jsonEncode(
                                                    //     value.docs[0]
                                                    //         .data()))['uid']);
                                                    final documentID =
                                                        jsonDecode(jsonEncode(
                                                                value.docs[0]
                                                                    .data()))[
                                                            'uid'];
                                                    collectionReference
                                                        .doc(documentID)
                                                        .update({
                                                      'password':
                                                          txtNewPassword.text
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Your Password Changed Successfully",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    height: 50,
                                                    color: Colors.blue,
                                                    child: const Center(
                                                        child: Text("Submit")),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ]));
                                        },
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Your enter email is not correct",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 50,
                                  color: Colors.blue,
                                  child: const Center(child: Text("Next")),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 50,
                color: Colors.blue,
                child: const Center(child: Text("Forgot Password")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
