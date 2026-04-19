import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';

class SwipeToDock extends StatefulWidget {
  final VoidCallback onDocked;

  const SwipeToDock({super.key, required this.onDocked});

  @override
  State<SwipeToDock> createState() => _SwipeToDockState();
}

class _SwipeToDockState extends State<SwipeToDock> {
  double _dragPosition = 0;
  static const double _thumbSize = 56;
  static const double _threshold = 0.85;

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(
        0,
        maxWidth - _thumbSize,
      );
    });
  }

  void _onDragEnd(double maxWidth) {
    if (maxWidth <= _thumbSize) {
      setState(() => _dragPosition = 0);
      return;
    }

    final progress = _dragPosition / (maxWidth - _thumbSize);
    if (progress >= _threshold) {
      widget.onDocked();
    } else {
      setState(() => _dragPosition = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final progress = maxWidth <= _thumbSize
            ? 0.0
            : _dragPosition / (maxWidth - _thumbSize);

        if (maxWidth <= _thumbSize && _dragPosition != 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _dragPosition = 0);
            }
          });
        }

        return Container(
          height: _thumbSize,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _dragPosition + _thumbSize,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: progress * 0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Center(
                child: Opacity(
                  opacity: (1 - progress * 2).clamp(0, 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: _thumbSize * 0.5),
                      Text(
                        'Swipe to confirm dock',
                        style: AppTextStyles.label.copyWith(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: _dragPosition,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) => _onDragUpdate(d, maxWidth),
                  onHorizontalDragEnd: (_) => _onDragEnd(maxWidth),
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      progress >= _threshold
                          ? Icons.check_rounded
                          : Icons.chevron_right_rounded,
                      color: const Color(0xFF006D33),
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
