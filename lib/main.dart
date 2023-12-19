//csvの読み込みをするために使う？
import 'dart:async';
import 'dart:math';

//csvのパッケージ
import 'package:csv/csv.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//csvの読み込みをする関数
Future<List<List<dynamic>>> loadCsvData() async {
  //生のデータを読む（？）
  final csvData = await rootBundle.loadString('assets/quiz.csv');

  //データを切り分けて扱いやすいようにする
  List<List<dynamic>> questions = const CsvToListConverter().convert(csvData);

  //データを返す
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

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<dynamic>> questions = [];

  int currentQuestion = 0;

  //o:1, x:0
  int userSelect = 2;

  int correctCount = 0;

  String ansText = "";

  //クイズが終了したら押せなくする
  bool buttonEnable = true;

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

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: (questions.isEmpty)
          //読み込むまでまつ
          ? const CircularProgressIndicator()
          //読み込んだらクイズを表示
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //開始ボタン
                Text(
                  '問題:${currentQuestion + 1}/${questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  // ignore: deprecated_member_use
                  textScaleFactor: ScaleSize.textScaleFactor(context),
                ),
                Text(
                  '${questions[currentQuestion][0]}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  // ignore: deprecated_member_use
                  textScaleFactor: ScaleSize.textScaleFactor(context),
                ),
                ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonPadding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 10),
                    children: [
                      SizedBox(
                        height: 100,
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
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
                                    //関数を使ってみる
                                    checkAnswer();
                                    //回答結果を5秒間表示
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      setState(() {
                                        showAnsText = false;
                                      });
                                    });
                                  });
                                }
                              : null,
                          child: Text(
                            '⭕',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                            // ignore: deprecated_member_use
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
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
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      setState(() {
                                        showAnsText = false;
                                      });
                                    });
                                  });
                                }
                              : null,
                          child: Text(
                            '❌',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                            // ignore: deprecated_member_use
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                        ),
                      ),
                    ]),
                Text(
                  ansText,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  // ignore: deprecated_member_use
                  textScaleFactor: ScaleSize.textScaleFactor(context),
                ),
                if (showEndMessage)
                  Text(
                    'クイズが終了しました\nF5を押してください',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    // ignore: deprecated_member_use
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                Text(
                  '正解数:$correctCount/${questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  // ignore: deprecated_member_use
                  textScaleFactor: ScaleSize.textScaleFactor(context),
                ),
              ],
            ),
    );
  }
}
