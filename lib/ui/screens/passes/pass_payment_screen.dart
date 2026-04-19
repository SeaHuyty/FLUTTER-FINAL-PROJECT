import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/pass_booking_provider.dart';
import '../../shared/display/top_bar/app_bar.dart';
import 'widgets/payment_method_widget.dart';
import '../../shared/display/payment_info_card_widget.dart';
import '../../shared/actions/button.dart';
import 'package:velo_toulouse_redesign/ui/screens/payment/payment_screen.dart';

class PassPaymentScreen extends ConsumerWidget {
  const PassPaymentScreen({super.key});

  void payNow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPass = ref.watch(selectedPassProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const StationAppBar(title: "Payment"),
      body: Column(
        children: [
          const SizedBox(height: 10),
          if (selectedPass != null)
            PaymentInfoCardWidget(pass: selectedPass),

          SizedBox(height: 20),

         Container(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFFF4F6F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const PaymentMethodWidget(),
                const SizedBox(height: 30),

              SizedBox(height: 20),

                VeloButton(
                  text: "Pay now",
                  onPressed: () {
                    payNow(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

