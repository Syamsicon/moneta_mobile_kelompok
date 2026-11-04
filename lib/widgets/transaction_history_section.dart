import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneta/widgets/date_range_picker.dart';
import '../routes/app_routes.dart';
import '../models/transaction_model.dart';
import '../theme/app_text_styles.dart';
import 'transaction_item.dart';

class TransactionHistorySection extends StatefulWidget {
  final List<TransactionModel> transaction;
  final VoidCallback? onViewAll;

  const TransactionHistorySection({
    super.key,
    required this.transaction,
    this.onViewAll,
  });

  @override
  State<TransactionHistorySection> createState() =>
      _TransactionHistorySectionState();
}

class _TransactionHistorySectionState extends State<TransactionHistorySection> {
  DateTimeRange? _selectedDateRange;

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  @override
  Widget build(BuildContext context) {
    final visibleTransactions = widget.transaction.where((transaction) {
      final range = _selectedDateRange;
      if (range == null) return true;

      final transactionDate = transaction.parsedDate;
      if (transactionDate == null) return false;

      final date = _dateOnly(transactionDate);
      return !date.isBefore(_dateOnly(range.start)) &&
          !date.isAfter(_dateOnly(range.end));
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text('Riwayat', 
              style: AppTextStyles.title,
              ),
              DateRangePickerScreen(
                onDateRangeSelected: (range) {
                  setState(() {
                    _selectedDateRange = range;
                  });
                },
              ),
            ],
          ),  
        ),
        const SizedBox(height: 8),
        ...visibleTransactions.map(
          (t) => TransactionItem(
            transaction: t,
            // Pencet baris -> masuk halaman Edit
            onTap: () => Get.toNamed(AppRoutes.editTransaksi, arguments: t),
          ),
        ),
      ],
    );
  }
}