import 'package:flutter/material.dart';

class MyDragDrop extends StatefulWidget {
  const MyDragDrop({Key? key}) : super(key: key);

  @override
  State<MyDragDrop> createState() => _MyDragDropState();
}

class _MyDragDropState extends State<MyDragDrop> {
  List<Color> stack1 = [Colors.red, Colors.blue];
  List<Color> stack2 = [Colors.green];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            buildStack(stack1),
            buildStack(stack2),
          ],
        ),
      ),
    );
  }

  Widget buildStack(List<Color> stack) => DragTarget<Color>(
        onAccept: (data) {
          if (stack.isNotEmpty && data == stack.last) return;

          setState(() {
            stack.add(data);

            final otherStacks = [stack1, stack2]..remove(stack);
            for (final stack in otherStacks) {
              stack.remove(data);
            }
          });
        },
        builder: (context, _, __) => Stack(
          children: [
            Container(
              color: Colors.black,
              width: 200,
              height: 200,
              child: const Center(
                child: Text(
                  "Empty",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            ...stack.map(buildStackItem).toList(),
          ],
        ),
      );

  Widget buildStackItem(Color color) {
    final coloredBox = Container(
      color: color,
      width: 200,
      height: 200,
    );
    return Draggable<Color>(
      child: coloredBox,
      feedback: coloredBox,
      data: color,
      childWhenDragging: const SizedBox(
        width: 200,
        height: 200,
      ),
    );
  }
}
