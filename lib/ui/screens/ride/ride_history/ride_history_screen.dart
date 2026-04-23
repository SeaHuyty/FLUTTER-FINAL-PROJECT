import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_history/view_model/ride_history_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_history/widgets/ride_history_tile.dart';
import 'package:velo_toulouse_redesign/ui/theme/theme.dart';
import 'package:velo_toulouse_redesign/ui/widgets/display/header/app_bar.dart';

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
                    return HistoryTile(item: item);
                  },
                );
              },
            ),
    );
  }
}