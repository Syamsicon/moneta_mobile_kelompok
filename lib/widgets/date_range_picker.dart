import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';

class DateRangePickerScreen extends StatefulWidget {
  final ValueChanged<DateTimeRange>? onDateRangeSelected;

  const DateRangePickerScreen({
    super.key,
    this.onDateRangeSelected,
  });

  @override
  State<DateRangePickerScreen> createState() => _DateRangePickerScreenState();
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {
  DateTimeRange? _selectedDateRange;

  // Function to trigger the Date Range Picker dialog
  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange ?? 
          DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7))),
      helpText: 'SELECT DATE RANGE',
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      widget.onDateRangeSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    
    // Format the display text according to your requirement
    String dateDisplayString;
    if (_selectedDateRange != null) {
      final startFormatted = dateFormat.format(_selectedDateRange!.start);
      final endFormatted = dateFormat.format(_selectedDateRange!.end);
      dateDisplayString = '$startFormatted - $endFormatted';
    } else {
      dateDisplayString = 'Select date';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'Range: ',
              style: TextStyle( //sectionTitle
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              dateDisplayString,
              style: AppTextStyles.sectionTitle
            ),
          ],
        ),
        InkWell(
          onTap: () => _showDateRangePicker(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: const Icon(Icons.calendar_month, size: 20, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}