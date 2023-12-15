import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:budget_app/sql_database/sql_db_1/model/transaction.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../budget_tracker/pages/input_budget/income_category.dart';
import '../../../budget_tracker/pages/input_budget/income_category_list.dart';

class CircleChart extends StatefulWidget {
  final Map<String, double> sumMap;
  final double totalValue;

  const CircleChart({
    Key? key,
    required this.sumMap,
    required this.totalValue,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CircleChartState();
}

class CircleChartState extends State<CircleChart> {
  List<PieChartSectionData> pieChartSections = [];
  int touchedIndex = 0;
  bool isTouched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int index = 0;
    widget.sumMap.forEach((type, sum) {
      pieChartSections.add(PieChartSectionData(
        value: (sum * 100 / widget.totalValue),
        title: type,
        color: Colors.primaries[index % Colors.primaries.length],
        radius: 50,
      ));
      index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: true,
            ),
            sectionsSpace: 1,
            centerSpaceRadius: isTouched ? 50 : 40,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> pieChartSections = [];
    int index = 0;
    widget.sumMap.forEach((key, value) {
      double percent = value * 100 / widget.totalValue;
      int indexOfKey = widget.sumMap.entries
          .toList()
          .indexWhere((entry) => entry.key == key);
      bool isTouched = indexOfKey == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 85.0 : 70.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      pieChartSections.add(PieChartSectionData(
        value: value,
        title: (percent).toStringAsFixed(0) + "%",
        color: correspondantColor(
            key) /*Colors.primaries[index % Colors.primaries.length]*/,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          size: widgetSize,
          borderColor: correspondantColor(key),
          iconData: correspondantIcon(key),
        ),
        badgePositionPercentageOffset: 1.0,
      ));
      index++;
    });
    return pieChartSections;
  }

  correspondantIcon(String key) {
    IncomeCategory matchingCategory = incomeCategoryList.firstWhere(
        (incomeCategory) => incomeCategory.category == key,
        orElse: () => IncomeCategory(
            category: 'Unknown',
            incomeIcon: FontAwesomeIcons.circleQuestion,
            color: Colors.grey));
    IconData iconData = matchingCategory.incomeIcon;
    return iconData;
  }

  correspondantColor(String key) {
    IncomeCategory matchingCategory = incomeCategoryList.firstWhere(
        (incomeCategory) => incomeCategory.category == key,
        orElse: () => IncomeCategory(
            category: 'Unknown',
            incomeIcon: FontAwesomeIcons.circleQuestion,
            color: Colors.grey));
    Color correspendantColor = matchingCategory.color;
    return correspendantColor;
  }
}

class _Badge extends StatelessWidget {
  final double size;
  final Color borderColor;
  final IconData iconData;
  const _Badge({
    Key? key,
    required this.size,
    required this.borderColor,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
          child: Icon(
        iconData,
        color: borderColor,
      )),
    );
  }
}
