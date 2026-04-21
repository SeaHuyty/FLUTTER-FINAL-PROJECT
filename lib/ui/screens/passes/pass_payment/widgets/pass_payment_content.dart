import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/view_model/pass_payment_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/widgets/payment_method_widget.dart';
import 'package:velo_toulouse_redesign/ui/screens/payment/qr_payment/qr_payment_screen.dart';
import 'package:velo_toulouse_redesign/ui/widgets/actions/button.dart';
import 'package:velo_toulouse_redesign/ui/widgets/display/header/app_bar.dart';
import 'package:velo_toulouse_redesign/ui/widgets/display/payment_info_card_widget.dart';

class PassPaymentContent extends StatelessWidget {
	const PassPaymentContent({super.key});

	void _goToPayment(BuildContext context) {
		Navigator.push(
			context,
			MaterialPageRoute(builder: (_) => const PaymentScreen()),
		);
	}

	@override
	Widget build(BuildContext context) {
		final vm = context.watch<PassPaymentViewModel>();

		return Scaffold(
			backgroundColor: const Color(0xFFF8F9FA),
			appBar: const StationAppBar(title: 'Payment'),
			body: Column(
				children: [
					const SizedBox(height: 10),
					if (vm.selectedPass != null)
          PaymentInfoCardWidget(pass: vm.selectedPass!),
					const SizedBox(height: 20),
					Container(
						padding: const EdgeInsets.only(
							top: 20,
							left: 16,
							right: 16,
							bottom: 40,
						),
						decoration: const BoxDecoration(
							color: Color(0xFFF4F6F5),
							borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
						),
						child: Column(
							children: [
								const PaymentMethodWidget(),
								const SizedBox(height: 30),
								const SizedBox(height: 20),
								VeloButton(
									text: 'Pay now',
									onPressed: vm.canPay ? () => _goToPayment(context) : null,
								),
							],
						),
					),
				],
			),
		);
	}
}
