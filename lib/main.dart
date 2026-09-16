import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:expense_tracker_app/providers/budget_provider.dart';
import 'package:expense_tracker_app/providers/analytics_provider.dart';
import 'package:expense_tracker_app/screens/main_navigation_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetProvider(),
        ),
        ChangeNotifierProxyProvider<TransactionProvider, AnalyticsProvider>(
          create: (context) => AnalyticsProvider(
            context.read<TransactionProvider>(),
          ), 
          update: (_,transactionProvider, analyticsProvider ) => analyticsProvider ?? AnalyticsProvider(transactionProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      //light theme
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),

      //dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      themeMode: ThemeMode.system, // Use system theme mode
      home: const MainNavigationScreen(),
    
    );
  }
}