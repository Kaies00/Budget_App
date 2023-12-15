import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'income_category.dart';

final List<IncomeCategory> incomeCategoryList = [
  IncomeCategory(
      category: 'Allowance',
      incomeIcon: FontAwesomeIcons.landmarkDome,
      color: Colors.red),
  IncomeCategory(
      category: 'Award',
      incomeIcon: FontAwesomeIcons.award,
      color: Colors.deepPurple),
  IncomeCategory(
      category: 'Bonus',
      incomeIcon: FontAwesomeIcons.handHoldingDollar,
      color: Colors.pink),
  IncomeCategory(
      category: 'Gaz',
      incomeIcon: FontAwesomeIcons.chartLine,
      color: Colors.blue),
  IncomeCategory(
      category: 'Dividend',
      incomeIcon: FontAwesomeIcons.chartLine,
      color: Colors.orange),
  IncomeCategory(
      category: 'Investement',
      incomeIcon: FontAwesomeIcons.commentsDollar,
      color: Colors.cyan),
  IncomeCategory(
      category: 'Lottery',
      incomeIcon: FontAwesomeIcons.diceTwo,
      color: Colors.blueGrey),
  IncomeCategory(
      category: 'Salary',
      incomeIcon: FontAwesomeIcons.fileInvoiceDollar,
      color: Colors.green),
  IncomeCategory(
      category: 'Tips',
      incomeIcon: FontAwesomeIcons.solidHandPointDown,
      color: Colors.yellow),
  IncomeCategory(
      category: 'Others',
      incomeIcon: FontAwesomeIcons.coins,
      color: Colors.deepPurpleAccent),
];
