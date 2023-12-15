import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpentCard extends StatelessWidget {
  final double balance;
  const SpentCard({
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
          colors: [
            Color(0xff03396c),
            Color(0xff6497b1),
          ],
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
                    style: const TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  const Text(
                    "Spent",
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
                width: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xffee6c4d),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
