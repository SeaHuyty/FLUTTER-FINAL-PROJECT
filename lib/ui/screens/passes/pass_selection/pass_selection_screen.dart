import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse_redesign/data/repositories/passes/pass_repository.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_selection/widgets/pass_selection_content.dart';
import 'package:velo_toulouse_redesign/ui/screens/passes/pass_selection/view_model/pass_selection_view_model.dart';

class PassSelectionScreen extends StatelessWidget {
  const PassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PassSelectionViewModel(context.read<PassRepository>()),
      child: const PassSelectionContent(),
    );
  }
}
