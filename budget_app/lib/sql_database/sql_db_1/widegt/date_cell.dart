import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCell extends StatelessWidget {
  final DateTime dateElement;
  DateCell({Key? key, required this.dateElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 55,
      margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Color(0xFF333A47)),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal[200],
                ),
              ),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal[200],
                ),
              )
            ],
          ),
          Text(
            DateFormat("dd").format(dateElement).toString(),
            style: TextStyle(color: Colors.teal[200], fontSize: 25),
          ),
          Text(
            DateFormat('EEE').format(dateElement).toString(),
            style: TextStyle(color: Colors.teal[200], fontSize: 15),
          ),
        ],
      ),
    );
  }
}
