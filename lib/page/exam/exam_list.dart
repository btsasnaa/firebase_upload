import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_upload/page/exam/my_animated_chat.dart';
import 'package:firebase_upload/page/exam/my_chat.dart';
import 'package:firebase_upload/models/my_answer_option.dart';
import 'package:firebase_upload/models/quiz_message.dart';
import 'package:flutter/material.dart';

class ExamList extends StatefulWidget {
  final String userId;

  const ExamList({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ExamList> createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {
  ScrollController _scrollController = new ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Шалгалтын жагсаалт"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('sample').snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final docData =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;
                final examName = docData['name'];
                final examId = snapshot.data?.docs[index].id;

                return GestureDetector(
                  onTap: () {
                    createExamInfo(userId: widget.userId, examId: examId!);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              // MyChatApp(
                              //       messages: getList(name),
                              //       name: name,
                              //     )
                              MyAnimatedChat(
                                messages: getList(examId),
                                userId: widget.userId,
                                examId: examId,
                                examName: examName,
                                lasIndex: getLastIndex(
                                    userId: widget.userId, examId: examId),
                              )),
                    );
                  },
                  child: ListTile(
                    title: Text(examName),
                    textColor: Colors.yellow,
                    tileColor: Colors.blue,
                  ),
                );
              },
            );
          }),
    );
  }

  Future<List<QuizMessage>> getList(String examId) async {
    final futureList = FirebaseFirestore.instance
        .collection('sample')
        .doc(examId)
        .get()
        .then((value) {
      final aaa =
          (value.data() as Map<String, dynamic>)['messages'] as List<dynamic>;

      int idIndex = 1;
      List<QuizMessage> bbb = [];
      aaa.forEach((item) {
        if (item['type'] == 'description') {
          QuizMessage qmDesc = QuizMessage(
              id: item['message_id'],
              text: item['body']['contents'],
              type: item['type'],
              subType: item['sub_type']);
          bbb.add(qmDesc);
          idIndex++;
        } else {
          final questionBody = item['body']['question'] as List<dynamic>;

          List<MyAnswerOption> choicesOptions = [];
          List<dynamic> choices = item['body']['choices'];

          choices.forEach((choice) {
            MyAnswerOption option = MyAnswerOption(text: choice);
            choicesOptions.add(option);
          });

          List<QuestionText> textList = [];
          questionBody.forEach((q) {
            QuestionText questionText = QuestionText(
              text: q['body']['contents'],
              type: q['type'],
              subType: q['sub_type'],
            );

            textList.add(questionText);
          });

          Question question = Question(
            questionText: textList,
            correctAnswer: item['body']['correct_answer'],
            correctMessage: item['body']['correct_message'],
            choices: choicesOptions,
          );

          QuizMessage qmQuestion = QuizMessage(
            id: item['message_id'],
            type: item['type'],
            subType: item['sub_type'],
            question: question,
          );
          bbb.add(qmQuestion);
          idIndex++;
        }
      });

      return bbb;
    });
    return futureList;
  }

  Future createExamInfo(
      {required String userId, required String examId}) async {
    final docUser = FirebaseFirestore.instance.collection("users").doc(userId);
    // final docExam = await docUser.collection("exams").doc(examId).get();
    final docExam = docUser.collection("exams").doc(examId);
    final docExamGet = await docExam.get();

    if (!docExamGet.exists) {
      //   docExam.update({"last_index": 1});
      // } else {
      await docExam.set({"examId": examId, "last_index": 1});
    }
    // await docExam.set({"examId": examId});
  }

  Future<int> getLastIndex(
      {required String userId, required String examId}) async {
    int retLastIndex = 1;
    final docUser = FirebaseFirestore.instance.collection("users").doc(userId);
    // final docExam = await docUser.collection("exams").doc(examId).get();
    final docExam = docUser.collection("exams").doc(examId);
    final docExamGet = await docExam.get();

    if (docExamGet.exists) {
      var data1 = docExamGet.data();
      print(data1?["last_index"]);
      if (data1?['last_index'] != null) {
        retLastIndex = (docExamGet['last_index'] as int);
      }
    }
    return retLastIndex;
  }
}
