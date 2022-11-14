import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Data.dart';

void main() {
  runApp(const MyApp());
}

final data =
    Data(questions: [], answers: [], validAnswers: 0, sumGoodAnswers: 0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterLevel1Task2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'FlutterLevel1Task2'),
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
  String and(String x, String y) {
    if (x == "T" && y == "T") {
      return "T";
    } else {
      return "F";
    }
  }

  String generateTrueOrFalse() {
    final random = Random();
    const availableChars = 'FTFTFTFT';
    final randomString = List.generate(
            1, (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    data.questions.add(randomString);

    if (data.questions.length == 8) {
      data.answers.add(and(data.questions[0], data.questions[1]));
      data.answers.add(and(data.questions[2], data.questions[3]));
      data.answers.add(and(data.questions[4], data.questions[5]));
      data.answers.add(and(data.questions[6], data.questions[7]));
    }

    return randomString;
  }

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  int sumOfGoodAnswersByUser = 0;
  int validAnswersByUser = 0;

  @override
  Widget build(BuildContext context) {
    data.questions.clear();
    data.answers.clear();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Conjunction (AND)',
            style: TextStyle(fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'A',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                'B',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                'A ^ B',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          QuestionAnswerSection(
              controller: controllers[0],
              combi: generateTrueOrFalse(),
              combi2: generateTrueOrFalse()),
          QuestionAnswerSection(
              controller: controllers[1],
              combi: generateTrueOrFalse(),
              combi2: generateTrueOrFalse()),
          QuestionAnswerSection(
              controller: controllers[2],
              combi: generateTrueOrFalse(),
              combi2: generateTrueOrFalse()),
          QuestionAnswerSection(
              controller: controllers[3],
              combi: generateTrueOrFalse(),
              combi2: generateTrueOrFalse()),
          ButtonSection(controllers),
        ],
      ),
    );
  }
}

class QuestionAnswerSection extends StatefulWidget {
  const QuestionAnswerSection(
      {Key? key,
      required this.controller,
      required this.combi,
      required this.combi2})
      : super(key: key);

  final TextEditingController controller;
  final String combi, combi2;

  @override
  State<QuestionAnswerSection> createState() => _QuestionAnswerSectionState();
}

class _QuestionAnswerSectionState extends State<QuestionAnswerSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Center(
            child: Text(
              widget.combi,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              widget.combi2,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
        AnswerTextField(controller: widget.controller)
      ],
    );
  }
}

class AnswerTextField extends StatefulWidget {
  const AnswerTextField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  State<AnswerTextField> createState() => _AnswerTextFieldState();
}

class _AnswerTextFieldState extends State<AnswerTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: widget.controller,
        decoration: const InputDecoration(
          hintText: "T or F",
        ),
      ),
    );
  }
}

class ButtonSection extends StatefulWidget {
  const ButtonSection(this.controllers, {super.key});

  final List<TextEditingController> controllers;

  @override
  State<ButtonSection> createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  void _checkValue(String answer, TextEditingController givenAnswer) {
    if (givenAnswer.text == answer) { data.sumGoodAnswers += 1; }
    if (givenAnswer.text.isNotEmpty) { data.validAnswers += 1; }
    if(data.validAnswers == 4) {
      notification("Correct questions: ${data.sumGoodAnswers}");
    } else {
      notification("Invalid questions: ${4 - data.validAnswers}");
    }
  }

  void notification(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: Colors.blue,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            _checkValue(data.answers[0], widget.controllers[0]);
            _checkValue(data.answers[1], widget.controllers[1]);
            _checkValue(data.answers[2], widget.controllers[2]);
            _checkValue(data.answers[3], widget.controllers[3]);

            data.sumGoodAnswers = 0;
            data.validAnswers = 0;
          });
        },
        child: const Text('SUBMIT'));
  }
}
