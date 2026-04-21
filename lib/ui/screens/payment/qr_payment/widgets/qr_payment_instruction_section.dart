import 'package:flutter/material.dart';

class QrPaymentInstructionSection extends StatelessWidget {
  final String imageAssetPath;

  const QrPaymentInstructionSection({super.key, required this.imageAssetPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.53,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(imageAssetPath),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text('Scan to Pay', textAlign: TextAlign.center),
        const SizedBox(height: 3),
        const Text(
          'or',
          style: TextStyle(color: Colors.blueGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        const Text(
          'Download QR',
          style: TextStyle(color: Colors.blue),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 1),
        const Text(
          'and upload to Mobile Banking app \nsupporting KHQR',
          style: TextStyle(color: Colors.blueGrey, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
