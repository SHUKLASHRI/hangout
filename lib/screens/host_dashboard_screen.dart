import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HostDashboardScreen extends StatelessWidget {
  final String id;
  const HostDashboardScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Attendance")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Verify who showed up to Strategy Night", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          _buildParticipantItem("Arjun", true),
          _buildParticipantItem("Sara", true),
          _buildParticipantItem("Kiran", false),
          _buildParticipantItem("Sneha", false),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Complete Hangout"),
        ),
      ),
    );
  }

  Widget _buildParticipantItem(String name, bool isPresent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: AppColors.primary, child: Text(name[0])),
          const SizedBox(width: 16),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
          Checkbox(
            value: isPresent,
            onChanged: (val) {},
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
