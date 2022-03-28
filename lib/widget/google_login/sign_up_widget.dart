import 'package:firebase_upload/provider/google_provider/google_sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            FlutterLogo(size: 120),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hey there,\nWelcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Login to your account to continue",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                print(":::::::0");
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: Text("Sign Up with Google"),
            ),
            SizedBox(height: 40),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                children: [
                  TextSpan(
                      text: "Log in",
                      style: TextStyle(decoration: TextDecoration.underline)),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
