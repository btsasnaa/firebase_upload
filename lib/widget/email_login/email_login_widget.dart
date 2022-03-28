import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_upload/main.dart';
import 'package:firebase_upload/utils.dart';
import 'package:firebase_upload/widget/email_login/email_password_reset_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginEmailWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginEmailWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginEmailWidget> createState() => _LoginEmailWidgetState();
}

class _LoginEmailWidgetState extends State<LoginEmailWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body:
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "Email"),
          ),
          SizedBox(height: 4),
          TextField(
            controller: passwordController,
            cursorColor: Color.fromARGB(255, 236, 174, 174),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              onPressed: signIn,
              icon: Icon(
                Icons.lock_open,
                size: 32,
              ),
              label: Text(
                "Sign In",
                style: TextStyle(fontSize: 24),
              )),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmailPasswordForgotPage(),
            )),
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              text: "No account? ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
              children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: "Sign Up",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
      // ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Utils.showSnackBar(e.message);
    }
    // Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
