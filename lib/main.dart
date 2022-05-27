import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle("BSMI 计算器");
    var tWidth = 512.0;
    var tHeight = 926.0;
    setWindowMinSize(Size(tWidth, tHeight));
    setWindowMaxSize(Size(tWidth, tHeight));
    //setWindowSize(Size(1024, 800));
    var platformWindow = await getWindowInfo();
    Rect frame = Rect.fromCenter(
      center: Offset(
        platformWindow.frame.center.dx,
        platformWindow.frame.center.dy,
      ),
      width: tWidth,
      height: tHeight,
    );
    setWindowFrame(frame);
  }
  runApp(MyApp());
}

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ); // MaterialApp
  }
}*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userInput = '';
  var answer = '';
  var answerPure = '';
  var historyAnswer = '';
  var historyAnswerPure = '';

// Array of button
  final List<String> buttons = [
    'CLS',
    'C',
    '%',
    'DEL',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '•',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BSMI 计算器"),
      ), //AppBar
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: userInput));
                        },
                        child: Text(
                          userInput,
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          userInput += answerPure;
                        });
                      },
                      child: Text(
                        answer,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          userInput += historyAnswerPure;
                        });
                      },
                      child: Text(
                        historyAnswer,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (1 / .74),
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // +/- button
                    if (index == 1) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            // historyAnswer = '';
                            userInput = '';
                            //answer = '';
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.blue[50],
                        textColor: Colors.black,
                      );
                    }
                    // Clear Button
                    else if (index == 0) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput = '';
                            answer = '';
                            historyAnswer = '';
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.blue[50],
                        textColor: Colors.black,
                      );
                    }
                    // % Button
                    else if (index == 2) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput += buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.blue[50],
                        textColor: Colors.black,
                      );
                    }
                    // Delete Button
                    else if (index == 3) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput =
                                userInput.substring(0, userInput.length - 1);
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.blue[50],
                        textColor: Colors.black,
                      );
                    }
                    // dot Button
                    else if (index == 17) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput += ".";
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.white,
                        textColor: Colors.black,
                      );
                    }
                    // Equal_to Button
                    else if (index == 18) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            equalPressed();
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.orange[700],
                        textColor: Colors.white,
                      );
                    }

                    // other buttons
                    else {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput += buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])
                            ? Colors.blueAccent
                            : Colors.white,
                        textColor: isOperator(buttons[index])
                            ? Colors.white
                            : Colors.black,
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    eval = double.parse(eval.toStringAsFixed(14));
    historyAnswer = answer;
    var asStr = eval.toString();
    if (asStr.endsWith(".0")) {
      asStr = asStr.substring(0, asStr.length - 2);
    }

    String displayInput = userInput;

    displayInput = displayInput.replaceAll("x", " x ");
    displayInput = displayInput.replaceAll("+", " + ");
    displayInput = displayInput.replaceAll("-", " - ");
    displayInput = displayInput.replaceAll("/", " / ");

    answer = displayInput + " = " + asStr;

    historyAnswerPure = answerPure;
    answerPure = asStr;
    userInput = asStr;
  }
}
