import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../../budget_tracker/json/day_month.dart';
import '../../../../budget_tracker/pages/values.dart';
import '../../../../budget_tracker/theme/colors.dart';
import '../../../../typedefs.dart';
import '../../db/transactions_database.dart';
import '../../model/transaction.dart';
import '../../widegt/app_bar.dart';
import '../../widegt/credit_card.dart';
import '../../widegt/date_cell.dart';
import '../../widegt/horizontal_dates_list.dart';
import '../../widegt/income_card.dart';
import '../../widegt/spent_card.dart';
import '../../widegt/total_balace.dart';
import '../transaction_card.dart';
import 'edit_transaction_page.dart';
import 'transaction_details_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with SingleTickerProviderStateMixin {
  late List<TransactionX> transactions;
  late List<TransactionX> filteredTransactions;
  double _keyboardHeight = 0.0;
  bool isLoading = false;
  Map _ico = {"ak": const Icon(Icons.settings)};
  int selectedIndex = 0;
  int activeDay = 3;
  int _selectedtab = 0;
  double totalAmount = 0;
  late DateTime lastDayOfMonth;
  final LoopPageController controllerCardPages = LoopPageController();
  static const List<String> tabsValues = ["All", "Income", "Spent"];
  late List<Widget> items;
  CarouselController buttonCarouselController = CarouselController();
  late int closestIndex;
  TextEditingController controllerBalanceAdjustement = TextEditingController();
  // ListObserverController observerController =
  //     ListObserverController(controller: _scrollController);

  @override
  void initState() {
    super.initState();
    refreshTransactions();

    // observerController.jumpTo(index: 300);
  }

  @override
  void dispose() {
    //TransactionXsDatabase.instance.close();
    // Stop listening for keyboard changes
    super.dispose();
  }

  Future refreshTransactions() async {
    setState(() => isLoading = true);
    transactions = await TransactionXsDatabase.instance.readAllTransactionXs();
    filteredTransactions = transactions;
    List tr = transactions.reversed.toList();
    totalAmount = transactions.fold(
        0,
        (double sum, TransactionX transaction) =>
            sum + double.parse(transaction.amount));
    print("totalAmount : ${totalAmount}");
    double totalIncome =
        transactions.fold(0, (double sum, TransactionX transaction) {
      if (transaction.type == 'Income') {
        return sum + double.parse(transaction.amount);
      } else {
        return sum;
      }
    });
    double totalSpent =
        transactions.fold(0, (double sum, TransactionX transaction) {
      if (transaction.type == 'Expense') {
        return sum + double.parse(transaction.amount);
      } else {
        return sum;
      }
    });
    items = [
      CreditCard(balance: totalAmount),
      IncomeCard(balance: totalIncome),
      SpentCard(balance: totalSpent),
    ];
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
    if (isLoading) {
      return Center(child: const CircularProgressIndicator());
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: grey.withOpacity(0.05),
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(50.0),
        //   child: CustomAppBar(
        //     refreshList: () => refreshTransactions(),
        //     transactions: transactions,
        //   ),
        // ),
        body: _getBody(),
      );
    }
  }

  Widget _getBody() {
    var _size = MediaQuery.of(context).size;
    return Column(
      children: [
        // const HorizentalDatesListView(),
        _headerDateSearchBar(),
        Expanded(
          child: Container(
            width: double.infinity,
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : transactions.isEmpty
                      ? const Center(
                          child: Text(
                            "No Transaction Recorded",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 24,
                            ),
                          ),
                        )
                      : buildTransactions(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerDateSearchBar() {
    return Container(
      decoration: BoxDecoration(color: white, boxShadow: [
        BoxShadow(
          color: grey.withOpacity(0.01),
          spreadRadius: 10,
          blurRadius: 3,
          // changes position of shadow
        ),
      ]),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bottomPageMenu(context),
                Text(totalAmount.toStringAsFixed(2)),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.blueGrey.withOpacity(0.1),
                  ),
                  child: const Icon(
                    AntDesign.search1,
                    color: Colors.blueGrey,
                  ),
                ),
                // Text(
                //   "Daily Transaction",
                //   style: TextStyle(
                //       fontSize: 20, fontWeight: FontWeight.bold, color: black),
                // ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),

            SizedBox(
              height: 200,
              child: LoopPageView.builder(
                controller: controllerCardPages,
                itemCount: 3,
                onPageChanged: (value) {
                  setState(() {
                    _selectedtab = value;
                    if (value == 1) {
                      filteredTransactions = transactions
                          .where((element) => element.type == "Income")
                          .toList();
                    } else if (value == 2) {
                      filteredTransactions = transactions
                          .where((element) => element.type == "Expense")
                          .toList();
                    } else {
                      filteredTransactions = transactions;
                    }
                  });
                },
                itemBuilder: (_, index) {
                  return items.elementAt(index);
                },
              ),
            ),

            Row(
              children: List.generate(
                  3,
                  (index) => InkWell(
                        onTap: () {
                          setState(() {
                            _selectedtab = index;
                            controllerCardPages.animateToPage(_selectedtab,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                          });
                          if (index == 1) {
                            filteredTransactions = transactions
                                .where((element) => element.type == "Income")
                                .toList();
                          } else if (index == 2) {
                            filteredTransactions = transactions
                                .where((element) => element.type == "Expense")
                                .toList();
                          } else {
                            filteredTransactions = transactions;
                          }
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.only(right: 10, top: 15),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: _selectedtab == index
                                ? Colors.cyan
                                : Colors.white,
                          ),
                          child: Center(
                              child: Text(
                            tabsValues[index],
                            style: TextStyle(
                                color: _selectedtab == index
                                    ? Colors.white
                                    : Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      )),
            )
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: List.generate(days.length, (index) {
            //     return GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           activeDay = index;
            //         });
            //       },
            //       child: Container(
            //         width: (MediaQuery.of(context).size.width - 40) / 7,
            //         child: Column(
            //           children: [
            //             Text(
            //               days[index]['label'],
            //               style: const TextStyle(fontSize: 10),
            //             ),
            //             const SizedBox(
            //               height: 10,
            //             ),
            //             Container(
            //               width: 30,
            //               height: 30,
            //               decoration: BoxDecoration(
            //                   color: activeDay == index
            //                       ? primary
            //                       : Colors.transparent,
            //                   shape: BoxShape.circle,
            //                   border: Border.all(
            //                       color: activeDay == index
            //                           ? primary
            //                           : black.withOpacity(0.1))),
            //               child: Center(
            //                 child: Text(
            //                   days[index]['day'],
            //                   style: TextStyle(
            //                       fontSize: 10,
            //                       fontWeight: FontWeight.w600,
            //                       color: activeDay == index ? white : black),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildTransactions() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return InkWell(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  TransactionDetailPage(transactionId: transaction.id!),
            ));
            refreshTransactions();
          },
          child: TransactionCardWidget(transaction: transaction, index: index),
        );
      },
    );
  }

  Widget bottomPageMenu(ctx) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.blueGrey.withOpacity(0.1),
        ),
        child: const Icon(
          Icons.grid_view_outlined,
          color: Colors.blueGrey,
        ),
      ),
      onTap: () async {
        showModalBottomSheet(
          isDismissible: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          enableDrag: true,
          context: ctx,
          builder: (ctx) {
            return StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setModalState) {
                double bottom = MediaQuery.of(context).viewInsets.bottom;
                double height = MediaQuery.of(context).size.height;
                return FractionallySizedBox(
                  heightFactor: 0.5 + bottom / height,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        height: 5,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextField(
                              controller: controllerBalanceAdjustement,
                              // controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Enter amount',
                                border: OutlineInputBorder(),
                                prefix: Text('\$'),
                              ),
                              style: const TextStyle(fontSize: 24.0),
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () async {
                                print(
                                    "totalAmount : ${totalAmount}_____________adjustement amount : ${(totalAmount - double.parse(controllerBalanceAdjustement.text)).abs()}");
                                // Perform action on button press
                                final transaction = TransactionX(
                                  account: "Balance Adjustement",
                                  isImportant: false,
                                  amount: (totalAmount -
                                          double.parse(
                                              controllerBalanceAdjustement
                                                  .text))
                                      .abs()
                                      .toStringAsFixed(2),
                                  description: "Balance Adjustement",
                                  createdTime: DateTime.now(),
                                  category: "Balance Adjustement",
                                  transfertto: '',
                                  type: totalAmount >
                                          double.parse(
                                              controllerBalanceAdjustement.text)
                                      ? "Expense"
                                      : "Income",
                                );

                                await TransactionXsDatabase.instance
                                    .create(transaction);
                                refreshTransactions();
                                Navigator.of(context).pop();
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
