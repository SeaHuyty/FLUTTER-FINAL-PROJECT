import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';

class StationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const StationAppBar({
    super.key, 
    required this.title, 
    this.onBackPressed
    });

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            color: const Color(0xFF1A1A1A),
            onPressed: onBackPressed ?? () => goBack(context),
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.heading.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1A),
          letterSpacing: -0.3,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
    );
  }
}
