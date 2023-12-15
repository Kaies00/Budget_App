// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class LineChart1 extends StatefulWidget {
//   const LineChart1({super.key});

//   @override
//   State<LineChart1> createState() => _LineChart1State();
// }

// class _LineChart1State extends State<LineChart1> {
//   @override
//   Widget build(BuildContext context) {
//     return LineChart(LineChartData(
//       lineTouchData: LineTouchData(
//           touchTooltipData: LineTouchTooltipData(
//               fitInsideHorizontally: true,
//               tooltipBgColor: Colors.white,
//               getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                 return touchedBarSpots.map((barSpot) {
//                   return LineTooltipItem(
//                     '${barSpot.y.toInt()}',
//                     TextStyle(
//                       fontFamily: 'Jost*',
//                       fontSize: 15,
//                       color: Colors.black,
//                     ),
//                   );
//                 }).toList();
//               }),
//           getTouchedSpotIndicator:
//               (LineChartBarData barData, List<int> spotIndexes) {
//             return spotIndexes.map((spotIndex) {
//               return TouchedSpotIndicatorData(
//                 FlLine(
//                   color: const Color.fromARGB(255, 77, 77, 77),
//                   strokeWidth: 1,
//                   dashArray: [4, 4],
//                 ),
//                 FlDotData(
//                   getDotPainter: (spot, percent, barData, index) {
//                     return FlDotCirclePainter(
//                       radius: 5.5,
//                       color: gradientColors[0],
//                       strokeWidth: 2,
//                       strokeColor: Colors.white,
//                     );
//                   },
//                 ),
//               );
//             }).toList();
//           }),
//       gridData: FlGridData(
//         show: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//               color: const Color.fromARGB(255, 98, 95, 161),
//               strokeWidth: 1,
//               dashArray: [4, 4]);
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 14,
//             textStyle: const TextStyle(
//               color: Color.fromARGB(255, 181, 181, 181),
//               fontWeight: FontWeight.w300,
//               fontFamily: 'Jost*',
//               fontSize: 13,
//             ),
//             getTitles: (value) {
//               return _labels[widget.timeType][value.toInt()] ?? '';
//             },
//           ),
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           textStyle: const TextStyle(
//             color: Color.fromARGB(255, 181, 181, 181),
//             fontWeight: FontWeight.w300,
//             fontFamily: 'Jost*',
//             fontSize: 16,
//           ),
//           getTitles: (value) {
//             return (value.toInt()).toString();
//           },
//           reservedSize: 28,
//           margin: 12,
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.symmetric(
//           horizontal: BorderSide(
//               color: const Color.fromARGB(255, 170, 170, 170), width: 1.2),
//         ),
//       ),
//       minX: 0,
//       maxX: _data[widget.timeType].length.toDouble() - 1, //length of data set
//       minY: _data[widget.timeType].reduce(min).toDouble() - 1, //set to lowest v
//       maxY:
//           _data[widget.timeType].reduce(max).toDouble() + 1, //set to highest v
//       lineBarsData: [
//         LineChartBarData(
//           spots: [
//             for (int i = 0; i < _data[widget.timeType].length; i++)
//               FlSpot(i.toDouble(), _data[widget.timeType][i].toDouble())
//           ],
//           //FlSpot(2.6, 4),
//           isCurved: true,
//           colors: [
//             gradientColors[0],
//           ],
//           barWidth: 2,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             colors: gradientColors,
//             gradientColorStops: [0, 0.5, 1.0],
//             gradientFrom: const Offset(0, 0),
//             gradientTo: const Offset(0, 1),
//           ),
//         ),
//       ],
//     ));
//   }
// }
