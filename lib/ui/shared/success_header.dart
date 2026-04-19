import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';

class SuccessHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color circleColor;
  final Color iconColor;
  final double circleSize;
  final double iconSize;

  const SuccessHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.circleColor,
    required this.iconColor,
    this.circleSize = 92,
    this.iconSize = 54,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Icon(Icons.check_rounded, size: iconSize, color: iconColor),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: AppTextStyles.heading.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.label.copyWith(color: Colors.blueGrey),
        ),
      ],
    );
  }
}
