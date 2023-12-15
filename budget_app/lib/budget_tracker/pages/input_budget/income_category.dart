import 'package:flutter/material.dart';

class IncomeCategory {
  late final String category;
  late final IconData incomeIcon;
  late final Color color;

  IncomeCategory({
    required this.category,
    required this.incomeIcon,
    required this.color,
  });

  factory IncomeCategory.fromMap(Map<String, dynamic> map) => IncomeCategory(
        category: map['category'],
        incomeIcon: map['depenseIcon'],
        color: map['color'],
      );
}
