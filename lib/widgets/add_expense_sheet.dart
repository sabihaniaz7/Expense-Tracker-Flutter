import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense_model.dart';

class AddExpenseSheet extends StatefulWidget {
  final Expense? editExpense;
  const AddExpenseSheet({super.key, this.editExpense});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
