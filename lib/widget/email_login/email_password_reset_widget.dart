import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_upload/main.dart';
import 'package:firebase_upload/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EmailPasswordForgotPage extends StatefulWidget {
  const EmailPasswordForgotPage({Key? key}) : super(key: key);

  @override
  State<EmailPasswordForgotPage> createState() =>
      _EmailPasswordForgotPageState();
}

class _EmailPasswordForgotPageState extends State<EmailPasswordForgotPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Reset Password"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Receive an email to \nreset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: resetPassword,
                  icon: Icon(
                    Icons.email_outlined,
                    size: 32,
                  ),
                  label: Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 24),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar("Password Reset Email Sent");
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
