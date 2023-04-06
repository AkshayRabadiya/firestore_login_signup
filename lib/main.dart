import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_login_signup/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navKey,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhoneNo = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: txtEmail,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: txtPhoneNo,
              decoration: const InputDecoration(hintText: "PhoneNo"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: txtPassword,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () async {
                collectionReference
                    .where('email', isEqualTo: txtEmail.text)
                    .get()
                    .then((value) {
                  if (value.docs.isEmpty) {
                    final id = collectionReference.doc();
                    id.set({
                      'name': txtName.text,
                      'email': txtEmail.text,
                      'phoneNo': txtPhoneNo.text,
                      'password': txtPassword.text,
                      'uid': id.id
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "This email already register",
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
                child: const Center(child: Text("Register")),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const LoginScreen();
                  },
                ));
              },
              child: Container(
                height: 50,
                color: Colors.blue,
                child: const Center(child: Text("Login")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
