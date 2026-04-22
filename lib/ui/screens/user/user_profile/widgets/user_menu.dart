import 'package:flutter/material.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({super.key, required this.onHistory, required this.onLogout});

  final VoidCallback onHistory;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('Ride history'),
          trailing: const Icon(Icons.chevron_right),
          onTap: onHistory,
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          trailing: const Icon(Icons.chevron_right),
          onTap: onLogout,
        ),
      ],
    );
  }
}
