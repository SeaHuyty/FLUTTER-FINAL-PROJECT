import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/models/pass_model.dart';

class PassCardWidget extends StatelessWidget {
  final PassModel pass;
  final String description;
  final VoidCallback onTap;
  final bool isSelected;
  final IconData icon;

  const PassCardWidget({
    super.key,
    required this.pass,
    required this.description,
    required this.onTap,
    this.isSelected = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primaryColor,
            width: isSelected ? 4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightbluewhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColors.brown,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pass.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryColor,
                    size: 32,
                  ),
                if (isSelected) const SizedBox(height: 18),
                Text(
                  '€ ${pass.price.toStringAsFixed(2)}',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brown,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
      
