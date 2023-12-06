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
  @override
  String firstValue = "";
  String operator = "";
  String secondValue = "";

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
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "$firstValue$operator$secondValue".isEmpty
                        ? "0"
                        : "$firstValue$operator$secondValue",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                )),
          ),
          //keyboard
          Wrap(
            children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                      width: value == Btn.n0 ? size.width / 2 : size.width / 4,
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
                fontWeight: FontWeight.bold
              ),
            ))),
      ),
    );
  }

  Color setColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.orangeAccent
        : [
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.subtract,
            Btn.add,
            Btn.calculate
          ].contains(value)
            ? Colors.lightGreen
            : Colors.black.withAlpha(20);
  }
  Color setTextColor(value) {
    return [Btn.del, Btn.clr, Btn.per,
      Btn.multiply,
      Btn.divide,
      Btn.subtract,
      Btn.add,
      Btn.calculate].contains(value)
        ? Colors.white
        : Colors.black;
  }


  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clear();
      return;
    }

    if (value == Btn.per) {
      toPercent();
      return;
    }

    if (value == Btn.calculate) {
      equal();
      return;
    }

    append(value);
  }

  void equal() {
    if (firstValue.isEmpty) return;
    if (operator.isEmpty) return;
    if (secondValue.isEmpty) return;

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
        result = value1 / value2;
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
      operator = value;
      operator = value;
    } else if (firstValue.isEmpty || operator.isEmpty) {
      if (value == Btn.dot && firstValue.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (firstValue.isEmpty || firstValue == Btn.n0)) {
        value = "0.";
      }
      firstValue += value;
    } else if (secondValue.isEmpty || operator.isNotEmpty) {
      if (value == Btn.dot && secondValue.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (secondValue.isEmpty || secondValue == Btn.n0)) {
        value = "0.";
      }
      secondValue += value;
    }
    setState(() {});
  }
}

class Btn {
  static const String del = "<-";
  static const String clr = "C";
  static const String per = "%";
  static const String multiply = "×";
  static const String divide = "÷";
  static const String add = "+";
  static const String subtract = "-";
  static const String calculate = "=";
  static const String dot = ".";

  static const String n0 = "0";
  static const String n1 = "1";
  static const String n2 = "2";
  static const String n3 = "3";
  static const String n4 = "4";
  static const String n5 = "5";
  static const String n6 = "6";
  static const String n7 = "7";
  static const String n8 = "8";
  static const String n9 = "9";

  static const List<String> buttonValues = [
    del,
    clr,
    per,
    multiply,
    n7,
    n8,
    n9,
    divide,
    n4,
    n5,
    n6,
    subtract,
    n1,
    n2,
    n3,
    add,
    dot,
    n0,
    calculate,
  ];
}
