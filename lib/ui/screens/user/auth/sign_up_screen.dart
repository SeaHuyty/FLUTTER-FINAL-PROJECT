import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velo_toulouse_redesign/core/theme/theme.dart';
import 'package:velo_toulouse_redesign/models/user_model.dart';
import 'package:velo_toulouse_redesign/ui/screens/user/viewmodels/user_viewmodel.dart';
import 'package:velo_toulouse_redesign/ui/screens/main_screen.dart';
import 'package:velo_toulouse_redesign/ui/shared/display/top_bar/app_bar.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedGender;

  static const _genders = ['Male', 'Female'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(userViewModelProvider.notifier);
    final uid = await notifier.signUp(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    if (uid == null) return;

    await notifier.createUserProfile(
      UserModel(
        id: uid,
        name: _nameController.text.trim(),
        gender: _selectedGender!,
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        imageUrl: '',
      ),
    );

    if (!mounted) return;

    final state = ref.read(userViewModelProvider);
    if (state.hasError) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userViewModelProvider).isLoading;

    ref.listen(userViewModelProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) {
          final message =
              (e is FirebaseAuthException && e.code == 'email-already-in-use')
              ? 'This email is already registered. Please login instead.'
              : e.toString();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: StationAppBar(
        title: 'Create New Account',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField(
                  label: 'Name',
                  controller: _nameController,
                  icon: Icons.person_outline,
                  hint: 'Username',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  hint: 'Phone number',
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Phone number is required'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: 'Email Address',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  hint: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email address is required';
                    }
                    if (!v.contains('@')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Password',
                  controller: _passwordController,
                  hint: 'Password',
                  obscure: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  hint: 'Confirm password',
                  obscure: _obscureConfirmPassword,
                  onToggle: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (v != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildLabel('Gender'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.wc_outlined),
                    hintText: 'Select your gender',
                    border: OutlineInputBorder(),
                  ),
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGender = v),
                  validator: (v) => v == null ? 'Gender is required' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Register'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: label),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: hint,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggle,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
