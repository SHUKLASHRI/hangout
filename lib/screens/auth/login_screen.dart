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
          // Subtle background decoration (Soft Blue blur)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySoft.withValues(alpha: 0.2),
              ),
            ),
          ).animate().fadeIn(duration: 1.seconds).scale(),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth > 500 ? 450 : constraints.maxWidth * 0.9;
                
                return Center(
                  child: SingleChildScrollView(
                    child: GlassContainer.clearGlass(
                      width: width,
                      height: 600,
                      borderRadius: BorderRadius.circular(24),
                      borderColor: AppColors.border,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Icon(LucideIcons.heart, size: 56, color: AppColors.secondary)
                              .animate()
                              .fade(duration: 500.ms)
                              .scale(delay: 200.ms),
                          const SizedBox(height: 24),
                          Text(
                            "Welcome to HANGOUT",
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn(),
                          const SizedBox(height: 8),
                          const Text(
                            "Join nearby meetups and meet new people securely.",
                            style: TextStyle(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(delay: 300.ms),
                          const SizedBox(height: 48),
                          
                          // Google Sign In (LinkedIn-style Reliability)
                          ElevatedButton.icon(
                            icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                            label: const Text("Continue with Google"),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.border),
                              elevation: 1,
                            ),
                          ).animate().slideX(begin: -0.1, delay: 500.ms).fadeIn(),
                          
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("OR", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 24),

                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(LucideIcons.phone, size: 20),
                              hintText: "Phone Number",
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Send OTP"),
                          ),
                          
                          const Spacer(),
                          const Text(
                            "By continuing, you agree to our Terms and Privacy Policy",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
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
}
