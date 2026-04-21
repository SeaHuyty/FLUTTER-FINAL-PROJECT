import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/models/user.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/pass_payment_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_selection/view_model/pass_selection_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/viewmodels/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/theme/theme.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';
import 'package:velo_toulouse_redesign/ui/utils/date_format.dart';
import 'package:velo_toulouse_redesign/ui/viewmodels/pass_booking_view_model.dart';
import 'package:velo_toulouse_redesign/ui/widgets/actions/button.dart';
import 'pass_card_widget.dart';

class PassSelectionContent extends StatefulWidget {
  const PassSelectionContent({super.key});

  @override
  State<PassSelectionContent> createState() => _PassSelectionContentState();
}

class _PassSelectionContentState extends State<PassSelectionContent> {
  void _fetchPasses() {
    context.read<PassSelectionViewModel>().fetchPasses();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchPasses();
    });
  }

  void goToPayment(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PassPaymentScreen()));
  }

  void _onSelectPass(PassSelectionViewModel vm, PassModel pass) {
    vm.selectPass(pass);
    context.read<PassBookingProvider>().setSelectedPass(pass);
  }

  void _showRemovePassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Pass'),
        content: const Text(
          'Are you sure you want to remove your active pass?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<UserViewModel>().removeActivePass();

              if (!context.mounted) return;
              context.read<PassBookingProvider>().setSelectedPass(null);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pass removed successfully')),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildPassInfoCard(BuildContext context, UserModel user) {
    final parsedExpiry = DateFormatter.tryParseIsoDate(user.activePassExpiry);
    final expiryText =
        parsedExpiry == null ? 'N/A' : DateFormatter.formatPassExpiry(parsedExpiry);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Pass',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'remove') {
                    _showRemovePassDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'remove',
                    child: Text('Remove Pass'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            user.activePassTitle ?? 'No Pass',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Expires: $expiryText',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PassSelectionViewModel>();
    final user = context.watch<UserViewModel>().user;

    final hasActivePass = vm.hasActivePass(user?.activePassExpiry);

    if (hasActivePass && user != null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Center(child: Text('Your Pass')),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: AppColors.primaryColor,
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You already have an active pass. You cannot purchase a new one until it expires.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildPassInfoCard(context, user),
            ],
          ),
        ),
      );
    }

    Widget body;
    if (vm.passes.state == AsyncValueState.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (vm.passes.state == AsyncValueState.error) {
      body = const Center(child: Text('Error loading passes'));
    } else {
      final passes = vm.passes.data ?? [];

      body = Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 180),
            itemCount: passes.length,
            itemBuilder: (context, index) {
              final pass = passes[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PassCardWidget(
                  pass: pass,
                  description: 'Valid for ${pass.duration}',
                  icon: Icons.calendar_today_outlined,
                  isSelected: vm.selectedPass?.id == pass.id,
                  onTap: hasActivePass ? () {} : () => _onSelectPass(vm, pass),
                ),
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: VeloButton(
              text: hasActivePass ? 'Pass Already Active' : 'Continue to Payment',
              onPressed: (hasActivePass || vm.selectedPass == null)
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
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You already have an active pass.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Center(child: Text("Select a Pass")),
        backgroundColor: Colors.white,
      ),
      body: body,
    );
  }
}