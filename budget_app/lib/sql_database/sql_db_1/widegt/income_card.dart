import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeCard extends StatelessWidget {
  final double balance;
  const IncomeCard({
    Key? key,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatted = NumberFormat('#,##0.00').format(balance);
    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.blueAccent, Colors.cyanAccent],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: const [
            Spacer(),
            Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ]),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$ " + formatted,
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Text(
                    "Income",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Container(
                height: 5,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 5,
                width: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.amber,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
