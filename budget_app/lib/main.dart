import 'package:budget_app/sql_database/sql_db_1/transaction_pages.dart/page/splash_screen.dart';
import 'package:budget_app/sql_database/sql_db_1/widegt/shrink_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'scrol_exemple/features/home/home_page.dart';
import 'sql_database/sql_db_1/transaction_pages.dart/page/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          SplashScreen() /* RootTransactionPage() HomePage()   HomePage() RootApp() TransactionsPage()Wrapper()*/,
    );
  }
}
