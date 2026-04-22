import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../models/hangout_model.dart';
import '../../core/theme.dart';
import '../../core/error_handler.dart';
import '../../widgets/glass_card.dart';
import '../map/map_picker_screen.dart';

class CreateHangoutScreen extends StatefulWidget {
  const CreateHangoutScreen({super.key});

  @override
  State<CreateHangoutScreen> createState() => _CreateHangoutScreenState();
}

class _CreateHangoutScreenState extends State<CreateHangoutScreen> {
  final _titleController = TextEditingController();
  ActivityType _selectedType = ActivityType.food;
  DateTime _selectedTime = DateTime.now().add(const Duration(hours: 1));
  int _maxParticipants = 4;
  GeoPoint? _meetingPoint;

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_titleController.text.isEmpty || _meetingPoint == null) {
      ErrorHandler.showError(context, "Please fill in all required fields and select a location.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // In a real app, we'd use M2-B1 hangout_service.createHangout
      // For now, we simulate success
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ErrorHandler.showSuccess(context, "Hangout posted successfully!");
        context.go('/map');
      }
    } catch (e) {
      if (mounted) ErrorHandler.showError(context, "Failed to post hangout: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Host a Hangout"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              padding: const EdgeInsets.all(24),
              tintColor: AppColors.trustBlue, // Trust tint for form inputs
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "What's the plan?",
                      hintText: "e.g., Casual Coffee at Starbucks",
                      prefixIcon: Icon(LucideIcons.pencil, size: 20),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Activity Type"),
                  const SizedBox(height: 12),
                  _buildTypeSelector(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Group Size"),
                  _buildSizeStepper(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GlassCard(
              padding: const EdgeInsets.all(24),
              tintColor: AppColors.socialOrange, // Social tint for location/time
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(LucideIcons.mapPin, color: AppColors.socialOrange),
                    title: const Text("Meeting Point"),
                    subtitle: Text(_meetingPoint == null ? "Not selected" : "Location set ✓"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.push<GeoPoint>(
                        context,
                        MaterialPageRoute(builder: (context) => const MapPickerScreen()),
                      );
                      if (result != null) setState(() => _meetingPoint = result);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(LucideIcons.calendar, color: AppColors.socialOrange),
                    title: const Text("Scheduled Time"),
                    subtitle: Text("${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        setState(() {
                          final now = DateTime.now();
                          _selectedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.socialOrange,
                minimumSize: const Size.fromHeight(64),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text("POST HANGOUT", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      children: ActivityType.values.map((type) {
        final isSelected = _selectedType == type;
        return ChoiceChip(
          label: Text(type.name),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedType = type),
          selectedColor: AppColors.socialOrange,
          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
        );
      }).toList(),
    );
  }

  Widget _buildSizeStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _maxParticipants > 2 ? () => setState(() => _maxParticipants--) : null,
          icon: const Icon(LucideIcons.minus),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text("$_maxParticipants People", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        IconButton(
          onPressed: _maxParticipants < 10 ? () => setState(() => _maxParticipants++) : null,
          icon: const Icon(LucideIcons.plus),
        ),
      ],
    );
  }
}
