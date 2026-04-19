import 'package:velo_toulouse_redesign/ui/screens/user/viewmodels/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment_screen.dart';
import '../../../core/providers/pass_booking_provider.dart';
import 'viewmodels/pass_viewmodel.dart';
import 'widgets/pass_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/actions/button.dart';
import '../../../core/theme/theme.dart';

class SelectPassScreen extends ConsumerWidget {
  const SelectPassScreen({super.key});

  void goToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PassPaymentScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passesAsync = ref.watch(passViewModelProvider);
    final selectedPass = ref.watch(selectedPassProvider);
    final userAsync = ref.watch(userViewModelProvider);

    final user = userAsync.value;
    bool hasActivePass = false;

    if (user != null && user.activePassExpiry != null) {
      final viewModel = ref.read(passViewModelProvider.notifier);
      hasActivePass = viewModel.hasActivePass();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Center(child: Text("Select a Pass")),
        backgroundColor: Colors.white,
      ),
      body: passesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (passes) {
          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 180,
                ),
                itemCount: passes.length,
                itemBuilder: (context, index) {
                  final pass = passes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PassCardWidget(
                      pass: pass,
                      description: 'Valid for ${pass.duration}',
                      icon: Icons.calendar_today_outlined,
                      isSelected: selectedPass?.title == pass.title,
                      onTap: hasActivePass
                          ? () {}
                          : () {
                              ref.read(selectedPassProvider.notifier).state =
                                  pass;
                            },
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 100,
                left: 16,
                right: 16,
                child: VeloButton(
                  text: hasActivePass
                      ? 'Pass Already Active'
                      : 'Continue to Payment',
                  onPressed: hasActivePass ? null : () => goToPayment(context),
                ),
              ),
              if (hasActivePass)
                Positioned(
                  top: 490,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: AppColors.primaryColor,
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.white),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'You already have an active pass. You cannot purchase a new one until it expires.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
