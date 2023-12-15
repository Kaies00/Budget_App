import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreditCard extends StatelessWidget {
  final double balance;
  const CreditCard({
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
          colors: [Colors.black, Colors.grey],
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
                    "Balance",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ],
          ),
          Row(children: [
            const Text(
              "****   ****   ****   3799",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            Spacer(),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/Mastercard.png"),
              )),
            )
          ]),
        ],
      ),
    );
  }
}
