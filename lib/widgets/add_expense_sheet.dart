import 'package:expense_tracker/widgets/common/app_button.dart';
import 'package:expense_tracker/widgets/common/app_input_field.dart';
import 'package:expense_tracker/widgets/common/app_sheet.dart';
import 'package:expense_tracker/widgets/common/input_label.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense_model.dart';
import '../utils/app_utils.dart';

/// Sheet for adding or editing an expense.
class AddExpenseSheet extends StatefulWidget {
  final Expense? editExpense;
  final String? defaultMonthKey;
  const AddExpenseSheet({super.key, this.editExpense, this.defaultMonthKey});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _selectedCategory = 'Food & Drink';
  late DateTime _selectedDate;
  bool _addingCustom = false;
  final _customCatCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editExpense != null) {
      _titleCtrl.text = widget.editExpense!.title;
      _amountCtrl.text = widget.editExpense!.amount.toString();
      _noteCtrl.text = widget.editExpense!.note;
      _selectedCategory = widget.editExpense!.category;
      _selectedDate = widget.editExpense!.date;
    } else if (widget.defaultMonthKey != null) {
      final parts = widget.defaultMonthKey!.split('-');
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final now = DateTime.now();
      if (now.year == y && now.month == m) {
        _selectedDate = now;
      } else {
        _selectedDate = DateTime(y, m + 1, 0); // last day of that month
      }
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    final subColor = isDark ? AppTheme.subText : Colors.grey[500]!;

    final allCategories = [
      ...AppCategories.categories.map((c) => c['name'] as String),
      ...provider.customCategories,
    ];

    return AppSheet(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.editExpense != null ? 'Edit Expense' : 'Add Expense',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),

              // Amount Input
              InputLabel(label: 'Amount', color: textColor),
              AppInputField(
                controller: _amountCtrl,
                hint: '\$ 0.00',
                isDark: isDark,
                textColor: textColor,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixText: '\$  ',
                fontSize: 24,
                validator: (value) {
                  final amountText = (value ?? '').trim().replaceAll(',', '');
                  if (amountText.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(amountText);
                  if (amount == null) {
                    return 'Enter a valid numeric amount';
                  }
                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Title
              InputLabel(label: 'Title/Item', color: textColor),
              AppInputField(
                controller: _titleCtrl,
                hint: 'Dress, Shoes, Lunch ...',
                isDark: isDark,
                textColor: textColor,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category selector
              InputLabel(label: 'Category', color: textColor),
              SizedBox(
                height: 44,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: allCategories.length + 1,
                  itemBuilder: (context, i) {
                    if (i == allCategories.length) {
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _addingCustom = !_addingCustom),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.neonPurple.withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: AppTheme.neonPurple,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Custom',
                                style: TextStyle(
                                  color: AppTheme.neonPurple,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final cat = allCategories[i];
                    final isSelected = _selectedCategory == cat;
                    final isCustom = provider.customCategories.contains(cat);
                    final color = AppCategories.getColor(cat);
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      onLongPress: isCustom
                          ? () => _confirmDeleteCategory(context, cat, provider)
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : (isDark ? Colors.white12 : Colors.grey[200]!),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              AppCategories.getEmoji(cat),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? color : subColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Custom Category Input
              if (_addingCustom) ...{
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppInputField(
                        controller: _customCatCtrl,
                        hint: 'Category Name',
                        isDark: isDark,
                        textColor: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        if (_customCatCtrl.text.trim().isNotEmpty) {
                          try {
                            await provider.addCustomCategory(
                              _customCatCtrl.text.trim(),
                            );
                            if (!context.mounted) return;
                            setState(() {
                              _selectedCategory = _customCatCtrl.text.trim();
                              _addingCustom = false;
                            });
                            _customCatCtrl.clear();
                          } catch (e) {
                            if (context.mounted) {
                              AppUtils.showSnackbar(
                                context,
                                'Failed to add category',
                                isError: true,
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.neonPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              },
              const SizedBox(height: 16),
              // Date selector
              InputLabel(label: 'Date', color: textColor),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (!context.mounted) return;
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkSurface
                        : const Color(0xFFF5F5FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: textColor.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_selectedDate),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_drop_down,
                        color: textColor.withValues(alpha: 0.6),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Note
              InputLabel(label: 'Note (Optional)', color: textColor),
              AppInputField(
                controller: _noteCtrl,
                hint: 'Add a note',
                isDark: isDark,
                textColor: textColor,
              ),
              const SizedBox(height: 28),
              // Save Button
              AppButton(
                text: widget.editExpense != null
                    ? 'Update Expense'
                    : 'Add Expense',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleCtrl.text.trim();
    final amount = double.parse(_amountCtrl.text.trim().replaceAll(',', ''));

    final provider = context.read<ExpenseProvider>();
    try {
      if (widget.editExpense != null) {
        await provider.editExpense(
          id: widget.editExpense!.id,
          title: title,
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          note: _noteCtrl.text.trim(),
        );
      } else {
        await provider.addExpense(
          title: title,
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          note: _noteCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        AppUtils.showSnackbar(context, 'Something went wrong', isError: true);
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.day == yesterday.day && date.month == yesterday.month) {
      return 'Yesterday';
    }
    return '${date.day} ${_month(date.month)} ${date.year}';
  }

  String _month(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m - 1];
  }

  Future<void> _confirmDeleteCategory(
    BuildContext context,
    String name,
    ExpenseProvider provider,
  ) async {
    final isDark = provider.isDarkMode;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Category?',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: isDark ? AppTheme.lightText : const Color(0xFF1A1A2E),
          ),
        ),
        content: Text(
          '"$name" will be removed from your custom categories.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppTheme.subText : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppTheme.subText : Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.dangerRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await provider.deleteCustomCategory(name);
        if (!context.mounted) return;
        if (_selectedCategory == name) {
          setState(() => _selectedCategory = 'Food & Drink');
        }
      } catch (e) {
        if (context.mounted) {
          AppUtils.showSnackbar(
            context,
            'Failed to delete category',
            isError: true,
          );
        }
      }
    }
  }
}
