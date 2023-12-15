import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/transaction.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class TransactionCardWidget extends StatelessWidget {
  TransactionCardWidget({
    Key? key,
    required this.transaction,
    required this.index,
  }) : super(key: key);

  final TransactionX transaction;
  final int index;
  Map _ico = {"AK": Icon(Icons.settings)};

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFFFF3378);
    const Color secondary = Color(0xFFFF2278);
    const Color black = Color(0xFF000000);
    const Color white = Color(0xFFFFFFFF);
    const Color grey = Colors.grey;
    const Color red = Color(0xFFec5766);
    const Color green = Color(0xFF43aa8b);
    const Color blue = Color(0xFF28c2ff);
    Size size = MediaQuery.of(context).size;
    final time = DateFormat.yMMMd().format(transaction.createdTime);
    final isIncome = transaction.type;

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: (size.width - 40) * 0.7,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: grey.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/bank.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: (size.width - 90) * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.category,
                            style: const TextStyle(
                                fontSize: 15,
                                color: black,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            time,
                            style: TextStyle(
                                fontSize: 12,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            isIncome,
                            style: TextStyle(
                                fontSize: 12,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: (size.width - 40) * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      /*double.parse(transaction.amount)
                          .toStringAsFixed(2)
                          .toString()*/
                      transaction.type == "Income"
                          ? " + \$" + transaction.amount
                          : " - \$" + transaction.amount,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: transaction.type == "Income"
                              ? Colors.green
                              : Colors.red),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 8),
            child: Divider(
              thickness: 0.8,
            ),
          )
        ],
      ),
    );
  }
}
