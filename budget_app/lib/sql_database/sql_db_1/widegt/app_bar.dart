import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../db/transactions_database.dart';

class CustomAppBar extends StatelessWidget {
  final Function refreshList;
  final List transactions;
  const CustomAppBar(
      {super.key, required this.refreshList, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        transactions.length.toString(),
        style: const TextStyle(fontSize: 24),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: refreshList as Function()?,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            // await TransactionXsDatabase.instance.deleteTable();
            refreshList;
          },
        ),
        IconButton(
          icon: const Icon(Icons.data_array),
          onPressed: () {},
          // onPressed: () async {
          //   await TransactionXsDatabase.instance.deleteDB();
          //   refreshTransactions();
          // },
        ),
        const SizedBox(width: 12),
        const Icon(Icons.search),
        const SizedBox(width: 12)
      ],
    );
  }
}
