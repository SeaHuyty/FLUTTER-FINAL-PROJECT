import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/models/ride_history_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/viewmodels/ride_history_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/shared/display/top_bar/app_bar.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyViewModel = context.watch<RideHistoryViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: StationAppBar(title: 'Ride History'),
      body: historyViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyViewModel.error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Failed to load history: ${historyViewModel.error}'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () =>
                        context.read<RideHistoryViewModel>().fetchHistory(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Builder(
              builder: (_) {
                final history = historyViewModel.rides;
                if (history.isEmpty) {
                  return const Center(child: Text('No rides yet'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: history.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return _HistoryTile(item: item);
                  },
                );
              },
            ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final RideHistoryModel item;

  const _HistoryTile({required this.item});

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
