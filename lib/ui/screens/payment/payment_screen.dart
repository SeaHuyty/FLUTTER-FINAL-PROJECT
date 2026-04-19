import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/core/providers/pass_booking_provider.dart';
import 'package:velo_toulouse_redesign/core/providers/ride_session_provider.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/viewmodels/pass_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/map/viewmodels/station_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/payment/payment_success_screen.dart';
import 'package:velo_toulouse_redesign/ui/screens/payment/widgets/payment_amount_breakdown.dart';
import 'package:velo_toulouse_redesign/ui/screens/payment/widgets/qr_payment_instruction_section.dart';
import 'package:velo_toulouse_redesign/ui/shared/display/top_bar/app_bar.dart';

enum ProcessStage { initialize, paying, processing, paid }

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  Timer? _stageTimer;
  ProcessStage stage = ProcessStage.initialize;

  @override
  void initState() {
    super.initState();
    _startStageTimer();
  }

  void _startStageTimer() {
    _stageTimer?.cancel();

    final duration = switch (stage) {
      ProcessStage.initialize => const Duration(seconds: 3),
      ProcessStage.paying => const Duration(seconds: 6),
      ProcessStage.processing => const Duration(seconds: 2),
      ProcessStage.paid => null,
    };

    if (duration == null) return;

    _stageTimer = Timer(duration, () {
      if (!mounted) return;
      unawaited(_advanceStage());
    });
  }

  Future<void> _advanceStage() async {
    final next = switch (stage) {
      ProcessStage.initialize => ProcessStage.paying,
      ProcessStage.paying => ProcessStage.processing,
      ProcessStage.processing => ProcessStage.paid,
      ProcessStage.paid => null,
    };

    if (next == null) return;

    setState(() => stage = next);

    if (next == ProcessStage.paid) {
      final selectedPass = ref.read(selectedPassProvider);
      if (selectedPass != null) {
        ref.read(passViewModelProvider.notifier).purchasePass(selectedPass);
      } else {
        final currentRide = ref.read(rideSessionProvider);
        if (currentRide?.fromStationId != null) {
          try {
            await ref
                .read(stationViewModelProvider.notifier)
                .checkoutBike(
                  stationId: currentRide!.fromStationId!,
                  bikeNumber: currentRide.bikeNumber,
                );
          } catch (_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Could not unlock bike. Please try again.'),
                ),
              );
            }
          }
        }
      }
    }

    if (next != ProcessStage.paid) {
      _startStageTimer();
    }
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideSession = ref.watch(rideSessionProvider);
    final selectedPass = ref.watch(selectedPassProvider);

    if (rideSession == null && selectedPass == null) {
      return const Scaffold(
        body: Center(
          child: Text('No active ride session found. Please start again.'),
        ),
      );
    }

    return switch (stage) {
      ProcessStage.initialize => _buildInitialize(),
      ProcessStage.paying => _buildPayingWithOverlay(),
      ProcessStage.processing => _buildPayingWithOverlay(),
      ProcessStage.paid => const PaymentSuccessScreen(),
    };
  }

  Widget _buildInitialize() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing payment'),
          ],
        ),
      ),
    );
  }

  Widget _buildPayingWithOverlay() {
    return Stack(
      children: [
        _buildPaying(),
        if (stage == ProcessStage.processing) _buildProcessingOverlay(),
      ],
    );
  }

  Widget _buildProcessingOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            color: Colors.black.withValues(alpha: 0.35),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Processing payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaying() {
    final selectedPass = ref.watch(selectedPassProvider);

    final String amountLabel = selectedPass != null
        ? '${selectedPass.price.toStringAsFixed(2)} USD'
        : '2.00 USD';

    return Scaffold(
      appBar: StationAppBar(title: 'Please wait'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
          children: [
            const SizedBox(height: 70),
            const QrPaymentInstructionSection(
              imageAssetPath: 'assets/images/mock_qr.JPG',
            ),
            const SizedBox(height: 55),
            PaymentAmountBreakdown(
              subtotalLabel: 'Subtotal:',
              subtotalAmount: amountLabel,
              totalLabel: 'Total:',
              totalAmount: amountLabel,
            ),
          ],
        ),
      ),
    );
  }
}
