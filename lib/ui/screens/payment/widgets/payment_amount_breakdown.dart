import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class PaymentAmountBreakdown extends StatelessWidget {
  final String subtotalLabel;
  final String subtotalAmount;
  final String totalLabel;
  final String totalAmount;

  const PaymentAmountBreakdown({
    super.key,
    required this.subtotalLabel,
    required this.subtotalAmount,
    required this.totalLabel,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(subtotalLabel), Text(subtotalAmount)],
        ),
        const SizedBox(height: 15),
        const DottedLine(
          dashLength: 6,
          dashGapLength: 4,
          lineThickness: 1,
          dashColor: Colors.grey,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              totalLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              totalAmount,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
