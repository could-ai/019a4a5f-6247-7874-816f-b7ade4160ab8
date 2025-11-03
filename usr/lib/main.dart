import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cash_provider.dart';
import 'screens/home_screen.dart';
import 'screens/students_screen.dart';
import 'screens/payments_screen.dart';
import 'screens/purchases_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CashProvider(),
      child: MaterialApp(
        title: 'Class Cash Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          '/students': (context) => const StudentsScreen(),
          '/payments': (context) => const PaymentsScreen(),
          '/purchases': (context) => const PurchasesScreen(),
        },
      ),
    );
  }
}
