import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current month and day
    DateTime today = DateTime.now();

    // Generate the list of months starting from the current month
    List<String> months = List.generate(12, (index) {
      DateTime month = DateTime(today.year, today.month + index);
      return DateFormat.MMMM().format(month);
    });

    return Wrap(
      spacing: 25, // Add spacing between chips
      children: [
        // First chip is always "Today"
        FilterChip(
          label: const Text("Today"),
          onSelected: (bool value) {
            // Handle Today chip selection
          },
        ),
        // Create chips dynamically for the months starting from the current one
        ...months.map((month) {
          return FilterChip(
            label: Text(month),
            onSelected: (bool value) {
              // Handle month chip selection
            },
          );
        }).toList(),
      ],
    );
  }
}
