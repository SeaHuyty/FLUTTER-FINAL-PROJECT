import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';

class VeloButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const VeloButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(text, 
          style: AppTextStyles.heading.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}