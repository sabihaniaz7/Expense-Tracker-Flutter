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
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _selectedCategory = 'Food & Drink';
  DateTime _selectedDate = DateTime.now();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = provider.isDarkMode;
    final bg = isDark ? AppTheme.darkCard : Colors.white;
    final textColor = isDark ? AppTheme.lightText : const Color(0xFF1A1A2E);
    final subColor = isDark ? AppTheme.subText : Colors.grey[500]!;

    final allCategories = [
      ...AppCategories.categories.map((c) => c['name'] as String),
      ...provider.customCategories,
    ];

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.editExpense != null ? 'Edit Expense' : 'Add Expense',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),

            // Amount Input
            _buildLabel('Amount', textColor),
            _buildTextField(
              _amountCtrl,
              '\$ 0.00',
              isDark,
              textColor,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixText: '\$  ',
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 16),
            // Title
            _buildLabel('Title', textColor),
            _buildTextField(
              _titleCtrl,
              'What did you spend on?',
              isDark,
              textColor,
            ),
            const SizedBox(height: 16),

            // Category selector
            _buildLabel('Category', textColor),

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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final cat = allCategories[i];
                  final isSelected = _selectedCategory == cat;
                  final color = AppCategories.getColor(cat);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
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
                    child: _buildTextField(
                      _customCatCtrl,
                      'Category Name',
                      isDark,
                      textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_customCatCtrl.text.trim().isNotEmpty) {
                        provider.addCustomCategory(_customCatCtrl.text.trim());
                        setState(() {
                          _selectedCategory = _customCatCtrl.text.trim();
                          _addingCustom = false;
                        });
                        _customCatCtrl.clear();
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            },
            const SizedBox(height: 16),
            // Date selector
            _buildLabel('Date', textColor),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
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
            _buildLabel('Note (Optional)', textColor),
            _buildTextField(_noteCtrl, 'Add a note', isDark, textColor),
            const SizedBox(height: 28),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.editExpense != null ? 'Update Expense' : 'Add Expense',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    if (title.isEmpty || amount <= 0) return;
    final provider = context.read<ExpenseProvider>();
    if (widget.editExpense != null) {
      provider.editExpense(
        id: widget.editExpense!.id,
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        note: _noteCtrl.text.trim(),
      );
    } else {
      provider.addExpense(
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        note: _noteCtrl.text.trim(),
      );
    }
    Navigator.pop(context);
  }

  Widget _buildLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    bool isDark,
    Color textColor, {
    TextInputType? keyboardType,
    String? prefixText,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        hintStyle: TextStyle(
          color: textColor.withValues(alpha: 0.3),
          fontSize: fontSize,
        ),
        filled: true,
        fillColor: isDark ? AppTheme.darkSurface : const Color(0xFFF5F5FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
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
}
