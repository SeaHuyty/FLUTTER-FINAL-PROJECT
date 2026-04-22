import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/view_model/pass_payment_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/view_model/ride_session_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/auth/view_model/auth_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/ride_history/view_model/ride_history_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/ride/active_ride_screen.dart';
import 'package:velo_toulouse_redesign/main_common.dart';
import 'package:velo_toulouse_redesign/ui/widgets/actions/button.dart';
import 'package:velo_toulouse_redesign/ui/widgets/display/payment_info_card_widget.dart';
import 'package:velo_toulouse_redesign/ui/widgets/display/success_header.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isStartingRide = false;

  @override
  Widget build(BuildContext context) {
    final rideSession = context.watch<RideSessionViewModel>().session;
    final passPaymentViewModel = context.watch<PassPaymentViewModel?>();
    final selectedPass = passPaymentViewModel?.selectedPass;

    if (rideSession == null && selectedPass == null) {
      return const Scaffold(
        body: Center(child: Text('No active payment flow found.')),
      );
    }

    final isPassFlow = selectedPass != null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SuccessHeader(
              title: isPassFlow ? 'Pass Activated!' : 'Payment successful!',
              subtitle: isPassFlow
                  ? 'Your ${selectedPass.title} is now active. Enjoy your rides!'
                  : 'Your payment has been completed. Your bike is unlocked!',
              circleColor: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF2E7D32),
            ),
            if (isPassFlow) ...[
              const SizedBox(height: 30),
              PaymentInfoCardWidget(
                pass: selectedPass,
                expiryDate: passPaymentViewModel?.expiryText ?? 'N/A',
              ),
            ],
            const SizedBox(height: 50),
            VeloButton(
              text: isPassFlow ? 'Go to Map' : 'Start Riding',
              onPressed: isPassFlow
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    }
                  : _isStartingRide
                  ? null
                  : () async {
                      final currentRideSession = rideSession;
                      final authUser = context.read<AuthViewModel>().user;

                      if (authUser == null || currentRideSession == null) {
                        return;
                      }

                      if (currentRideSession.sessionId == null) {
                        setState(() {
                          _isStartingRide = true;
                        });
                        try {
                          final history = await context
                              .read<RideHistoryViewModel>()
                              .startRide(
                                userId: authUser.uid,
                                bikeNumber: currentRideSession.bikeNumber,
                                fromStationName:
                                    currentRideSession.fromStationName,
                                fromStationAddress:
                                    currentRideSession.fromStationAddress,
                                amountPaid:
                                    currentRideSession.amountPaid ?? 2.0,
                              );

                          if (history != null) {
                            if (!context.mounted) return;
                            context.read<RideSessionViewModel>().setSession(
                              currentRideSession.copyWith(
                                sessionId: history.id,
                                userId: history.userId,
                                startedAtMs: history.startedAtMs,
                                amountPaid: history.amountPaid,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isStartingRide = false;
                            });
                          }
                        }
                      }

                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActiveRideScreen(),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
