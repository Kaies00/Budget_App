import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

import '../../../sql_database/sql_db_1/db/transactions_database.dart';
import '../../../sql_database/sql_db_1/model/transaction.dart';
import 'category_select_search.dart';

class SimpleCalculator extends StatefulWidget {
  final TransactionX? transaction;

  const SimpleCalculator({super.key, this.transaction});
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late String amount;
  late String account;
  late String description;
  late String category;

  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  int _selectedType = 0;
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Select a Category';
  String _selectedAccount = 'Cash';

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        double equationFontSize = 38.0;
        double resultFontSize = 48.0;
      } else if (buttonText == "x") {
        double equationFontSize = 48.0;
        double resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        double equationFontSize = 38.0;
        double resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('x', '*');
        expression = expression.replaceAll('/', '/');

        try {
          Parser p = new Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        }
        equation = equation + buttonText;
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(0.0),
        //     side: const BorderSide(
        //       color: Colors.grey,
        //       width: 1,
        //       style: BorderStyle.solid,
        //     )),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    isImportant = widget.transaction?.isImportant ?? false;
    amount = widget.transaction?.amount ?? "0";
    account = widget.transaction?.account ?? '';
    description = widget.transaction?.description ?? '';
    category = widget.transaction?.category ?? '';
  }

  void addOrUpdateTransactionX() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.transaction != null;

      if (isUpdating) {
        await updateTransactionX();
      } else {
        await addTransactionX();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateTransactionX() async {
    final transaction = widget.transaction!.copy(
      isImportant: isImportant,
      amount: amount,
      account: account,
      description: description,
    );

    await TransactionXsDatabase.instance.update(transaction);
  }

  Future addTransactionX() async {
    final transaction = TransactionX(
      account: account,
      isImportant: true,
      amount: "600",
      description: _selectedCategory,
      createdTime: DateTime.now(),
      category: _selectedCategory,
      transfertto: '',
      type: '',
    );

    await TransactionXsDatabase.instance.create(transaction);
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff039be6),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
        actions: [
          IconButton(
              onPressed: () {
                addOrUpdateTransactionX;
              },
              icon: const Icon(Icons.done)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: List.generate(3, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedType = index;
                    if (_selectedType == 0) {
                      isImportant = true;
                      account = "Income";
                    } else if (_selectedType == 1) {
                      isImportant = false;
                      account = "Expense";
                    } else if (_selectedType == 2) {
                      isImportant = false;
                      account = "Transfert";
                    }
                  });
                },
                child: Container(
                  width: _size.width / 3,
                  height: 45.0,
                  decoration: BoxDecoration(
                      color: _selectedType == index
                          ? const Color(0xff039be6)
                          : const Color(0xff04aaff)),
                  child: Center(
                    child: Text(
                      index == 0
                          ? "Income"
                          : index == 1
                              ? "Expense"
                              : "Transfert",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }),
          ),
          Container(
            color: const Color(0xff04aaff),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(equation, style: TextStyle(fontSize: equationFontSize)),
          ),
          Container(
            color: const Color(0xff04aaff),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(double.parse(result).toStringAsFixed(2),
                style:
                    TextStyle(fontSize: resultFontSize, color: Colors.white)),
          ),
          Container(
            height: _size.height * 0.1,
            color: Color(0xff04aaff),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    TextButton(
                      onPressed: () {
                        _getDateFromUser(context);
                      },
                      child: Text(
                        DateFormat.yMd().format(_selectedDate),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.white,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Category",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    TextButton(
                      onPressed: () async {
                        _selectedCategory =
                            await Get.to(const CategorySelectSearch());
                        setState(() {});
                      },
                      child: Text(
                        _selectedCategory,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.white,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    TextButton(
                      onPressed: () {
                        _getDateFromUser(context);
                      },
                      child: Text(
                        _selectedAccount,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", 1, Colors.white38),
                      buildButton("x", 1, Colors.white38),
                      buildButton("/", 1, Colors.white38),
                    ]),
                    TableRow(children: [
                      buildButton("7", 1, Colors.white38),
                      buildButton("8", 1, Colors.white38),
                      buildButton("9", 1, Colors.white38),
                    ]),
                    TableRow(children: [
                      buildButton("4", 1, Colors.white38),
                      buildButton("5", 1, Colors.white38),
                      buildButton("6", 1, Colors.white38),
                    ]),
                    TableRow(children: [
                      buildButton("1", 1, Colors.white38),
                      buildButton("2", 1, Colors.white38),
                      buildButton("3", 1, Colors.white38),
                    ]),
                    TableRow(children: [
                      buildButton(".", 1, Colors.white38),
                      buildButton("0", 1, Colors.white38),
                      buildButton("00", 1, Colors.white38),
                    ])
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("*", 1, Colors.grey.withOpacity(0.5)),
                    ]),
                    TableRow(children: [
                      buildButton("-", 1, Colors.grey.withOpacity(0.5)),
                    ]),
                    TableRow(children: [
                      buildButton("+", 1, Colors.grey.withOpacity(0.5)),
                    ]),
                    TableRow(children: [
                      buildButton("/", 1, Colors.grey.withOpacity(0.5)),
                    ]),
                    TableRow(children: [
                      buildButton("=", 1, Colors.grey.withOpacity(0.5)),
                    ])
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _getDateFromUser(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
        context: (context),
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate as DateTime;
      });
    } else {
      _showDialog;
    }
  }

  _showDialog() {
    Get.defaultDialog(
      title: "Date Picker state",
      content: Text("You should pick a date/time !! "),
    );
  }
}
