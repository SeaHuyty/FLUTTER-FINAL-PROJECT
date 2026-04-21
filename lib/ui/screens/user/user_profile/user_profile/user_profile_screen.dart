import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/ui/theme/theme.dart';
import 'package:velo_toulouse_redesign/ui/viewmodels/pass_booking_view_model.dart';
import 'package:velo_toulouse_redesign/models/user.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/viewmodels/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/auth/login/login_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/user_profile/edit_profile/edit_profile_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_history/ride_history_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/widgets/user_menu.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    final user = userViewModel.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: const Text('Profile')),
      ),
      body: userViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userViewModel.hasError
          ? const Center(child: Text('Failed to load profile'))
          : user == null
          ? const Center(child: Text('No profile found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.imageUrl.isNotEmpty
                              ? NetworkImage(user.imageUrl)
                              : null,
                          child: user.imageUrl.isEmpty
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(user: user),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  if (user.activePassTitle != null) ...[
                    const SizedBox(height: 24),
                    _buildPassInfoCard(context, user),
                  ],
                  const SizedBox(height: 24),
                  UserMenu(
                    onHistory: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RideHistoryScreen(),
                        ),
                      );
                    },
                    onLogout: () async {
                      await context.read<UserViewModel>().signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (_) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPassInfoCard(BuildContext context, UserModel user) {
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
                  'Expires: ${user.activePassExpiry ?? 'N/A'}',
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
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pass removed successfully')),
                );
              }
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
