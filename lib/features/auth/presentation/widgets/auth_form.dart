// lib/features/auth/presentation/widgets/auth_form.dart
// Reusable widgets shared across auth screens.
// Keeping these separate keeps screen files clean.

import 'package:flutter/material.dart';

/// A styled full-width button used throughout the app
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF3D3DBF),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text),
      ),
    );
  }
}

/// A styled text field used in forms
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// A Google sign-in button
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'G',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(color: Colors.white),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF2A2A5A)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

/// Shows a snackbar with an error message
void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

/// Shows a snackbar with a success message
void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
