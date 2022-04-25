import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_upload/models/quiz_message.dart';
import 'package:firebase_upload/page/exam/hero_page.dart';
import 'package:firebase_upload/widget/exam/my_chat_button.dart';
import 'package:flutter/material.dart';

class MyChatApp extends StatefulWidget {
  final Future<List<QuizMessage>> messages;
  final String name;
  const MyChatApp({
    Key? key,
    required this.messages,
    required this.name,
  }) : super(key: key);

  @override
  State<MyChatApp> createState() => _MyChatAppState();
}

class _MyChatAppState extends State<MyChatApp> {
  ScrollController _scrollController = new ScrollController();
  List<QuizMessage> _messagesOrig = [];
  List<QuizMessage> _messagesDisplayed = [];
  late QuizMessage _nextMessage;
  late int _messageCount;
  int _lastIndex = 1;
  bool _nextVisibility = true;
  bool _finished = false;
  int _totalQuestionCount = 0;
  int _correctCount = 0;
  int _incorrectCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.messages.then((value) {
      _messagesOrig.addAll(value);
      _messageCount = _messagesOrig.length;
      _totalQuestionCount =
          _messagesOrig.where((x) => x.type == 'question').length;

      setState(() {
        _messagesDisplayed.add(_messagesOrig.first);
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.blue.shade100,
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: _messagesDisplayed.length,
                itemBuilder: (BuildContext context, int index) {
                  var message = _messagesDisplayed[index];
                  if (message.type == 'question') {
                    return Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            // question
                            Column(
                              children: List<Align>.generate(
                                  message.question!.questionText.length, (i) {
                                if (message.question!.questionText[i].subType ==
                                    'image') {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => HeroPage(
                                                key: widget.key,
                                                imgUri: message.question!
                                                    .questionText[i].text,
                                                tag: message.question!
                                                    .questionText[i].text
                                                    .toString()),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: message
                                            .question!.questionText[i].text
                                            .toString(),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              16,
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  16) /
                                              3,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: NetworkImage(message
                                                  .question!
                                                  .questionText[i]
                                                  .text),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      constraints: BoxConstraints(
                                          minWidth: double.infinity),
                                      child: Card(
                                        color:
                                            Color.fromARGB(255, 103, 40, 219),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            message
                                                .question!.questionText[i].text,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ),
                            SizedBox(height: 8),
                            // answer options
                            Column(
                              children: List<Align>.generate(
                                  message.question!.choices.length,
                                  (i) => Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          constraints: BoxConstraints(
                                              minWidth: double.infinity),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!message
                                                  .question!.isSelected) {
                                                answerQuestion(
                                                    message,
                                                    message.question!.choices[i]
                                                        .text);
                                              }
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: (message
                                                          .question!
                                                          .choices[i]
                                                          .isSelected)
                                                      ? 64
                                                      : 32,
                                                  top: 4,
                                                  bottom: 4),
                                              color: message.question!
                                                      .choices[i].isSelected
                                                  ? (message.question!
                                                          .choices[i].isCorrect
                                                      ? Color.fromARGB(
                                                          255, 56, 199, 130)
                                                      : Color.fromARGB(
                                                          255, 247, 154, 219))
                                                  : Color.fromARGB(
                                                      255, 251, 251, 250),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Text(
                                                  message.question!.choices[i]
                                                      .text,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                            ),
                          ],
                        ));
                  } else {
                    // Description
                    // sub type: image
                    if (message.subType == 'image') {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HeroPage(
                                  key: widget.key,
                                  imgUri: message.text!,
                                  tag: message.id.toString()),
                            ),
                          );
                        },
                        child: Hero(
                          tag: message.id.toString(),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 16,
                            height:
                                (MediaQuery.of(context).size.width - 16) / 3,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(message.text!),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // sub type: text
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                message.text!,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ));
                    }
                  }
                },
              ),
            ),
          ),
          Visibility(
            visible: _nextVisibility,
            // visible: true,
            child: Container(
              color: Colors.blue.shade100,
              child: GestureDetector(
                onTap: () {
                  goNext();
                },
                child: MyChatButton(isfinished: _finished),
              ),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  goNext() {
    if (_finished) {
      Navigator.pop(context);
    }
    if (_lastIndex < _messageCount) {
      setState(() {
        // _messagesDisplayed.add(_messagesOrig[_lastIndex]);
        _messagesDisplayed.insert(0, _messagesOrig[_lastIndex]);
        _nextVisibility = _messagesOrig[_lastIndex].type != 'question';
      });
      _lastIndex++;
    } else {
      if (!_finished) {
        setState(() {
          _finished = true;

          if ((_correctCount + _incorrectCount) == _totalQuestionCount) {
            double correctPercent = _correctCount / _totalQuestionCount;

            QuizMessage resultMessage = QuizMessage(
              id: "finish",
              text: correctPercent >= 0.9
                  ? "БАЯР ХҮРГЭЕ. ТА ШАЛГАЛТАНД ТЭНЦЛЭЭ"
                  : "УУЧЛААРАЙ. ТА ШАЛГАЛТАНД УНАЛАА",
              type: "description",
              subType: "text",
            );
            // _messagesDisplayed.add(resultMessage);
            _messagesDisplayed.insert(0, resultMessage);
          }
        });
      }
    }

    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
  }

  void answerQuestion(QuizMessage message, String answer) {
    bool isCorrect = (answer == message.question!.correctAnswer);
    if (isCorrect)
      _correctCount++;
    else
      _incorrectCount++;

    QuizMessage correctMessage = QuizMessage(
      id: "${message.id}-correctMessage",
      text: "Хариулт " +
          (isCorrect ? "зөв" : "буруу") +
          " байна.\n" +
          message.question!.correctMessage,
      type: "description",
      subType: "text",
    );

    setState(() {
      message.question!.setSelected(answer);
      // _messagesDisplayed.add(correctMessage);
      _messagesDisplayed.insert(0, correctMessage);
      _nextVisibility = true;
    });

    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
  }
}
