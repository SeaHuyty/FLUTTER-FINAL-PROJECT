import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/models/ride_history.dart';

class HistoryTile extends StatelessWidget {
  final RideHistoryModel item;

  const HistoryTile({super.key, required this.item});

  String _formatDate(int? ms) {
    if (ms == null) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(ms);
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString().padLeft(4, '0');
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_bike, size: 18),
              const SizedBox(width: 8),
              Text(
                'Bike ${item.bikeNumber}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '\$${item.amountPaid.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('From: ${item.fromStationName}'),
          if (item.returnStationName != null)
            Text('To: ${item.returnStationName}'),
          const SizedBox(height: 6),
          Text('Start: ${_formatDate(item.startedAtMs)}'),
          Text('End: ${_formatDate(item.endedAtMs)}'),
          if (item.durationSeconds != null)
            Text('Duration: ${item.durationSeconds}s'),
        ],
      ),
    );
  }
}