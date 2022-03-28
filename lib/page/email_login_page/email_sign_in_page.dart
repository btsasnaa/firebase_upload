import 'package:firebase_upload/page/email_login_page/email_auth_page.dart';
import 'package:firebase_upload/page/email_login_page/email_verify_page.dart';
import 'package:firebase_upload/widget/email_login/email_logged_in_widget.dart';
import 'package:firebase_upload/widget/google_login/logged_in_widget.dart';
import 'package:firebase_upload/widget/email_login/email_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  State<EmailSignIn> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: StreamBuilder(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              // return LoggedInEmail();
              return EmailVerifyPage();
            } else if (snapshot.hasError) {
              return Center(child: Text("Something went wrong!"));
            } else {
              return EmailAuthPage();
            }
          }),
    );
  }
}
