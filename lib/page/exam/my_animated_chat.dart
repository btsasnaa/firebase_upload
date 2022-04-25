import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_upload/models/quiz_message.dart';
import 'package:firebase_upload/page/exam/hero_page.dart';
import 'package:firebase_upload/widget/exam/my_chat_button.dart';
import 'package:flutter/material.dart';

class MyAnimatedChat extends StatefulWidget {
  final Future<List<QuizMessage>> messages;
  final String userId;
  final String examId;
  final String examName;
  final Future<int> lasIndex;
  const MyAnimatedChat({
    Key? key,
    required this.messages,
    required this.userId,
    required this.examId,
    required this.examName,
    required this.lasIndex,
  }) : super(key: key);

  @override
  State<MyAnimatedChat> createState() => _MyAnimatedState();
}

class _MyAnimatedState extends State<MyAnimatedChat> {
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

  // The key of the list
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.lasIndex.then((value) => _lastIndex = value);
    widget.messages.then((value) {
      _messagesOrig.addAll(value);
      _messageCount = _messagesOrig.length;
      _totalQuestionCount =
          _messagesOrig.where((x) => x.type == 'question').length;

      setState(() {
        if (_lastIndex > 1) {
          for (var i = 1; i < _lastIndex; i++) {
            print(i);
            _messagesDisplayed.insert(0, _messagesOrig[i - 1]);
            _key.currentState!
                .insertItem(0, duration: const Duration(milliseconds: 500));
          }
        } else {
          _messagesDisplayed.add(_messagesOrig.first);
          _key.currentState!
              .insertItem(0, duration: const Duration(milliseconds: 500));
        }
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.examName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.blue.shade100,
              child: AnimatedList(
                key: _key,
                controller: _scrollController,
                initialItemCount: 0,
                reverse: true,
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemBuilder: (_, index, animation) {
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
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(-1, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
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
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors
                                                      .blue, // Change this value to update the progress
                                                ),
                                              ),
                                              Container(
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
                                                  color: Colors.transparent,
                                                  border:
                                                      Border.all(width: 0.3),
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(-1, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
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
                                              message.question!.questionText[i]
                                                  .text,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
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
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: Column(
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
                                                      message.question!
                                                          .choices[i].text);
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
                                                    ? (message
                                                            .question!
                                                            .choices[i]
                                                            .isCorrect
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
                            ),
                          ],
                        ));
                  } else {
                    // Description
                    // sub type: image
                    if (message.subType == 'image') {
                      return SizeTransition(
                        key: UniqueKey(),
                        sizeFactor: animation,
                        child: GestureDetector(
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
                              width: _width - 16,
                              height: (_width - 16) / 3,
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
                        ),
                      );
                    } else {
                      // sub type: text
                      return SizeTransition(
                        key: UniqueKey(),
                        sizeFactor: animation,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              // elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  message.text!,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            )),
                      );
                    }
                  }
                },
              ),

              // ListView.builder(
              //   controller: _scrollController,
              //   reverse: true,
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.all(8),
              //   itemCount: _messagesDisplayed.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     var message = _messagesDisplayed[index];
              //     if (message.type == 'question') {
              //       return Align(
              //           alignment: Alignment.center,
              //           child: Column(
              //             children: [
              //               SizedBox(height: 20),
              //               // question
              //               Column(
              //                 children: List<Align>.generate(
              //                     message.question!.questionText.length, (i) {
              //                   if (message.question!.questionText[i].subType ==
              //                       'image') {
              //                     return Align(
              //                       alignment: Alignment.center,
              //                       child: GestureDetector(
              //                         onTap: () {
              //                           Navigator.of(context).push(
              //                             MaterialPageRoute(
              //                               builder: (context) => HeroPage(
              //                                   key: widget.key,
              //                                   imgUri: message.question!
              //                                       .questionText[i].text,
              //                                   tag: message.question!
              //                                       .questionText[i].text
              //                                       .toString()),
              //                             ),
              //                           );
              //                         },
              //                         child: Hero(
              //                           tag: message
              //                               .question!.questionText[i].text
              //                               .toString(),
              //                           child: Container(
              //                             width: MediaQuery.of(context)
              //                                     .size
              //                                     .width -
              //                                 16,
              //                             height: (MediaQuery.of(context)
              //                                         .size
              //                                         .width -
              //                                     16) /
              //                                 3,
              //                             decoration: BoxDecoration(
              //                               color: Colors.grey.shade300,
              //                               borderRadius:
              //                                   BorderRadius.circular(10),
              //                               image: DecorationImage(
              //                                 fit: BoxFit.fitWidth,
              //                                 image: NetworkImage(message
              //                                     .question!
              //                                     .questionText[i]
              //                                     .text),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     );
              //                   } else {
              //                     return Align(
              //                       alignment: Alignment.center,
              //                       child: Container(
              //                         constraints: BoxConstraints(
              //                             minWidth: double.infinity),
              //                         child: Card(
              //                           color:
              //                               Color.fromARGB(255, 103, 40, 219),
              //                           shape: RoundedRectangleBorder(
              //                             borderRadius:
              //                                 BorderRadius.circular(5),
              //                           ),
              //                           margin:
              //                               EdgeInsets.symmetric(vertical: 4),
              //                           child: Padding(
              //                             padding: const EdgeInsets.all(12),
              //                             child: Text(
              //                               message
              //                                   .question!.questionText[i].text,
              //                               style: TextStyle(
              //                                   fontSize: 20,
              //                                   color: Colors.white),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     );
              //                   }
              //                 }),
              //               ),
              //               SizedBox(height: 8),
              //               // answer options
              //               Column(
              //                 children: List<Align>.generate(
              //                     message.question!.choices.length,
              //                     (i) => Align(
              //                           alignment: Alignment.centerRight,
              //                           child: Container(
              //                             constraints: BoxConstraints(
              //                                 minWidth: double.infinity),
              //                             child: GestureDetector(
              //                               onTap: () {
              //                                 if (!message
              //                                     .question!.isSelected) {
              //                                   answerQuestion(
              //                                       message,
              //                                       message.question!.choices[i]
              //                                           .text);
              //                                 }
              //                               },
              //                               child: Card(
              //                                 shape: RoundedRectangleBorder(
              //                                   borderRadius:
              //                                       BorderRadius.circular(20),
              //                                 ),
              //                                 margin: EdgeInsets.only(
              //                                     left: (message
              //                                             .question!
              //                                             .choices[i]
              //                                             .isSelected)
              //                                         ? 64
              //                                         : 32,
              //                                     top: 4,
              //                                     bottom: 4),
              //                                 color: message.question!
              //                                         .choices[i].isSelected
              //                                     ? (message.question!
              //                                             .choices[i].isCorrect
              //                                         ? Color.fromARGB(
              //                                             255, 56, 199, 130)
              //                                         : Color.fromARGB(
              //                                             255, 247, 154, 219))
              //                                     : Color.fromARGB(
              //                                         255, 251, 251, 250),
              //                                 child: Padding(
              //                                   padding:
              //                                       const EdgeInsets.all(12),
              //                                   child: Text(
              //                                     message.question!.choices[i]
              //                                         .text,
              //                                     style: TextStyle(
              //                                         fontSize: 18,
              //                                         color: Colors.black),
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         )),
              //               ),
              //             ],
              //           ));
              //     } else {
              //       // Description
              //       // sub type: image
              //       if (message.subType == 'image') {
              //         return GestureDetector(
              //           onTap: () {
              //             Navigator.of(context).push(
              //               MaterialPageRoute(
              //                 builder: (context) => HeroPage(
              //                     key: widget.key,
              //                     imgUri: message.text!,
              //                     tag: message.id.toString()),
              //               ),
              //             );
              //           },
              //           child: Hero(
              //             tag: message.id.toString(),
              //             child: Container(
              //               width: MediaQuery.of(context).size.width - 16,
              //               height:
              //                   (MediaQuery.of(context).size.width - 16) / 3,
              //               decoration: BoxDecoration(
              //                 color: Colors.grey.shade300,
              //                 borderRadius: BorderRadius.circular(10),
              //                 image: DecorationImage(
              //                   fit: BoxFit.fitWidth,
              //                   image: NetworkImage(message.text!),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         );
              //       } else {
              //         // sub type: text
              //         return Align(
              //             alignment: Alignment.centerLeft,
              //             child: Card(
              //               margin: EdgeInsets.symmetric(vertical: 8),
              //               elevation: 8,
              //               child: Padding(
              //                 padding: const EdgeInsets.all(12),
              //                 child: Text(
              //                   message.text!,
              //                   style: TextStyle(fontSize: 20),
              //                 ),
              //               ),
              //             ));
              //       }
              //     }
              //   },
              // ),
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
        // Add a new item to the list
        _messagesDisplayed.insert(0, _messagesOrig[_lastIndex]);
        _key.currentState!
            .insertItem(0, duration: const Duration(milliseconds: 500));
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
            _key.currentState!
                .insertItem(0, duration: const Duration(milliseconds: 500));
          }
        });
      }
    }
    updateExamInfo(userId: widget.userId, examId: widget.examId);

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
      _messagesDisplayed.insert(0, correctMessage);
      _key.currentState!
          .insertItem(0, duration: const Duration(milliseconds: 500));
      _nextVisibility = true;
    });

    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future updateExamInfo(
      {required String userId, required String examId}) async {
    final docUser = FirebaseFirestore.instance.collection("users").doc(userId);
    final docExam = docUser.collection("exams").doc(examId);

    final docExamGet = await docExam.get();

    if (docExamGet.exists) {
      docExam.update({
        "last_index": _lastIndex,
        "city.name": "UB",
        "city.address": "Address 1"
      });
    } else {
      await docExam.set({
        "last_index": _lastIndex,
      });
    }
  }
}
