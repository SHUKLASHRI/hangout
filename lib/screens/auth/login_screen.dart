import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dynamic Background (Lead Color Navy)
          Positioned(
            top: -100,
            left: -100,
            child: _buildBlob(AppColors.trustBlue),
          ),
          Positioned(
            bottom: -150,
            right: -50,
            child: _buildBlob(AppColors.socialOrange),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      const Icon(Icons.handshake_rounded, size: 64, color: AppColors.trustBlue)
                        .animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1), curve: Curves.easeInOut),
                      
                      const SizedBox(height: 24),
                      Text(
                        "WELCOME BACK",
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, letterSpacing: 2),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Trust-based social coordination awaits.",
                        style: TextStyle(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 48),

                      // Login Card
                      GlassCard(
                        padding: const EdgeInsets.all(24),
                        tintColor: AppColors.trustBlue,
                        child: Column(
                          children: [
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
                            ElevatedButton(
                              onPressed: auth.isLoading ? null : () async {
                                // For MVP: Auto-redirect to onboarding if successful
                                // Real logic would involve auth.signInWithEmail
                                context.go('/onboarding');
                              },
                              child: auth.isLoading 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                                : const Text("SIGN IN"),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 32),

                      // Social Login
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text("OR CONTINUE WITH", style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      
                      const SizedBox(height: 32),

                      OutlinedButton.icon(
                        onPressed: auth.isLoading ? null : () async {
                          await auth.loginWithGoogle();
                          if (mounted && auth.isLoggedIn) {
                            context.go('/map');
                          }
                        },
                        icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                        label: const Text("GOOGLE ACCOUNT"),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Color(0x33000000)),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Navigation to Signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?", style: TextStyle(color: AppColors.textSecondary)),
                          TextButton(
                            onPressed: () => context.push('/signup'),
                            child: const Text("Create Account", style: TextStyle(color: AppColors.socialOrange, fontWeight: FontWeight.bold)),
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

  Widget _buildBlob(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(duration: 8.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), curve: Curves.easeInOut)
     .move(duration: 6.seconds, begin: const Offset(-20, -20), end: const Offset(20, 20), curve: Curves.easeInOut);
  }
}
