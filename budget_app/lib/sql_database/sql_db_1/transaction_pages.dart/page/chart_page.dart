import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';

import 'package:budget_app/budget_tracker/widget/chart.dart';

import '../../../../budget_tracker/json/day_month.dart';
import '../../../../budget_tracker/theme/colors.dart';
import '../../db/transactions_database.dart';
import '../../model/balances.dart';
import '../../model/transaction.dart';
import '../../widegt/circle_chart.dart';
import '../../widegt/line_chart.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  int activeDay = 3;
  bool isLoading = false;
  late List<TransactionX> transactions;
  Map<String, double> typeSumMap = {};
  Map<String, double> categorySumMap = {};
  Map<String, double> categoryIncomeSumMap = {};
  Map<String, double> categoryExpenseSumMap = {};
  bool showAvg = false;

  Future refreshTransactions() async {
    setState(() => isLoading = true);
    transactions = await TransactionXsDatabase.instance.readAllTransactionXs();

    List tr = transactions.reversed.toList();

    double totalAmount = transactions.fold(
        0,
        (double sum, TransactionX transaction) =>
            sum + double.parse(transaction.amount));

    for (int i = 0; i < tr.length; i++) {
      try {
        print(tr[i].toString());
      } catch (e) {
        print('Exception : ' + e.toString());
      }
    }
    for (TransactionX transaction in transactions) {
      if (typeSumMap.containsKey(transaction.type)) {
        typeSumMap[transaction.type] =
            typeSumMap[transaction.type]! + double.parse(transaction.amount);
      } else {
        typeSumMap[transaction.type] = double.parse(transaction.amount);
      }
      if (categorySumMap.containsKey(transaction.category)) {
        categorySumMap[transaction.category] =
            categorySumMap[transaction.category]! +
                double.parse(transaction.amount);
      } else {
        categorySumMap[transaction.category] = double.parse(transaction.amount);
      }
      if (transaction.type == "Income") {
        if (categoryIncomeSumMap.containsKey(transaction.category)) {
          categoryIncomeSumMap[transaction.category] =
              categoryIncomeSumMap[transaction.category]! +
                  double.parse(transaction.amount);
        } else {
          categoryIncomeSumMap[transaction.category] =
              double.parse(transaction.amount);
        }
      }
      if (transaction.type == "Expense") {
        if (categoryExpenseSumMap.containsKey(transaction.category)) {
          categoryExpenseSumMap[transaction.category] =
              categoryExpenseSumMap[transaction.category]! +
                  double.parse(transaction.amount);
        } else {
          categoryExpenseSumMap[transaction.category] =
              double.parse(transaction.amount);
        }
      }
    }
    print(typeSumMap);
    print(categorySumMap);
    print(categoryIncomeSumMap);
    print(categoryExpenseSumMap);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    List expenses = [
      {
        "icon": Icons.arrow_back,
        "color": blue,
        "label": "Income",
        "cost": "\$6593.75"
      },
      {
        "icon": Icons.arrow_forward,
        "color": red,
        "label": "Expense",
        "cost": "\$2645.50"
      }
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Stats",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      Icon(AntDesign.search1)
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(months.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              activeDay = index;
                            });
                          },
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 40) / 6,
                            child: Column(
                              children: [
                                Text(
                                  months[index]['label'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: activeDay == index
                                          ? primary
                                          : Colors.black.withOpacity(0.02),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: activeDay == index
                                              ? primary
                                              : Colors.black.withOpacity(0.1))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 7, bottom: 7),
                                    child: Text(
                                      months[index]['day'],
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: activeDay == index
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3,
                      // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Net balance",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "\$2446.90",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: (size.width - 20),
                            height: 150,
                            child: LineChartExample(
                              transactions: transactions,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3,
                      // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Net balance",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "\$2446.90",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: (size.width - 20),
                        height: 150,
                        child: LineChart(
                          mainData(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          chartSegment(
            typeSumMap: typeSumMap,
            size: size,
            categorySumMap: categoryExpenseSumMap,
            amount: typeSumMap["Income"]!,
            title: 'Income',
          ),
          const SizedBox(
            height: 15,
          ),
          chartSegment(
            typeSumMap: typeSumMap,
            size: size,
            categorySumMap: categoryIncomeSumMap,
            amount: typeSumMap["Expense"]!,
            title: 'Expense',
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
              spacing: 20,
              children: List.generate(expenses.length, (index) {
                return Container(
                  width: (size.width - 60) / 2,
                  height: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: expenses[index]['color']),
                          child: Center(
                              child: Icon(
                            expenses[index]['icon'],
                            color: Colors.white,
                          )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expenses[index]['label'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: const Color(0xff67727d)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              expenses[index]['cost'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }
}

class chartSegment extends StatelessWidget {
  const chartSegment({
    Key? key,
    required this.typeSumMap,
    required this.size,
    required this.categorySumMap,
    required this.title,
    required this.amount,
  }) : super(key: key);

  final Map<String, double> typeSumMap;
  final Size size;
  final Map<String, double> categorySumMap;
  final String title;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Color(0xff67727d)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$${NumberFormat('#,##0.00').format(amount)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: (size.width - 20),
                  height: 250,
                  child: CircleChart(
                    sumMap: categorySumMap,
                    totalValue: amount,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Balance {
  final DateTime dateTime;
  final double amount;

  Balance(this.dateTime, this.amount);
}
