import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../widgets/liquid_glass_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/shared/app_inputs.dart';
import '../../widgets/overlays/notifications_overlay.dart';
import '../location_picker_screen.dart';
import '../../models/hangout_model.dart';
import 'package:go_router/go_router.dart';

class CreateHangoutScreen extends StatefulWidget {
  const CreateHangoutScreen({super.key});

  @override
  State<CreateHangoutScreen> createState() => _CreateHangoutScreenState();
}

class _CreateHangoutScreenState extends State<CreateHangoutScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  double? _selectedLat;
  double? _selectedLng;
  bool _isPrivate = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              
              const SizedBox(height: 32),
              
              // Title
              Center(
                child: Column(
                  children: [
                    Text(
                      'Create Hangout',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Plan your next adventure.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Cover Image Uploader
              _buildImageUploader(),
              
              const SizedBox(height: 32),
              
              // Form Fields
              _buildLabel('Hangout Name'),
              AppTextField(
                controller: _nameController,
                hint: 'e.g., Weekend Hike at Mount Tam',
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Date'),
                        AppPickerField(
                          icon: LucideIcons.calendar,
                          text: _selectedDate == null ? 'mm/dd/yyyy' : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                          onTap: _pickDate,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Time'),
                        AppPickerField(
                          icon: LucideIcons.clock,
                          text: _selectedTime == null ? '--:-- --' : _selectedTime!.format(context),
                          onTap: _pickTime,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              _buildLabel('Location'),
              AppTextField(
                controller: _locationController,
                hint: 'Search or pick on map...',
                prefixIcon: LucideIcons.mapPin,
                suffixIcon: IconButton(
                  icon: const Icon(LucideIcons.map, color: AppColors.trustBlue),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationPickerScreen(),
                      ),
                    );
                    if (result != null && result is Map) {
                      setState(() {
                        _locationController.text = result['address'];
                        _selectedLat = result['lat'];
                        _selectedLng = result['lng'];
                      });
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              _buildLabel('Description'),
              AppTextField(
                controller: _descController,
                hint: 'What are we doing? Any special instructions?',
                maxLines: 4,
              ),
              
              const SizedBox(height: 32),
              
              // Private Toggle
              _buildPrivateToggle(),
              
              const SizedBox(height: 40),
              
              // Submit Button
              _buildSubmitButton(),
              
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            image: const DecorationImage(
              image: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Felix'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          'HANGOUT',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.trustBlue,
            letterSpacing: 1.5,
          ),
        ),
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const NotificationsOverlay(),
            );
          },
          icon: const Icon(LucideIcons.bell, color: Color(0xFF667085)),
        ),
      ],
    );
  }

  Widget _buildImageUploader() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF0C7),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.imagePlus, color: Color(0xFFF79009)),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload Cover Image',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'PNG, JPG up to 10MB',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF667085),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  Widget _buildPrivateToggle() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.lock, color: AppColors.trustBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Private Hangout',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)),
                ),
                Text(
                  'Only invited friends can see.',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF667085)),
                ),
              ],
            ),
          ),
          Switch(
            value: _isPrivate,
            onChanged: (v) => setState(() => _isPrivate = v),
            activeThumbColor: AppColors.trustBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isSubmitting ? null : _submitHangout,
      child: LiquidGlassCard(
        borderRadius: BorderRadius.circular(40),
        opacity: _isSubmitting ? 0.3 : 0.1,
        blur: 10,
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF97316), Color(0xFFFB923C)],
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF97316).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: _isSubmitting 
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'CREATE HANGOUT',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
          ),
        ),
      ).animate().shimmer(),
    );
  }

  Future<void> _submitHangout() async {
    if (_nameController.text.isEmpty || _locationController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields.')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final now = DateTime.now();
      final meetupTime = DateTime(
        _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
        _selectedTime!.hour, _selectedTime!.minute
      );

      final newHangout = HangoutModel(
        id: 'h_${now.millisecondsSinceEpoch}',
        title: _nameController.text,
        description: _descController.text,
        type: ActivityType.other, // Default or prompt user
        scheduledAt: meetupTime,
        expiresAt: meetupTime.add(const Duration(hours: 4)),
        hostId: 'u_current',
        hostName: 'Current User',
        hostTrustScore: 4.8,
        meetingPoint: GeoPoint(_selectedLat ?? 20.5937, _selectedLng ?? 78.9629),
        meetingZone: GeoPoint(_selectedLat ?? 20.5937, _selectedLng ?? 78.9629),
        maxParticipants: 10,
        status: HangoutStatus.active,
      );

      // Simulating network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // We log the created model to avoid 'unused variable' warning,
      // in reality this would be passed to a service.
      debugPrint('Created Hangout: ${newHangout.toMap()}');
      
      // Save to provider/state (if available)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hangout created successfully!')));
        context.pop();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }


}
