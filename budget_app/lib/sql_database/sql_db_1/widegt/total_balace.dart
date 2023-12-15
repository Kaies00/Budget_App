import 'package:budget_app/budget_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class TotalBalance extends StatelessWidget {
  final double balance;
  const TotalBalance({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(color: blue.withOpacity(0.08), boxShadow: [
        BoxShadow(
          color: blue.withOpacity(0.01),
          spreadRadius: 10,
          blurRadius: 3,
          // changes position of shadow
        ),
      ]),
      height: 50,
      child: Row(
        children: [
          Text(
            "Total",
            style: TextStyle(
                fontSize: 16,
                color: black.withOpacity(0.4),
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              const Text(
                "\$",
                style: TextStyle(
                    fontSize: 20, color: black, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                balance.toString(),
                style: const TextStyle(
                    fontSize: 20, color: black, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
