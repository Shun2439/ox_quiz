import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future<List<List>> csvImport() async {
  final File importFile = File('quiz.csv');
  List<List> importList = [];

  Stream fread = importFile.openRead();

  // Read lines one by one, and split each ','
  await fread.transform(utf8.decoder).transform(LineSplitter()).listen(
    (String line) {
      importList.add(line.split(','));
    },
  ).asFuture();

  return Future<List<List>>.value(importList);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ox_quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ox_quiz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //ユーザーの解答
  int userSelect = 2;

  //正解または不正解
  String ansText = '';

  bool showAnsText = true;

  //問題文
  var question = <String>[
    "高専の教室には授業用の黒板が２つある",
    "高専には書道の授業がある",
    "高専では授業でなでしこをならう",
    "高専ではテストで60点未満をとってはいけない",
  ];

  //問題の答え
  var answer = <int>[
    1,
    0,
    0,
    1,
  ];

  //問題番号
  int questionNumber = 0;

  int correctCount = 0;

  bool buttonEnable = true;

  bool showEndMessage = false;

  checkAnswer() {
    if (userSelect == answer[questionNumber]) {
      ansText = '正解です！';
      correctCount++;
    } else {
      ansText = '不正解です！';
    }
    if (questionNumber < question.length - 1) {
      questionNumber++;
    } else {
      buttonEnable = false;
      showAnsText = false;
      showEndMessage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '問題:${questionNumber + 1}/${question.length}',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Text(
              '${question[questionNumber]}',
              style: TextStyle(
                fontSize: 50,
              ),
            ),
            ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding:
                    EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                children: [
                  SizedBox(
                    height: 100,
                    width: 300,
                    child: ElevatedButton(
                      child: const Text(
                        '⭕',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 100,
                      ),
                      onPressed: buttonEnable
                          ? () {
                              setState(() {
                                userSelect = 1;
                                checkAnswer();
                              });
                            }
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 300,
                    child: ElevatedButton(
                      child: const Text(
                        '❌',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 100,
                      ),
                      onPressed: buttonEnable
                          ? () {
                              setState(() {
                                userSelect = 0;
                                checkAnswer();
                              });
                            }
                          : null,
                    ),
                  ),
                ]),
            if (showAnsText)
              Text(
                '$ansText',
                style: TextStyle(fontSize: 40),
              ),
            if (showEndMessage)
              Text(
                'クイズが終了しました\nF5を押してください',
                style: TextStyle(fontSize: 40),
              ),
            Text(
              '正解数:${correctCount}/${question.length}',
              style: TextStyle(fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
