import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionItem({super.key, required this.transaction, this.onTap});

  String _formatRupiah(double amount) {
    final sign = amount < 0 ? '-' : '';
    final digits = amount.abs().toStringAsFixed(0);
    final withDots = digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return '${sign}Rp$withDots';
  }

  @override
  Widget build(BuildContext context) {
    final date = transaction.parsedDate;
    final dateLabel = date == null
        ? transaction.date
        : DateFormat('d MMM').format(date);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.merchantName,
                    style: AppTextStyles.merchantName,
                  ),
                  Text(
                    '$dateLabel | ${transaction.location}',
                    style: AppTextStyles.merchantDetail,
                  ),
                ],
              ),
            ),
            Text(_formatRupiah(transaction.amount), style: AppTextStyles.amount),
          ],
        ),
      ),
    );
  }
}
