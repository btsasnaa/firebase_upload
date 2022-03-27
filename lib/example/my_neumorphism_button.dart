import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class MyNeumorphismButton extends StatefulWidget {
  const MyNeumorphismButton({Key? key}) : super(key: key);

  @override
  State<MyNeumorphismButton> createState() => _MyNeumorphismButtonState();
}

class _MyNeumorphismButtonState extends State<MyNeumorphismButton> {
  bool isPressed = false;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final backGroundColor =
        isDarkMode ? const Color(0xFF2E3239) : const Color(0xFFE7ECEF);
    final color2 = const Color(0xFFA7A9AF);
    Offset distance = isPressed ? Offset(10, 10) : Offset(28, 28);
    double blur = isPressed ? 5.0 : 30.0;

    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isPressed = !isPressed;
            });
          },
          // Listener(
          //   onPointerUp: (_) {
          //     setState(() {
          //       isPressed = false;
          //     });
          //   },
          //   onPointerDown: (_) {
          //     setState(() {
          //       isPressed = true;
          //     });
          //   },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: backGroundColor,
              boxShadow:
                  // isPressed
                  //     ? []
                  //     :
                  [
                BoxShadow(
                  blurRadius: blur,
                  offset: -distance,
                  color: isDarkMode ? Color(0xFF35393F) : Colors.white,
                  inset: isPressed,
                  // inset: true,
                ),
                BoxShadow(
                  blurRadius: blur,
                  offset: distance,
                  color: isDarkMode ? Color(0xFF23262A) : color2,
                  inset: isPressed,
                  // inset: true,
                ),
              ],
            ),
            child: SizedBox(height: 200, width: 200),
          ),
        ),
      ),
    );
  }
}
