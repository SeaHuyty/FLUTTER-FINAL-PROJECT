import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/ui/theme/theme.dart';
import 'package:velo_toulouse_redesign/models/station.dart';

class StationSelectionCard extends StatelessWidget {
  final StationModel station;
  final bool isCurrentReturn;
  final VoidCallback onConfirm;

  const StationSelectionCard({
    super.key,
    required this.station,
    required this.isCurrentReturn,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_parking_rounded,
                  color: Color(0xFF006D33),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      station.address,
                      style: AppTextStyles.label.copyWith(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF006D33),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${station.availableSpots} spots',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isCurrentReturn ? null : onConfirm,
              icon: Icon(
                isCurrentReturn
                    ? Icons.flag_rounded
                    : Icons.check_circle_rounded,
                size: 18,
              ),
              label: Text(
                isCurrentReturn
                    ? 'Selected as return station'
                    : 'Return Bike Here',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrentReturn
                    ? Colors.grey[200]
                    : const Color(0xFF006D33),
                foregroundColor: isCurrentReturn
                    ? Colors.grey[500]
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
