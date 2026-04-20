import 'package:velo_toulouse_redesign/ui/screens/user/viewmodels/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment_screen.dart';
import '../../../core/providers/pass_booking_provider.dart';
import 'viewmodels/pass_viewmodel.dart';
import 'widgets/pass_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/actions/button.dart';
import '../../../core/theme/theme.dart';

class SelectPassScreen extends StatelessWidget {
  const SelectPassScreen({super.key});

  void goToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PassPaymentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passViewModel = context.watch<PassViewModel>();
    final selectedPass = context.watch<PassBookingProvider>().selectedPass;
    final user = context.watch<UserViewModel>().user;

    bool hasActivePass = false;

    if (user != null && user.activePassExpiry != null) {
      hasActivePass = passViewModel.hasActivePass();
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Center(child: Text("Select a Pass")),
        backgroundColor: Colors.white,
      ),
      body: passViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : passViewModel.error != null
          ? Center(child: Text('Error: ${passViewModel.error}'))
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 180,
                  ),
                  itemCount: passViewModel.passes.length,
                  itemBuilder: (context, index) {
                    final pass = passViewModel.passes[index];
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
                                context
                                    .read<PassBookingProvider>()
                                    .setSelectedPass(pass);
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
                    onPressed: hasActivePass
                        ? null
                        : () => goToPayment(context),
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
            ),
    );
  }
}
