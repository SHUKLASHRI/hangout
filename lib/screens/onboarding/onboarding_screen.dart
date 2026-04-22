import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../widgets/glass_card.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form Data
  final _nameController = TextEditingController();
  String _selectedCampus = 'Main Campus';
  final List<String> _selectedInterests = [];
  
  final List<String> _interestOptions = [
    'Food', 'Sports', 'Study', 'Music', 'Gaming', 
    'Outdoors', 'Movies', 'Travel', 'Art', 'Tech', 'Fitness', 'Other'
  ];

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final auth = context.read<AuthProvider>();
    final firestore = context.read<FirestoreService>();

    if (auth.userModel == null) return;

    final updatedUser = auth.userModel!.copyWith(
      displayName: _nameController.text.isEmpty ? auth.userModel!.displayName : _nameController.text,
      onboardingCompleted: true,
      interests: _selectedInterests,
    );

    await firestore.createUser(updatedUser);
    
    if (mounted) {
      context.go('/map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) => setState(() => _currentPage = page),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildStep4(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.socialOrange : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("WHO ARE YOU?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 48),
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.surfaceElevated,
            child: Icon(Icons.camera_alt_rounded, color: AppColors.textSecondary, size: 32),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: "Enter your display name",
              border: UnderlineInputBorder(),
            ),
          ),
        ],
      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("YOUR HUB", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 12),
          const Text("Where do you usually hang out?", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 48),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ['Main Campus', 'East Wing', 'Library Area', 'Tech Park', 'Downtown'].map((campus) {
              final isSelected = _selectedCampus == campus;
              return ChoiceChip(
                label: Text(campus),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedCampus = campus),
                selectedColor: AppColors.trustBlue,
                labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              );
            }).toList(),
          ),
        ],
      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("INTERESTS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 12),
          const Text("Pick at least 3 things you love.", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _interestOptions.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    if (val) _selectedInterests.add(interest);
                    else _selectedInterests.remove(interest);
                  });
                },
                selectedColor: AppColors.socialOrange.withValues(alpha: 0.2),
                checkmarkColor: AppColors.socialOrange,
              );
            }).toList(),
          ),
        ],
      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_rounded, color: AppColors.safetyGreen, size: 64),
          const SizedBox(height: 24),
          const Text("SAFETY FIRST", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 32),
          GlassCard(
            padding: const EdgeInsets.all(16),
            tintColor: AppColors.safetyGreen,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: const SingleChildScrollView(
                child: Text(
                  "1. Be respectful to all members.\n"
                  "2. Meet only in public places.\n"
                  "3. Verify trust scores before joining.\n"
                  "4. Report any suspicious activity immediately.\n"
                  "5. Stay true to the HANGOUT mission: Real connections, zero pressure.",
                  style: TextStyle(height: 1.6),
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () => _pageController.previousPage(duration: 400.ms, curve: Curves.ease),
              child: const Text("BACK", style: TextStyle(color: AppColors.textSecondary)),
            )
          else
            const SizedBox.shrink(),
          
          ElevatedButton(
            onPressed: (_currentPage == 2 && _selectedInterests.length < 3) ? null : _nextPage,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 56),
            ),
            child: Text(_currentPage == 3 ? "JOIN HANGOUT" : "NEXT"),
          ),
        ],
      ),
    );
  }
}
