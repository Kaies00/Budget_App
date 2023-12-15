import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/balances.dart';
import '../model/transaction.dart';

class LineChartExample extends StatefulWidget {
  final List<TransactionX> transactions;

  LineChartExample({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  _LineChartExampleState createState() => _LineChartExampleState();
}

class _LineChartExampleState extends State<LineChartExample> {
  String _selectedPeriod = '1D';
  late DateTime oneThird;
  late DateTime twoThirds;
  late List<Balance> balances;
  late List<DateTime> dates;
  late double minXValue;
  late double maxXValue;
  late Balance smallestDate;
  bool goDate1 = true;
  bool goDate2 = true;

  late Balance biggestDate;

  List<FlSpot> _getSpots(List<Balance> balances, Duration duration) {
    final now = DateTime.now();
    final startDate = now.subtract(duration);

    print(balances.where((balance) {
      print(
          "recorded balance : ${balance.date.millisecondsSinceEpoch.toDouble()}  ___   ${balance.amount}");
      return balance.date.isAfter(startDate);
    }));
    final spots = balances
        .where((balance) => balance.date.isAfter(startDate))
        .map((balance) => FlSpot(
            balance.date.millisecondsSinceEpoch.toDouble(), balance.amount))
        .toList();

    oneThird = dates.sublist(0, dates.length ~/ 3)[dates.length ~/ 3 - 1];
    print("oneThird : ${oneThird.millisecondsSinceEpoch.toDouble()}");
    twoThirds = dates.sublist(0, dates.length ~/ 3 * 2).last;
    print("oneThird : ${twoThirds.millisecondsSinceEpoch.toDouble()}");

    return spots;
  }

  List<Balance> convertToBalance(List<TransactionX> transactions) {
    double amount = 0;
    return transactions.map((transaction) {
      // Extract the date and amount from the transaction
      DateTime date = transaction.createdTime;
      amount = amount + double.parse(transaction.amount);

      // Create a new Balance object with the date and amount
      return Balance(date, amount);
    }).toList();
  }

  List<DateTime> date3and4(DateTime date1, DateTime date2) {
    // Calculate the time difference between date1 and date2
    Duration diff = date2.difference(date1);

    // Calculate the one-third and two-thirds points between the two dates
    DateTime date3 = date1.add(diff * (1 / 3));
    DateTime date4 = date1.add(diff * (2 / 3));

    // Return the two new dates
    return [date3, date4];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    balances = convertToBalance(widget.transactions);
    // balances.sort((a, b) => b.date.compareTo(a.date));
    print("balances.map___ ${balances.map((e) => e.date).toList()}");
    dates = balances.map((balance) => balance.date).toList();
    minXValue = balances.first.date.millisecondsSinceEpoch.toDouble();
    maxXValue = balances.last.date.millisecondsSinceEpoch.toDouble();
    smallestDate = balances.reduce((value, element) =>
        value.date.isBefore(element.date) ? value : element);

    biggestDate = balances.reduce(
        (value, element) => value.date.isAfter(element.date) ? value : element);
  }

  @override
  Widget build(BuildContext context) {
    final periods = ['1D', '5D', '1M', '1Y', '5Y'];

    return Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: true),
              gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      dashArray: [5, 10],
                      color: const Color(0xff37434d),
                      strokeWidth: 0.1,
                    );
                  }),
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(
                  axisNameWidget: null,
                ),
                rightTitles: AxisTitles(
                  axisNameWidget: null,
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10,
                    getTitlesWidget: (value, index) {
                      print(
                          "comparison  : ${value}   ::   ${oneThird.millisecondsSinceEpoch.toDouble()}");
                      if (value > oneThird.millisecondsSinceEpoch.toDouble() &&
                          goDate1) {
                        DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        String shortDate = DateFormat.MMMd().format(date);
                        goDate1 = false;
                        return Text(shortDate);
                      } else if (value >
                              twoThirds.millisecondsSinceEpoch.toDouble() &&
                          goDate2) {
                        DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        String shortDate = DateFormat.MMMd().format(date);
                        goDate2 = false;
                        return Text(shortDate);
                      } else {
                        return Text("");
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      switch (value.toInt()) {
                        case 2:
                          return const Text("1");
                        case 5:
                          return const Text('11');
                        case 8:
                          return const Text('21');
                      }
                      return Text('');
                    },
                    reservedSize: 5,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: smallestDate.date.millisecondsSinceEpoch
                  .toDouble() /*widget.balances.first.date.millisecondsSinceEpoch.toDouble()*/,
              maxX: biggestDate.date.millisecondsSinceEpoch
                  .toDouble() /*widget.balances.last.date.millisecondsSinceEpoch.toDouble()*/,
              minY: -100,
              maxY: balances.fold(
                  0,
                  (max, balance) =>
                      balance.amount > max! ? balance.amount : max),
              lineBarsData: [
                LineChartBarData(
                  spots: _getSpots(balances, Duration(days: 10000)),
                  isCurved: false,
                  curveSmoothness: 0.12,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(DateFormat.MMMd()
                .format(date3and4(dates[0], dates[dates.length - 1])[0])
                .toString()),
            Text(DateFormat.MMMd()
                .format(date3and4(dates[0], dates[dates.length - 1])[1])
                .toString()),
          ],
        ),
        DropdownButton<String>(
          value: _selectedPeriod,
          items: periods.map((period) {
            return DropdownMenuItem<String>(
              value: period,
              child: Text(period),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPeriod = value!;
            });
          },
        ),
      ],
    );
  }
}
