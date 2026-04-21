import 'package:flutter/material.dart';
import 'package:velo_toulouse_redesign/models/pass.dart';

class PassPaymentViewModel extends ChangeNotifier {
	final PassModel? selectedPass;

	PassPaymentViewModel({required this.selectedPass});

	bool get canPay => selectedPass != null;
}
