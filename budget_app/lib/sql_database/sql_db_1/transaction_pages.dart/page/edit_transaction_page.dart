import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import '../../../../budget_tracker/pages/input_budget/category_select_search.dart';
import '../../db/transactions_database.dart';
import '../../model/transaction.dart';
import 'root_page.dart';
import 'transaction_page.dart';

class AddEditTransactionXPage extends StatefulWidget {
  final TransactionX? transaction;

  const AddEditTransactionXPage({
    Key? key,
    this.transaction,
  }) : super(key: key);
  @override
  _AddEditTransactionXPageState createState() =>
      _AddEditTransactionXPageState();
}

class _AddEditTransactionXPageState extends State<AddEditTransactionXPage> {
  bool expressionShouldTakeResult = false;
  bool iCanAddPoint = true;
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;
  String signsOperations = "/*-+";
  String signsOperationsAndPoint = "/*-+.";

  int _selectedType = 0;
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Select a Category';
  String _selectedAccount = 'Cash';
  late String _description = 'Add a description';

  final List _accountList = [
    {"title": "Cash", "icon": const Icon(FontAwesomeIcons.wallet)},
    {"title": "bank", "icon": const Icon(FontAwesomeIcons.person)},
    {"title": "Cash", "icon": const Icon(FontAwesomeIcons.wallet)},
  ];
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late String amount;
  late String account;
  late String description;
  late String category;
  late String transfertto;
  late String type;

