import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMessage = null);

    try {
      await auth.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted && auth.isLoggedIn) {
        context.go('/map');
      }
    } catch (e) {
      setState(() => _errorMessage = _friendlyError(e.toString()));
    }
  }

  Future<void> _signInWithGoogle(AuthProvider auth) async {
    setState(() => _errorMessage = null);
    try {
      await auth.loginWithGoogle();
      if (mounted && auth.isLoggedIn) {
        context.go('/map');
      }
    } catch (e) {
      setState(() => _errorMessage = _friendlyError(e.toString()));
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('user-not-found')) return 'No account found with that email.';
    if (raw.contains('wrong-password')) return 'Incorrect password. Please try again.';
    if (raw.contains('invalid-email')) return 'Please enter a valid email address.';
    if (raw.contains('too-many-requests')) return 'Too many attempts. Please wait and try again.';
    if (raw.contains('network-request-failed')) return 'Network error. Check your connection.';
    return 'Sign in failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.trustBlue,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated background blobs — purely visual, no interaction needed
          Positioned(
            top: -120,
            left: -120,
            child: _buildBlob(AppColors.trustBlue.withValues(alpha: 0.5), 350),
          ),
          Positioned(
            bottom: -180,
            right: -80,
            child: _buildBlob(AppColors.socialOrange.withValues(alpha: 0.4), 400),
          ),
          Positioned(
            top: 100,
            right: -60,
            child: _buildBlob(AppColors.safetyGreen.withValues(alpha: 0.2), 250),
          ),

          // Full-screen white frosted background
          Positioned.fill(
            child: Container(color: AppColors.background.withValues(alpha: 0.1)),
          ),

          // Content — use SafeArea + scroll for robust layout
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      // Logo Area
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.handshake_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.08, 1.08), curve: Curves.easeInOut),

                      const SizedBox(height: 20),

                      Text(
                        'HANGOUT',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          letterSpacing: 6,
                          fontSize: 36,
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 6),

                      Text(
                        'Trust-first social coordination',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ).animate(delay: 200.ms).fadeIn(duration: 600.ms),

                      const SizedBox(height: 40),

                      // Glass Login Card — use ClipRRect + BackdropFilter (web-safe)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(28),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Welcome Back',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    'Sign in to find your people',
                                    style: TextStyle(color: Colors.white60, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 28),

                                  // Error Banner
                                  if (_errorMessage != null) ...[
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.error_outline, color: Colors.red, size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // Email field
                                  _glassTextField(
                                    controller: _emailController,
                                    label: 'Email Address',
                                    icon: LucideIcons.mail,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Email is required';
                                      if (!v.contains('@')) return 'Enter a valid email';
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 14),

                                  // Password field
                                  _glassTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    icon: LucideIcons.lock,
                                    obscureText: !_isPasswordVisible,
                                    suffix: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                                        size: 18,
                                        color: Colors.white60,
                                      ),
                                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Password is required';
                                      if (v.length < 6) return 'Password must be at least 6 characters';
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 28),

                                  // Sign In Button
                                  _buildPrimaryButton(
                                    label: 'SIGN IN',
                                    isLoading: auth.isLoading,
                                    color: AppColors.socialOrange,
                                    onPressed: () => _signIn(auth),
                                  ),

                                  const SizedBox(height: 16),

                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.white30)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text('OR', style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
                                      ),
                                      Expanded(child: Divider(color: Colors.white30)),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Google Sign-In
                                  _buildSecondaryButton(
                                    label: 'Continue with Google',
                                    icon: Icons.g_mobiledata_rounded,
                                    isLoading: auth.isLoading,
                                    onPressed: () => _signInWithGoogle(auth),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate(delay: 300.ms).fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0),

                      const SizedBox(height: 28),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ", style: TextStyle(color: Colors.white70)),
                          GestureDetector(
                            onTap: () => context.push('/signup'),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.socialOrange,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, size: 18, color: Colors.white60),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.socialOrange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.withValues(alpha: 0.7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required bool isLoading,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(icon, color: Colors.white70),
        label: Text(label, style: const TextStyle(color: Colors.white70)),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: Colors.white30),
        ),
      ),
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    )
    .animate(onPlay: (c) => c.repeat(reverse: true))
    .scale(duration: 8.seconds, begin: const Offset(0.85, 0.85), end: const Offset(1.15, 1.15), curve: Curves.easeInOut)
    .move(duration: 6.seconds, begin: const Offset(-30, -30), end: const Offset(30, 30), curve: Curves.easeInOut);
  }
}
