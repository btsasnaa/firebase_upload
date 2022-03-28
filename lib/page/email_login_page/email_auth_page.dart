import 'package:firebase_upload/widget/email_login/email_login_widget.dart';
import 'package:firebase_upload/widget/email_login/email_sign_up_widget.dart';
import 'package:flutter/material.dart';

class EmailAuthPage extends StatefulWidget {
  const EmailAuthPage({Key? key}) : super(key: key);

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginEmailWidget(onClickedSignUp: toggle)
        : SignUpEmailWidget(onCLickedSignIn: toggle);
  }

  void toggle() => setState(() => isLogin = !isLogin);
}
