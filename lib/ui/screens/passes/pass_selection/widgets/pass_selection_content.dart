import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/pass_payment_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_selection/view_model/pass_selection_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/user_profile/view_model/user_view_model.dart';
import 'package:velo_toulouse_redesign/ui/theme/theme.dart';
import 'package:velo_toulouse_redesign/ui/utils/async_value.dart';
import 'package:velo_toulouse_redesign/ui/widgets/actions/button.dart';
import 'active_pass_tile.dart';
import 'pass_card_widget.dart';

class PassSelectionContent extends StatefulWidget {
  const PassSelectionContent({super.key});

  @override
  State<PassSelectionContent> createState() => _PassSelectionContentState();
}

class _PassSelectionContentState extends State<PassSelectionContent> {

  @override
  void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<PassSelectionViewModel>().fetchPasses();

    final userVm = context.read<UserViewModel>();
    if (userVm.user == null) {
      userVm.loadCurrentUser();
    }
  });
}

  void goToPayment(BuildContext context) {
    final vm = context.read<PassSelectionViewModel>();
    final selectedPass = vm.selectedPass;
    if (selectedPass == null) {
        return;
    }
    
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => PassPaymentScreen(selectedPass: selectedPass),
      ),
    );
  }

  void onSelectPass(PassSelectionViewModel vm, PassModel pass) {
    vm.selectPass(pass);
  }

  void showRemovePassDialog(BuildContext context) {
    final userViewModel = context.read<UserViewModel>();
    final passSelectionViewModel = context.read<PassSelectionViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Pass'),
        content: const Text('Are you sure you want to remove your active pass?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await userViewModel.removeActivePass();

              passSelectionViewModel.clearSelection();
              messenger.showSnackBar(
                const SnackBar(content: Text('Pass removed successfully')),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget activePassBanner() {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
				color: const Color.fromARGB(255, 172, 175, 172),
        borderRadius: BorderRadius.circular(12), 
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'You already have an active pass. You cannot purchase a new one until it expires.',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget passSelectionCard(PassSelectionViewModel vm) {
    final passes = vm.passes.data ?? [];

    return Stack(
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
                onTap: () => onSelectPass(vm, pass),
              ),
            );
          },
        ),
        Positioned(
          bottom: 100,
          left: 16,
          right: 16,
          child: VeloButton(
            text: 'Continue to Payment',
            onPressed: vm.selectedPass == null ? null : () => goToPayment(context),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PassSelectionViewModel>();
    final userVm = context.watch<UserViewModel>();
    final user = userVm.user;

    if (userVm.isLoading && user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
              activePassBanner(),
              const SizedBox(height: 50),
              ActivePassTile(
                user: user,
                onRemove: () => showRemovePassDialog(context),
              ),
            ],
          ),
        ),
      );
    }

    final Widget body = switch (vm.passes.state) {
      AsyncValueState.loading => const Center(child: CircularProgressIndicator()),
      AsyncValueState.error => const Center(child: Text('Error loading passes')),
      AsyncValueState.success => passSelectionCard(vm),
    };

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Center(child: Text('Select a Pass')),
        backgroundColor: Colors.white,
      ),
      body: body,
    );
  }
}