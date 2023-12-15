import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../db/transactions_database.dart';
import '../../model/transaction.dart';
import 'edit_transaction_page.dart';

class TransactionDetailPage extends StatefulWidget {
  final int transactionId;

  const TransactionDetailPage({
    Key? key,
    required this.transactionId,
  }) : super(key: key);

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late TransactionX transaction;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshTransaction();
  }

  Future refreshTransaction() async {
    setState(() => isLoading = true);

    transaction = await TransactionXsDatabase.instance
        .readTransactionX(widget.transactionId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      transaction.category,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("gfjehfbeuib"),
                    Text(
                      transaction.type,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      transaction.category,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      transaction.amount,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      transaction.account,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(transaction.createdTime),
                      //style: const TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transaction.description,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              AddEditTransactionXPage(transaction: transaction),
        ));

        refreshTransaction();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await TransactionXsDatabase.instance.delete(widget.transactionId);

          Navigator.of(context).pop();
        },
      );
}
