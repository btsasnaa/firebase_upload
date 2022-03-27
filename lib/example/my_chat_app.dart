import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class MyChatApp extends StatefulWidget {
  const MyChatApp({Key? key}) : super(key: key);

  @override
  State<MyChatApp> createState() => _MyChatAppState();
}

class _MyChatAppState extends State<MyChatApp> {
  List<Message> messages = [
    Message(
        text: DateTime.now().subtract(Duration(minutes: 1)).toString(),
        date: DateTime.now().subtract(Duration(minutes: 1)),
        isSentByMe: false),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 3, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 3, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 3, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 3, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 3, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 3, minutes: 4)),
        isSentByMe: false),
    Message(
        text: DateTime.now().subtract(Duration(days: 4, minutes: 8)).toString(),
        date: DateTime.now().subtract(Duration(days: 4, minutes: 8)),
        isSentByMe: false),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 4, minutes: 9)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 4, minutes: 10)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 5, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 6, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 6, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 6, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 6, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 6, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 6, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(days: 1, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'yes sure',
        date: DateTime.now().subtract(Duration(minutes: 10)),
        isSentByMe: true),
  ].reversed.toList();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Chat app"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messages,
              groupBy: (message) => DateTime(
                message.date.year,
                message.date.month,
                message.date.day,
              ),
              groupHeaderBuilder: (Message message) => SizedBox(
                height: 56,
                child: Center(
                  child: Card(
                    margin: EdgeInsets.all(8),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        DateFormat.yMMMd().format(message.date),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              itemBuilder: (context, Message message) => Align(
                alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(message.text),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 32),
            color: Colors.grey.shade300,
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: "Type your message here...",
              ),
              onSubmitted: (text) {
                final message = Message(
                  text: text,
                  date: DateTime.now(),
                  isSentByMe: true,
                );
                setState(() {
                  messages.add(message);
                });
              },
            ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}
