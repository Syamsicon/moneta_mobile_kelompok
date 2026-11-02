import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../theme/app_text_styles.dart';
import 'transaction_item.dart';

class TransactionListSection extends StatelessWidget {
  final List<TransactionModel> transaction;
  final VoidCallback? onViewAll;

  const TransactionListSection({
    super.key,
    required this.transaction,
    this.onViewAll,
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transaksi Terbaru', style: AppTextStyles.sectionTitle,),
              GestureDetector(
                onTap: onViewAll,
                child: Text('Lihat Semua', style: AppTextStyles.linkAction,),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...transaction.map((t) => TransactionItem(transaction: t)),
      ],
    );
  }
}