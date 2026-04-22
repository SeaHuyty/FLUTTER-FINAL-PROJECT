import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/ui/theme/theme.dart';

class AlertDialogModal extends StatelessWidget {
  const AlertDialogModal({
    super.key,
    required this.stationName,
    required this.onConfirm,
  });

  final String stationName;
  final Future<void> Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF4F6F3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF006D33),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Confirm Return',
            style: AppTextStyles.heading.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure your bike is fully locked into the slot at $stationName before confirming.',
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(
              color: Colors.grey[500],
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // close dialog
                await onConfirm(); // then continue docking flow
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006D33),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Yes, bike is locked',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Go back',
              style: AppTextStyles.label.copyWith(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
