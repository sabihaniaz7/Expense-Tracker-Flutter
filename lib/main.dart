import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/screens/splash_screen.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/expense_model.dart';

/// Main entry point for the Expense Tracker application.
/// Initializes Hive database, registers adapters, handles initial provider setup,
/// and starts the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set status bar to transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(MonthlyIncomeAdapter());

  final provider = ExpenseProvider();
  try {
    await provider.init();
  } catch (e) {
    provider.initializationError = 'Failed to initialize database: $e';
  }

  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const ExpenseTrackerApp(),
    ),
  );
}

/// The root widget of the application.
/// Configures theme, routes, and overall application state.
class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ExpenseProvider>().isDarkMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
