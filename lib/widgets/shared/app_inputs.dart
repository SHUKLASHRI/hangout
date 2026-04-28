import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData? prefixIcon;
  final int maxLines;

  const AppTextField({
    super.key,
    this.controller,
    required this.hint,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(maxLines > 1 ? 24 : 40),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: const Color(0xFF98A2B3)),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: const Color(0xFF667085), size: 20) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class AppPickerField extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const AppPickerField({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF667085), size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.inter(
                color: const Color(0xFF101828),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
