// The login screen - email/password + Google sign-in.
// Uses BlocConsumer to listen for errors and navigate on success.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers to read the text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Toggle password visibility
  bool _showPassword = false;

  @override
  void dispose() {
    // Always dispose controllers to free memory
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    // Validate all fields first
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onGooglePressed() {
    context.read<AuthBloc>().add(const LoginWithGoogleRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        // listener: called for one-time side effects (navigation, snackbars)
        listener: (context, state) {
          if (state is AuthError) {
            showErrorSnackbar(context, state.message);
          }
          // Navigation to home is handled in main.dart via AuthBloc state
        },
        // builder: rebuilds the UI when state changes
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // App logo and name
                    _buildLogo(),
                    const SizedBox(height: 60),

                    // Email field
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    CustomTextField(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      validator: Validators.validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    CustomButton(
                      text: 'Login',
                      onPressed: _onLoginPressed,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Google sign-in button
                    GoogleSignInButton(
                      onPressed: _onGooglePressed,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 24),

                    // Link to register screen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign-up',
                            style: TextStyle(
                              color: Color(0xFF4FC3F7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Sun icon as placeholder logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(Icons.wb_sunny, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 12),
        const Text(
          'Daylight',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4FC3F7),
          ),
        ),
      ],
    );
  }
}
