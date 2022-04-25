import 'package:flutter/material.dart';

class MyChatButton extends StatelessWidget {
  bool isfinished;
  MyChatButton({
    Key? key,
    this.isfinished = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.maxFinite,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.greenAccent,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 151, 149, 149),
            blurRadius: 3.0,
            offset: Offset(3, 3),
          ),
          BoxShadow(
            color: Color.fromARGB(255, 151, 149, 149),
            blurRadius: 3.0,
            offset: Offset(-3, 0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          isfinished ? "Finish" : "Next",
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
