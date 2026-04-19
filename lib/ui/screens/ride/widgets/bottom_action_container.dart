import 'package:flutter/material.dart';

class BottomActionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const BottomActionContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: child,
    );
  }
}
