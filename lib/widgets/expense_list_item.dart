import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:expense_tracker/utils/app_categories.dart';
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
              borderRadius: BorderRadius.circular(AppTheme.rad20),
            ),
            title: Text(
              'Delete Expense?',
              style: TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.w500,
                fontSize: AppTheme.fs18,
                color: isDark ? AppTheme.lightText : AppTheme.lightPrimaryText,
              ),
            ),
            content: Text(
              '"${expense.title}" will be permanently removed.',
              style: TextStyle(
                fontSize: AppTheme.fs14,
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
        padding: const EdgeInsets.only(right: AppTheme.sp20),
        margin: const EdgeInsets.only(bottom: AppTheme.sp10),
        decoration: BoxDecoration(
          color: AppTheme.dangerRed.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppTheme.rad16),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_rounded,
              color: AppTheme.dangerRed,
              size: AppTheme.fs22,
            ),
            const SizedBox(height: 2),
            const Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.dangerRed,
                fontSize: AppTheme.fs11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppTheme.sp10),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.sp16,
            vertical: AppTheme.sp14,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.rad16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Emoji Bubble
              Container(
                width: AppTheme.sp46,
                height: AppTheme.sp46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.15 : 0.18),
                  borderRadius: BorderRadius.circular(AppTheme.rad12),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: AppTheme.fs22),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.sp14),
              // Title & Category
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      expense.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: AppTheme.fs15,
                        color: isDark
                            ? AppTheme.lightText
                            : AppTheme.lightPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      expense.category.startsWith(
                                AppCategories.getEmoji(expense.category),
                              ) &&
                              expense.category.length >
                                  AppCategories.getEmoji(
                                    expense.category,
                                  ).length
                          ? expense.category
                                .substring(
                                  AppCategories.getEmoji(
                                    expense.category,
                                  ).length,
                                )
                                .trim()
                          : expense.category,
                      style: TextStyle(
                        color: isDark ? AppTheme.subText : Colors.grey[500],
                        fontSize: AppTheme.fs12,
                        fontWeight: .w500,
                      ),
                    ),
                    if (expense.note.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.sp4),
                      Text(
                        expense.note,
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.subText.withValues(alpha: 0.8)
                              : Colors.grey[600],
                          fontSize: AppTheme.fs12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ],
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
                      fontSize: AppTheme.fs15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dateFmt.format(expense.date),
                    style: TextStyle(
                      color: isDark ? AppTheme.subText : Colors.grey[400],
                      fontSize: AppTheme.fs12,
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
