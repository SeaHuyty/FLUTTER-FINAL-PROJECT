import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import '../../theme/theme.dart';

class PaymentInfoCardWidget extends StatelessWidget {
  final PassModel pass;
  final String? expiryDate;

  const PaymentInfoCardWidget({
    super.key,
    required this.pass,
    this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 53, 139, 56),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Plan",
            style: AppTextStyles.heading.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Icon(
                Icons.confirmation_num_outlined,
                color: AppColors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pass.title,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    "Valid for ${pass.duration}",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Divider(
            color: AppColors.white.withValues(alpha: 0.3),
            thickness: 3,
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.euro_rounded,
                color: AppColors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Text(
                "Price: ${pass.price.toStringAsFixed(0)}€",
                style: AppTextStyles.body.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),

          if (expiryDate != null && expiryDate!.isNotEmpty) ...[
            Divider(
                color: AppColors.white.withValues(alpha: 0.3),
                thickness: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Valid Until: $expiryDate",
              style: AppTextStyles.label.copyWith(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
