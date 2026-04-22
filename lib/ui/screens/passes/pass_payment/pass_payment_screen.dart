import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/view_model/pass_payment_view_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_payment/widgets/pass_payment_content.dart';

class PassPaymentScreen extends StatelessWidget {
	final PassModel? selectedPass;

	const PassPaymentScreen({super.key, required this.selectedPass});

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (context) =>
				PassPaymentViewModel(
					initialSelectedPass: selectedPass,
				)..loadSelectedPass(),
			child: const PassPaymentContent(),
		);
	}
}
