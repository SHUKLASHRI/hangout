import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/liquid_glass_card.dart';

class HostDashboardScreen extends StatelessWidget {
  final String id;
  const HostDashboardScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Manage Attendance"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Verify who showed up to Strategy Night",
            style: TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildParticipantItem("Arjun", true),
          _buildParticipantItem("Sara", true),
          _buildParticipantItem("Kiran", false),
          _buildParticipantItem("Sneha", false),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.safetyGreen,
          ),
          child: const Text("COMPLETE HANGOUT"),
        ),
      ),
    );
  }

  Widget _buildParticipantItem(String name, bool isPresent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LiquidGlassCard(
        padding: const EdgeInsets.all(16),
        color: isPresent ? AppColors.safetyGreen : AppColors.trustBlue,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isPresent ? AppColors.safetyGreen.withValues(alpha: 0.2) : AppColors.trustBlue.withValues(alpha: 0.2),
              child: Text(name[0], style: TextStyle(color: isPresent ? AppColors.safetyGreen : AppColors.trustBlue, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
            Checkbox(
              value: isPresent,
              onChanged: (val) {},
              activeColor: AppColors.safetyGreen,
            ),
          ],
        ),
      ),
    );
  }
}
