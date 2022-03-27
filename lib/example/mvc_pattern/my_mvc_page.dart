import 'package:firebase_upload/example/mvc_pattern/my_mvc_controller.dart';
import 'package:flutter/material.dart';

class MyMVCPage extends StatefulWidget {
  const MyMVCPage({Key? key}) : super(key: key);
  final String title = 'MVC Pattern';
  final String title1 = 'Push button up, down';

  @override
  State<MyMVCPage> createState() => _MyMVCPageState();
}

class _MyMVCPageState extends State<MyMVCPage> {
  final MyMVCController con = MyMVCController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.title1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    setState(
                      () {
                        con.decrementCounter();
                      },
                    );
                  },
                  tooltip: 'Decrement',
                  child: Icon(Icons.remove),
                ),
                Text(con != null ? '${con.counter}' : 'Hi'),
                FloatingActionButton(
                  onPressed: () {
                    setState(
                      () {
                        con.incrementCounter();
                      },
                    );
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
