import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../providers/business_provider.dart';
import 'business_creation_step2.dart';

class BusinessStep1Screen extends StatefulWidget {
  const BusinessStep1Screen({super.key});

  @override
  State<BusinessStep1Screen> createState() => _BusinessStep1ScreenState();
}

class _BusinessStep1ScreenState extends State<BusinessStep1Screen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _startController = TextEditingController(text: '09:00:00');
  final _endController = TextEditingController(text: '18:00:00');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      context.read<BusinessProvider>().updateBasicInfo(
            name: _nameController.text,
            desc: _descController.text,
            start: _startController.text,
            end: _endController.text,
          );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BusinessStep2Screen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'FOUNDATION',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 2.0,
            color: const Color(0xFF1A1D2E),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1A1D2E),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Architectural background lines (subtle)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: CustomPaint(
                painter: _SimpleArchitecturalPainter(),
              ),
            ),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepperIndicator(),
                  const SizedBox(height: 48),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  
                  _buildLabel('ATELIER NAME'),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'e.g. Signature Stitches',
                    icon: Icons.auto_awesome_rounded,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildLabel('MISSION / DESCRIPTION'),
                  _buildTextField(
                    controller: _descController,
                    hint: 'Briefly describe your craft...',
                    maxLines: 3,
                    icon: Icons.edit_note_rounded,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('OPEN FROM'),
                            _buildTextField(
                              controller: _startController,
                              hint: '09:00:00',
                              icon: Icons.login_rounded,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('CLOSE AT'),
                            _buildTextField(
                              controller: _endController,
                              hint: '18:00:00',
                              icon: Icons.logout_rounded,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  _buildNextButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperIndicator() {
    return Row(
      children: [
        _buildStepIndicator(1, 'BASICS', true),
        Expanded(child: Container(height: 1, color: AppColors.primary, margin: const EdgeInsets.symmetric(horizontal: 12))),
        _buildStepIndicator(2, 'IDENTITY', false),
      ],
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
              width: 2,
            ),
            boxShadow: isActive ? [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Center(
            child: Text(
              '$step',
              style: GoogleFonts.inter(
                color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: isActive ? AppColors.primary : const Color(0xFF9CA3AF),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Register your\nBespoke Studio.',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A1D2E),
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Let\'s establish the foundation of your digital workspace.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF6B7280),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1A1D2E)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1D2E),
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CONTINUE TO IDENTITY',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleArchitecturalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
