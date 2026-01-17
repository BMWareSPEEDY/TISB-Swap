import 'package:flutter/material.dart';
import 'package:eco_tisb/utils/colors.dart';
import 'package:eco_tisb/utils/constants.dart';
import 'package:eco_tisb/widgets/custom_button.dart';

import 'package:eco_tisb/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    // Show login dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AuthDialog(
        isLogin: true,
        onAuth: (email, password, {fullName}) async {
          setState(() => _isLoading = true);
          try {
            await _supabaseService.signIn(email: email, password: password);
            if (!mounted) return;
             // ignore: use_build_context_synchronously
             Navigator.pop(context); // Close dialog
             // ignore: use_build_context_synchronously
             Navigator.pushReplacementNamed(context, '/marketplace');
          } on AuthException catch (e) {
            if (!mounted) return;
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message), backgroundColor: Colors.red),
            );
            // ignore: use_build_context_synchronously
            Navigator.pop(context); // Close dialog to retry
          } catch (e) {
            if (!mounted) return;
            String errorMessage = 'An unexpected error occurred';
            if (e.toString().contains('SocketException') || 
                e.toString().contains('Failed host lookup') ||
                e.toString().contains('No address associated with hostname')) {
              errorMessage = 'Network error: Cannot reach Supabase server.\n'
                  'Please check:\n'
                  '1. Your internet connection\n'
                  '2. Your Supabase project URL is correct\n'
                  '3. Your Supabase project exists and is active';
            } else if (e.toString().contains('ClientException')) {
              errorMessage = 'Connection error: ${e.toString().split('\n').first}';
            }
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          } finally {
            if (mounted) setState(() => _isLoading = false);
          }
        },
      ),
    );
  }

  Future<void> _handleSignUp() async {
    // Show sign up dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AuthDialog(
        isLogin: false,
        onAuth: (email, password, {fullName}) async {
          setState(() => _isLoading = true);
          try {
            final response = await _supabaseService.signUp(
              email: email, 
              password: password,
              startFullName: fullName ?? 'Student',
            );
            if (!mounted) return;
            
            // Check if email confirmation is required
            // According to Supabase docs: if session is null, email confirmation is needed
            if (response.session == null) {
              // ignore: use_build_context_synchronously
              Navigator.pop(context); // Close dialog
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account created! Please check your email to confirm your account, then login.'),
                  backgroundColor: AppColors.success,
                  duration: Duration(seconds: 5),
                ),
              );
            } else {
              // Session exists, user is automatically logged in
              // ignore: use_build_context_synchronously
              Navigator.pop(context); // Close dialog
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/marketplace');
            }
          } on AuthException catch (e) {
            if (!mounted) return;
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message), backgroundColor: Colors.red),
            );
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          } catch (e) {
            if (!mounted) return;
            String errorMessage = 'An unexpected error occurred';
            final errorStr = e.toString();
            
            if (errorStr.contains('SocketException') || 
                errorStr.contains('Failed host lookup') ||
                errorStr.contains('No address associated with hostname')) {
              errorMessage = 'Network error: Cannot reach Supabase server.\n'
                  'Please check:\n'
                  '1. Your internet connection\n'
                  '2. Your Supabase project URL is correct\n'
                  '3. Your Supabase project exists and is active';
            } else if (errorStr.contains('Database error') || 
                       errorStr.contains('database') ||
                       errorStr.contains('RLS') ||
                       errorStr.contains('policy')) {
              errorMessage = 'Database configuration error.\n'
                  'Please ensure:\n'
                  '1. RLS policies are set up on profiles table\n'
                  '2. Database trigger is created\n'
                  '3. Check Supabase dashboard for details\n\n'
                  'See database_setup.sql for setup instructions.';
            } else if (errorStr.contains('ClientException')) {
              errorMessage = 'Connection error: ${errorStr.split('\n').first}';
            } else if (errorStr.contains('User already registered') || 
                       errorStr.contains('already exists')) {
              errorMessage = 'This email is already registered. Please login instead.';
            } else {
              // Show the actual error message if it's helpful
              final lines = errorStr.split('\n');
              errorMessage = lines.isNotEmpty ? lines.first : 'Signup failed. Please try again.';
            }
            
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 6),
              ),
            );
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          } finally {
            if (mounted) setState(() => _isLoading = false);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.eco,
                      size: 40,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  const Text(
                    'TISB Swap',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Hero Image
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.eco, size: 14, color: Colors.black),
                                SizedBox(width: 4),
                                Text(
                                  'SUSTAINABILITY INITIATIVE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Tagline
                  const Text(
                    'Exchange your old\ntextbooks and uniforms.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  const Text(
                    'Save the planet, one swap at a time. Join the\ncommunity marketplace today.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Login Button
                  CustomButton(
                    text: 'Login with Email',
                    icon: Icons.login,
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 12),
                  
                  // Sign Up Button
                  CustomButton(
                    text: 'Create Account',
                    icon: Icons.person_add,
                    onPressed: _handleSignUp,
                    // Make it outlined or different style if possible, for now reuse custom button
                    // or add a secondary style to CustomButton
                  ),
                  const SizedBox(height: 8),
                  
                  // Security note
                  const Text(
                    'Secure access for students & faculty only',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Impact Counter
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.co2Green.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.eco,
                            color: AppColors.co2Green,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'LIVE IMPACT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.co2Green,
                                letterSpacing: 0.5,
                              ),
                            ),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${AppConstants.totalCO2Saved}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Kg',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'CO2 Saved by Students',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthDialog extends StatefulWidget {
  final bool isLogin;
  final Function(String email, String password, {String? fullName}) onAuth;

  const _AuthDialog({
    required this.isLogin,
    required this.onAuth,
  });

  @override
  State<_AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<_AuthDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isLogin ? 'Login' : 'Create Account'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.isLogin)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => (value?.length ?? 0) < 6 ? 'Min 6 chars' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAuth(
                _emailController.text,
                _passwordController.text,
                fullName: widget.isLogin ? null : _nameController.text,
              );
            }
          },
          child: Text(widget.isLogin ? 'Login' : 'Sign Up'),
        ),
      ],
    );
  }
}