  @override
  void initState() {
    super.initState();

    isImportant = widget.transaction?.isImportant ?? false;
    amount = widget.transaction?.amount ?? '0';
    result = widget.transaction?.amount ?? '0';
    account = widget.transaction?.account ?? '';
    description = widget.transaction?.description ?? '';
    category = widget.transaction?.category ?? '';
    _selectedCategory = widget.transaction?.category ?? 'Select a Category';
    transfertto = widget.transaction?.transfertto ?? '';
    type = widget.transaction?.type ?? 'Income';
    _description = widget.transaction?.description ?? 'Add a description';
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [buildSaveButton()],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildCalculator(_size),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCalculator(Size size) {
    return SizedBox(
      height: size.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: List.generate(3, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedType = index;
                    if (_selectedType == 0) {
                      type = "Income";
                    } else if (_selectedType == 1) {
                      type = "Expense";
                    } else if (_selectedType == 2) {
                      type = "Transfert";
                    }
                  });
                },
                child: Container(
                  width: size.width / 3,
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
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 400),
              style:
                  TextStyle(fontSize: equationFontSize, color: Colors.white70),
              child: Text(
                equation,
              ),
            ),
          ),
          Container(
            color: const Color(0xff04aaff),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 400),
              style: TextStyle(fontSize: resultFontSize, color: Colors.white),
              child: Text(
                double.parse(result).toStringAsFixed(2),
              ),
            ),
          ),
          Container(
            height: size.height * 0.1,
            color: const Color(0xff04aaff),
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
                        category = _selectedCategory;
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
                        Get.defaultDialog(
                          radius: 5,
                          title: "",
                          content: Container(
                            width: 500,
                            child: Column(children: [
                              Container(
                                child: Text("Select Account ___ :"),
                              ),
                              ...List.generate(
                                _accountList.length,
                                (index) => Column(
                                  children: [
                                    ListTile(
                                      leading: _accountList[index]["icon"],
                                      title: Text(_accountList[index]["title"]),
                                      onTap: () {
                                        setState(() {
                                          _selectedAccount =
                                              _accountList[index]["title"];
                                          account =
                                              _accountList[index]["title"];
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          // actions: [
                          //   const Text("first choice"),
                          //   const Text("second choice"),
                          // ],
                        );
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
          Container(
            width: double.infinity,
            height: 50,
            color: const Color(0xff04aaff).withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () async {
                  _selectedCategory =
                      await Get.to(const CategorySelectSearch());
                  setState(() {});
                  category = _selectedCategory;
                },
                child: Center(
                  child: Text(
                    _description,
                    style: const TextStyle(
                        color: Color(0xff04aaff),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", 1, Colors.white38),
                      buildButton(null, 1, Colors.white38),
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
        _showDialog();
      });
    } else {
      _showDialog();
    }
  }

  _showDialog() {
    Get.defaultDialog(
      onConfirm: () {},
      onCancel: () {},
      title: "Date Picker state",
      content: const Text("You should pick a date/time !! "),
    );
  }

  Widget buildButton(
      String? buttonText, double buttonHeight, Color buttonColor) {
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
        onPressed: () =>
            buttonText == null ? buttonPressed("x") : buttonPressed(buttonText),
        child: buttonText == null
            ? const Icon(
                Icons.backspace_outlined,
                color: Colors.grey,
              )
            : Text(
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
        // } else if (buttonText == ".") {
        //   debugPrint("if (buttonText == .)");
        //   if (!_lastNumberContainPoint(equation)) {
        //     debugPrint("_lastNumberContainPoint false");
        //     equation = equation + buttonText;
        //   }
      } else if (buttonText == "=") {
        double equationFontSize = 38.0;
        double resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('x', '*');
        expression = expression.replaceAll('/', '/');
        debugPrint('expression --> ${expression}');
        // debugPrint('lisExpression --> ${calculation(expression)}');

        try {
          if (checkExpressionSafety(expression)) {
            _showAlertDialog(context,
                "Wrong Expression. \nCheck if you have Successive sign \nor a sign at the end.");
          } else {
            Parser p = Parser();
            Expression exp = p.parse(expression);

            ContextModel cm = ContextModel();
            result = '${exp.evaluate(EvaluationType.REAL, cm)}';
            amount = result;
            expressionShouldTakeResult = true;
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        debugPrint("buttonText --> ${buttonText}");
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else if (buttonText == "." && _inValidDoublePoints(equation)) {
          debugPrint("invalid Form --> you can't add another point ");
        } else if (signsOperationsAndPoint.contains(buttonText) &&
            signsOperationsAndPoint.contains(equation[equation.length - 1])) {
          debugPrint(
              "invalid Form --> equation = ${equation} , you try to add ${buttonText}");
        } else {
          debugPrint("Ohhh shit it's else");
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildSaveButton() {
    final isFormValid = account.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  width: 0.5, // thickness
                  color: Colors.white70 // color
                  ),
              // border radius
              borderRadius: BorderRadius.circular(3)),
        ),
        onPressed: () {
          _selectedCategory == 'Select a Category'
              ? _showAlertDialog(
                  context, "You Forgot to Select a Category First")
              : addOrUpdateTransactionX();
        },
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateTransactionX() async {
    final isValid = _formKey.currentState!.validate();
    print("addOrUpdateTransactionX");
    print(isValid.toString());

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
    print("addTransactionX");
    final transaction = TransactionX(
      account: account,
      isImportant: true,
      amount: amount,
      description: description,
      createdTime: DateTime.now(),
      category: category,
      transfertto: '',
      type: type,
    );

    await TransactionXsDatabase.instance.create(transaction);
  }

  List<String> calculation(String expession) {
    String signsOperations = "/*-+.";
    List<String> output = [];

    for (int i = 0; i < expession.length; i++) {
      if (signsOperations.contains(expession[i])) {
        output.add(expession[i]);
      } else {
        String num = "";
        while (i < expession.length && _isNumeric(expession[i])) {
          num += expession[i];
          i++;
        }
        output.add(num);
        i--;
      }
    }
    for (int i = 0; i < output.length; i++) {}
    return output;
  }

  bool checkExpressionSafety(String expession) {
    bool invalidExpression = false;
    if (signsOperations.contains(expession[expession.length - 1])) {
      invalidExpression = true;
    } else {
      for (int i = 1; i < expession.length; i++) {
        if (signsOperations.contains(expession[i]) &&
            signsOperations.contains(expession[i - 1])) {
          invalidExpression = true;
          break;
        }
      }
    }
    return invalidExpression;
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(
            message,
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _acceptOneMoreButtonTap(String equation, String buttonText) {
    if (signsOperations.contains(equation[equation.length - 1])) {
      return false;
    } else if (buttonText == "." && _lastNumberContainPoint(equation)) {
      return false;
    } else {
      return true;
    }
  }

  bool _lastNumberContainPoint(String equation) {
    List<String> output = [];
    String lastNumber;

    for (int i = 0; i < equation.length; i++) {
      if (signsOperations.contains(equation[i])) {
        output.add(equation[i]);
      } else {
        String num = "";
        while (i < equation.length && _isNumeric(equation[i])) {
          num += equation[i];
          i++;
        }
        output.add(num);
        i--;
      }
    }
    debugPrint("output --> ${output}");
    lastNumber = output[output.length - 1];
    debugPrint("lastNumber --> ${lastNumber}");
    int count = lastNumber.split(".").length - 1;
    debugPrint("count --> ${count}");
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool _inValidDoublePoints(String equation) {
    debugPrint("equation.length => ${equation.length}");
    for (int i = equation.length - 1; i > 0; i--) {
      debugPrint("equation => ${equation} | equation[${i}] ==> ${equation[i]}");

      if (signsOperations.contains(equation[i])) {
        debugPrint("_inValidDoublePoints return false");
        return false;
      } else if (equation[i] == ".") {
        debugPrint("_inValidDoublePoints return true ");
        return true;
      }
    }
    debugPrint("_inValidDoublePoints return 2nd false  ");
    return false;
  }
}
