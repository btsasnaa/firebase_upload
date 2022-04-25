import 'package:flutter/material.dart';

class HeroPage extends StatelessWidget {
  final String imgUri;
  final String tag;
  const HeroPage({Key? key, required this.imgUri, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
        transitionOnUserGestures: true,
        tag: tag,
        child: Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: RotatedBox(
                quarterTurns: 1,
                child: Image.network(
                  imgUri,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
