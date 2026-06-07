import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../widgets/liquid_glass_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background - Stylized Map (Light theme)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.network(
                'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=2074&auto=format&fit=crop', 
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildMapPlaceholder(),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 4),
                  
                  // Central Logo Container
                  _buildLogo(),
                  
                  const SizedBox(height: 32),
                  
                  // HANGOUT Text
                  Text(
                    'HANGOUT',
                    style: GoogleFonts.outfit(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    'Your local social ecosystem',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF757575),
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate(delay: 200.ms).fadeIn(),
                  
                  const Spacer(flex: 3),
                  
                  // Login Options
                  _buildLoginButton(
                    icon: LucideIcons.mail,
                    label: 'Continue with Email',
                    onTap: () => context.go('/map'), // Direct to app for demo
                  ),
                  const SizedBox(height: 16),
                  _buildLoginButton(
                    icon: LucideIcons.smartphone,
                    label: 'Continue with Phone',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _buildLoginButton(
                    icon: LucideIcons.globe,
                    label: 'Continue with Web',
                    onTap: () {},
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Sign Up Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.inter(color: const Color(0xFF757575)),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/signup'),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            color: AppColors.vibrantOrange,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          LucideIcons.mapPin,
          color: AppColors.trustBlue,
          size: 56,
        ),
      ),
    ).animate().scale(
      duration: 1.seconds,
      curve: Curves.easeOutBack,
    ).shimmer(delay: 2.seconds, duration: 1.5.seconds);
  }

  Widget _buildLoginButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return LiquidGlassCard(
      borderRadius: BorderRadius.circular(40),
      opacity: 0.03,
      blur: 4,
      borderColor: Colors.black.withValues(alpha: 0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: const Color(0xFF1A1A1A)),
              const SizedBox(width: 20),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildMapPlaceholder() {
    return Container(
      color: const Color(0xFFF0F0F0),
      child: GridPaper(
        color: Colors.black.withValues(alpha: 0.02),
        divisions: 1,
        subdivisions: 1,
        interval: 100,
      ),
    );
  }
}
