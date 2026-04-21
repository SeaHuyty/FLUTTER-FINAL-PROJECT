import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/ui/viewmodels/pass_booking_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/view_model/pass_payment_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/widgets/pass_payment_content.dart';

class PassPaymentScreen extends StatelessWidget {
	const PassPaymentScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (context) => PassPaymentViewModel(
				selectedPass: context.read<PassBookingProvider>().selectedPass,
			),
			child: const PassPaymentContent(),
		);
	}
}
