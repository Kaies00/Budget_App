import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

import '../../../../budget_tracker/pages/daily_page.dart';
import '../../../../budget_tracker/pages/stats_page.dart';
import '../../db/transactions_database.dart';
import '../../model/transaction.dart';
import '../../widegt/circle_chart.dart';
import 'chart_page.dart';
import 'edit_transaction_page.dart';
import 'transaction_page.dart';

class RootTransactionPage extends StatefulWidget {
  const RootTransactionPage({Key? key}) : super(key: key);

  @override
  State<RootTransactionPage> createState() => _RootTransactionPageState();
}

class _RootTransactionPageState extends State<RootTransactionPage> {
  Color primary = const Color(0xFFFF3378);
  Color secondary = const Color(0xFFFF2278);
  Color black = const Color(0xFF000000);
  Color white = const Color(0xFFFFFFFF);
  Color grey = Colors.grey;
  Color red = const Color(0xFFec5766);
  Color green = const Color(0xFF43aa8b);
  Color blue = const Color(0xFF28c2ff);

  late List<TransactionX> transactions;
  bool isLoading = false;
  Map _ico = {"ak": const Icon(Icons.settings)};
  int pageIndex = 0;
  List<Widget> pages = [
    TransactionsPage(),
    DailyPage(),
    StatsPage(),
    ChartPage(),
    AddEditTransactionXPage()
  ];

  @override
  void initState() {
    super.initState();
    refreshTransactions();
  }

  @override
  void dispose() {
    // TransactionXsDatabase.instance.close();

    super.dispose();
  }

  Future refreshTransactions() async {
    setState(() => isLoading = true);
    transactions = await TransactionXsDatabase.instance.readAllTransactionXs();
    List tr = transactions.reversed.toList();
    for (int i = 0; i < tr.length; i++) {
      try {
        print(tr[i].toString());
      } catch (e) {
        print('Exception : ' + e.toString());
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const CircularProgressIndicator()
            : pages.elementAt(pageIndex) /*getBody()*/,
        bottomNavigationBar: getFooter(),
        floatingActionButton: FloatingActionButton(
            // onPressed: () {
            //   selectedTab(4);
            // },
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => AddEditTransactionXPage()),
              );
              refreshTransactions();
              setState(() {});
              Future.delayed(Duration(seconds: 1), () {
                refreshTransactions();
              });
              setState(() {});
            },
            backgroundColor: Colors.pink,
            child: const Icon(
              Icons.add,
              size: 25,
            )
            //params
            ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_calendar,
      Ionicons.md_stats,
      Ionicons.md_wallet,
      Ionicons.ios_person,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
