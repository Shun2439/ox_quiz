import 'package:flutter/material.dart';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

//csvの読み込み
Future<List<List<dynamic>>> loadCsvData() async {
  final csvData = await rootBundle.loadString('quiz.csv');
  List<List<dynamic>> questions = const CsvToListConverter().convert(csvData);
  return questions;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ox_quiz',
      debugShowCheckedModeBanner: false,
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
  List<List<dynamic>> questions = [];

  int currentQuestion = 0;

  bool buttonEnable = true;

  int userSelect = 2;

  String ansText = "";

  int correctCount = 0;

  bool showAnsText = true;

  bool showEndMessage = false;

  checkAnswer() {
    if (userSelect == questions[currentQuestion][1]) {
      ansText = '正解です！';
      correctCount++;
    } else {
      ansText = '不正解です！';
    }
    if (currentQuestion < questions.length - 1) {
      currentQuestion++;
    } else {
      buttonEnable = false;
      showAnsText = false;
      showEndMessage = true;
    }
  }

  @override
  void initState() {
    super.initState();
    loadCsvData().then((loadedQuestions) {
      setState(() {
        questions = loadedQuestions;
      });
    });
  }
  // _loadCSV();

  // setState(() {
  //   for (var i = 0; i < _data.length; i++) {
  //     question.add(_data[i][0].join(""));
  //   }

  //   for (var i = 0; i < _data.length; i++) {
  //     answer.add(_data[i][1]);
  //   }
  // });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: (questions.isEmpty)
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //開始ボタン
                Text(
                  '問題:${currentQuestion + 1}/${questions.length}',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  '${questions[currentQuestion][0]}',
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
                                    showAnsText = true;
                                    checkAnswer();
                                    Future.delayed(Duration(seconds: 3), () {
                                      setState(() {
                                        showAnsText = false;
                                      });
                                    });
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
                                    showAnsText = true;
                                    checkAnswer();
                                    Future.delayed(Duration(seconds: 3), () {
                                      setState(() {
                                        showAnsText = false;
                                      });
                                    });
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
                  '正解数:${correctCount}/${questions.length}',
                  style: TextStyle(fontSize: 40),
                ),
              ],
            ),
    );
  }
}
