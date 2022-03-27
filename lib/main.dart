import 'package:firebase_upload/example/mvc_pattern/my_mvc_page.dart';
import 'package:firebase_upload/example/my_chat_app.dart';
import 'package:firebase_upload/example/my_drag_drop.dart';
import 'package:firebase_upload/example/my_image_picker.dart';
import 'package:firebase_upload/example/my_neumorphism_button.dart';
import 'package:firebase_upload/example/my_stepper_widget.dart';
import 'package:firebase_upload/page/google_sign_in_page.dart';
import 'package:firebase_upload/provider/google_sign_in_provider.dart';
import 'package:firebase_upload/widget/sign_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'image_uploads.dart';

// void main() {
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        // home: ImageUploads(),
        home: GoogleSignIn(),
        // home: MyDragDrop(),
        // home: MyNeumorphismButton(),
        // home: MyStepperWidget(),
        // home: MyChatApp(),
        // home: MyImagePicker(),
        // home: MyMVCPage(),
      ),
    );
  }
}
