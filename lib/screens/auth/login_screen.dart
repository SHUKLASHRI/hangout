import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return LiquidGlassView(
            backgroundWidget: Stack(
              children: [
                // Dynamic Background Blobs
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
              ],
            ),
            children: [
              // True Liquid Glass Login Panel
              LiquidGlass(
                width: 400,
                height: 520,
                position: LiquidGlassAlignPosition(alignment: Alignment.center),
                magnification: 1.1,
                distortion: 0.15,
                chromaticAberration: 0.005,
                shape: const RoundedRectangleShape(cornerRadius: 32),
                color: Colors.white.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
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
                      const SizedBox(height: 48),

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
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: auth.isLoading ? null : () async {
                          context.go('/onboarding');
                        },
                        child: auth.isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                          : const Text("SIGN IN"),
                      ),
                      const SizedBox(height: 24),
                      // Navigation to Signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("New here?", style: TextStyle(color: AppColors.textSecondary)),
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
            ],
          );
        },
      ),
    );
  }

  Widget _buildBlob(Color color) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(duration: 8.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), curve: Curves.easeInOut)
     .move(duration: 6.seconds, begin: const Offset(-40, -40), end: const Offset(40, 40), curve: Curves.easeInOut);
  }
}
