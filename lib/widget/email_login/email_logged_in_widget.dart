import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_upload/models/exam_user.dart';
import 'package:firebase_upload/page/exam/exam_list.dart';
import 'package:flutter/material.dart';

class EmailLoggedIn extends StatelessWidget {
  const EmailLoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Logged In Email"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        color: Colors.blueGrey.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Signed in as",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Email: " + user.email!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExamList(userId: user.uid)),
                  );
                  createUser(user: user);
                },
                icon: Icon(
                  Icons.list_alt_outlined,
                  size: 32,
                ),
                label: Text(
                  "Exam List",
                  style: TextStyle(fontSize: 24),
                )),
          ],
        ),
      ),
    );
  }

  Future createUser({required User user}) async {
    final docUser =
        FirebaseFirestore.instance.collection("users").doc(user.uid);
    final examUser =
        ExamUser(uid: user.uid, email: user.email!, name: user.displayName!);
    final json = examUser.toJson();
    await docUser.set(json);
  }
}
