import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dynamic Background Blobs
          _buildAnimatedBlob(top: -100, left: -100, color: AppColors.primarySoft, delay: 0.ms),
          _buildAnimatedBlob(bottom: -150, right: -50, color: AppColors.secondary, delay: 1000.ms),
          _buildAnimatedBlob(top: 200, right: -120, color: AppColors.primary, delay: 2000.ms),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth > 500 ? 450 : constraints.maxWidth * 0.9;
                
                return Center(
                  child: SingleChildScrollView(
                    child: GlassContainer.clearGlass(
                      width: width,
                      height: 650,
                      borderRadius: BorderRadius.circular(32),
                      borderColor: AppColors.border,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.8),
                          Colors.white.withValues(alpha: 0.4),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(LucideIcons.heart, size: 64, color: AppColors.secondary)
                              .animate(onPlay: (controller) => controller.repeat(reverse: true))
                              .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2), curve: Curves.easeInOut),
                          const SizedBox(height: 32),
                          const Text(
                            "HANGOUT",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4, color: AppColors.primary),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(duration: 800.ms),
                          const SizedBox(height: 12),
                          const Text(
                            "Safe, Social, & Trustworthy",
                            style: TextStyle(color: AppColors.textSecondary, letterSpacing: 0.5),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(delay: 400.ms),
                          const SizedBox(height: 56),
                          
                          // Google Sign In (Full Width Premium)
                          ElevatedButton.icon(
                            icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                            label: const Text("CONTINUE WITH GOOGLE"),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.border),
                              elevation: 2,
                              minimumSize: const Size.fromHeight(60),
                            ),
                          ).animate().slideY(begin: 0.2, end: 0, delay: 600.ms).fadeIn(),
                          
                          const SizedBox(height: 32),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("OR USE PHONE", style: TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ).animate().fadeIn(delay: 800.ms),
                          const SizedBox(height: 32),

                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(LucideIcons.phone, size: 20),
                              hintText: "Phone Number",
                            ),
                          ).animate().fadeIn(delay: 1000.ms),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("SEND OTP"),
                          ).animate().fadeIn(delay: 1200.ms),
                          
                          const Spacer(),
                          const Text(
                            "By continuing, you agree to our Terms and Privacy Policy",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ).animate().fadeIn(delay: 1400.ms),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBlob({double? top, double? left, double? right, double? bottom, required Color color, required Duration delay}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.15),
        ),
      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
       .move(duration: 5.seconds, begin: const Offset(-20, -20), end: const Offset(20, 20), curve: Curves.easeInOut)
       .scale(duration: 8.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), curve: Curves.easeInOut)
       .fadeIn(delay: delay),
    );
  }
}
