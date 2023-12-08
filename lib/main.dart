import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String firstValue = "";
  String operator = "";
  String secondValue = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          //screen
          Expanded(
            child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "$firstValue$operator$secondValue".isEmpty
                        ? "0"
                        : "$firstValue$operator$secondValue",
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                )),
          ),
          //keyboard
          Wrap(
            children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                      width: value == Btn.number0
                          ? size.width / 2
                          : size.width / 4,
                      height: size.width / 5,
                      child: btn(value)),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Widget btn(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: setColor(value),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: InkWell(
            onTap: () => onBtnTap(value),
            child: Center(
                child: Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  color: setTextColor(value),
                  fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }

  Color setColor(value) {
    return [Btn.backspace, Btn.clear].contains(value)
        ? Colors.orangeAccent
        : [
            Btn.percent,
            Btn.multiply,
            Btn.divide,
            Btn.subtract,
            Btn.add,
            Btn.equal
          ].contains(value)
            ? Colors.lightGreen
            : Colors.black.withAlpha(20);
  }

  Color setTextColor(value) {
    return [
      Btn.backspace,
      Btn.clear,
      Btn.percent,
      Btn.multiply,
      Btn.divide,
      Btn.subtract,
      Btn.add,
      Btn.equal
    ].contains(value)
        ? Colors.white
        : Colors.black;
  }

  void onBtnTap(String value) {
    if (value == Btn.backspace) {
      delete();
      return;
    }
    if (value == Btn.clear) {
      clear();
      return;
    }

    if (value == Btn.percent) {
      toPercent();
      return;
    }

    if (value == Btn.equal) {
      equal();
      return;
    }

    append(value);
  }

  void equal() {
    if (firstValue.isEmpty) {
      return;
    }
    if (operator.isEmpty) {
      return;
    }
    if (secondValue.isEmpty) {
      return;
    }

    final double value1 = double.parse(firstValue);
    final double value2 = double.parse(secondValue);

    var result = 0.0;
    switch (operator) {
      case Btn.add:
        result = value1 + value2;
        break;
      case Btn.subtract:
        result = value1 - value2;
        break;
      case Btn.multiply:
        result = value1 * value2;
        break;
      case Btn.divide:
        if (value2 == 0) {
          const snackBar = SnackBar(
            content: Text("Can't divide by 0"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          result = value2;
        } else {
          result = value1/value2;
        }
        break;
      default:
    }

    setState(() {
      firstValue = "$result";
      if (firstValue.endsWith(".0")) {
        firstValue = firstValue.substring(0, firstValue.length - 2);
      }

      operator = "";
      secondValue = "";
    });
  }

  void toPercent() {
    if (firstValue.isNotEmpty &&
        operator.isNotEmpty &&
        secondValue.isNotEmpty) {
      equal();
    }

    if (operator.isNotEmpty) {
      return;
    }

    final number = double.parse(firstValue);
    setState(() {
      firstValue = "${number / 100}";
      operator = "";
      secondValue = "";
    });
  }

  void clear() {
    firstValue = "";
    secondValue = "";
    operator = "";
    setState(() {});
  }

  void delete() {
    if (secondValue.isNotEmpty) {
      secondValue = secondValue.substring(0, secondValue.length - 1);
    } else if (operator.isNotEmpty) {
      operator = "";
    } else if (firstValue.isNotEmpty) {
      firstValue = firstValue.substring(0, firstValue.length - 1);
    }

    setState(() {});
  }

  void append(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operator.isNotEmpty && secondValue.isNotEmpty) {
        equal();
      }
      if (firstValue.isEmpty) {
        firstValue = '0';
      }
      if (double.tryParse(firstValue) == 0) {
        firstValue = '0';
      }
      operator = value;
    } else if (firstValue.isEmpty || operator.isEmpty) {
      if (value == Btn.dot && firstValue.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.number0 && firstValue == '0') {
        return;
      }
      if (firstValue == '0') {
        firstValue = '';
      }
      if (value == Btn.dot) {
        if (firstValue == '0') {
          value = '.';
        } else if (firstValue.isEmpty) {
          value = '0.';
        }
      }
      firstValue += value;
    } else if (secondValue.isEmpty || operator.isNotEmpty) {
      if (value == Btn.dot && secondValue.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.number0 && secondValue == '0') {
        return;
      }
      if (secondValue == '0') {
        secondValue = '';
      }
      if (value == Btn.dot) {
        if (secondValue == '0') {
          value = '.';
        } else if (secondValue.isEmpty) {
          value = '0.';
        }
      }
      secondValue += value;
    }
    setState(() {});
  }
}

class Btn {
  static const String number0 = "0";
  static const String number1 = "1";
  static const String number2 = "2";
  static const String number3 = "3";
  static const String number4 = "4";
  static const String number5 = "5";
  static const String number6 = "6";
  static const String number7 = "7";
  static const String number8 = "8";
  static const String number9 = "9";
  static const String backspace = "<-";
  static const String clear = "C";
  static const String percent = "%";
  static const String multiply = "×";
  static const String divide = "÷";
  static const String add = "+";
  static const String subtract = "-";
  static const String equal = "=";
  static const String dot = ".";

  static const List<String> buttonValues = [
    backspace,
    clear,
    percent,
    multiply,
    number7,
    number8,
    number9,
    divide,
    number4,
    number5,
    number6,
    subtract,
    number1,
    number2,
    number3,
    add,
    dot,
    number0,
    equal,
  ];
}
