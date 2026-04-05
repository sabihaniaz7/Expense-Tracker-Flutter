import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Represents a single row in an expense list, with edit/delete actions.
class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = AppCategories.getColor(expense.category);
    final emoji = AppCategories.getEmoji(expense.category);
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFmt = DateFormat('MMM d');

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      // confirmDismiss shows the dialog; actual delete only if confirmed
      confirmDismiss: (_) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: isDark ? AppTheme.darkCard : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Delete Expense?',
              style: TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: isDark ? AppTheme.lightText : const Color(0xFF1A1A2E),
              ),
            ),
            content: Text(
              '"${expense.title}" will be permanently removed.',
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
        return confirmed ?? false;
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.dangerRed.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_rounded,
              color: AppTheme.dangerRed,
              size: 22,
            ),
            const SizedBox(height: 2),
            const Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.dangerRed,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              // Category Emoji Bubble
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.15 : 0.18),
                  borderRadius: .circular(12),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),
              // Title & Category
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      expense.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: isDark
                            ? AppTheme.lightText
                            : const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      expense.category,
                      style: TextStyle(
                        color: isDark ? AppTheme.subText : Colors.grey[500],
                        fontSize: 12,
                        fontWeight: .w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount & Date
              Column(
                crossAxisAlignment: .end,

                children: [
                  Text(
                    '- ${fmt.format(expense.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.dangerRed,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dateFmt.format(expense.date),
                    style: TextStyle(
                      color: isDark ? AppTheme.subText : Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
