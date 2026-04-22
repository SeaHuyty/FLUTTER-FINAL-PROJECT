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
		final vm = context.read<PassPaymentViewModel>();
		Navigator.push(
			context,
			MaterialPageRoute(
				builder: (_) => ChangeNotifierProvider.value(
					value: vm,
					child: const PaymentScreen(),
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		final vm = context.watch<PassPaymentViewModel>();
		final selectedPass = vm.pass;

		Widget body;
		if (selectedPass == null) {
			body = Center(child: Text(vm.noPassSelectedMessage));
		} else {
			body = Column(
				children: [
					PaymentInfoCardWidget(
						pass: selectedPass,
						expiryDate: vm.expiryText,
					),
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
								VeloButton(
									text: vm.payNowButtonText,
									onPressed: vm.canPay ? () => _goToPayment(context) : null,
								),
							],
						),
					),
				],
			);
		}

		return Scaffold(
			backgroundColor: const Color(0xFFF8F9FA),
			appBar: const StationAppBar(title: 'Payment'),
			body: body,
		);
	}
}
