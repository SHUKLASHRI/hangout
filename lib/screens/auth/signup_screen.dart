import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/liquid_glass_card.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAgeConfirmed = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Blobs
          Positioned(top: -50, right: -50, child: _buildBlob(AppColors.trustBlue)),
          Positioned(bottom: -100, left: -100, child: _buildBlob(AppColors.vibrantOrange)),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "CREATE ACCOUNT",
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, letterSpacing: 2),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Join the trusted social network.",
                        style: TextStyle(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 48),

                      LiquidGlassCard(
                        padding: const EdgeInsets.all(24),
                        color: AppColors.trustBlue,
                        child: Column(
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(LucideIcons.user, size: 20),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: Icon(LucideIcons.mail, size: 20),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(LucideIcons.lock, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(_isPasswordVisible ? LucideIcons.eye : LucideIcons.eyeOff, size: 20),
                                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Age Confirmation
                            Row(
                              children: [
                                Checkbox(
                                  value: _isAgeConfirmed,
                                  onChanged: (val) => setState(() => _isAgeConfirmed = val ?? false),
                                  activeColor: AppColors.vibrantOrange,
                                ),
                                const Expanded(
                                  child: Text(
                                    "I confirm I am over 18 and agree to follow safety norms.",
                                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            ElevatedButton(
                              onPressed: (auth.isLoading || !_isAgeConfirmed) ? null : () {
                                // Will be integrated in Gen 19
                                context.go('/map');
                              },
                              child: auth.isLoading 
                                ? const CircularProgressIndicator(color: Colors.white) 
                                : const Text("SIGN UP"),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 32),

                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text("Already have an account? Sign In", style: TextStyle(color: AppColors.textSecondary)),
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

  Widget _buildBlob(Color color) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.1)),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(duration: 8.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), curve: Curves.easeInOut);
  }
}
