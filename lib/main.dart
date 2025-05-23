import 'package:broker/constantes.dart';
import 'package:broker/providers/currency_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broker/providers/auth_provider.dart';
import 'package:broker/providers/transaction_provider.dart';
import 'package:broker/screens/dashboard_screen.dart';
import 'package:broker/screens/login_screen.dart';
import 'package:broker/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().initDB();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ],
      child: const BrokerApp(),
    ),
  );
}

class BrokerApp extends StatelessWidget {
  const BrokerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Broker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white))
      ),
      home: Consumer<AuthProvider>(
        builder: (_, authProvider, __) {
          return authProvider.isLoggedIn ? DashboardScreen() : LoginScreen();
        },
      ),
    );
  }
}


