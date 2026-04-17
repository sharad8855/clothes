import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../providers/business_provider.dart';
import '../shell/main_shell.dart';

class BusinessStep2Screen extends StatefulWidget {
  const BusinessStep2Screen({super.key});

  @override
  State<BusinessStep2Screen> createState() => _BusinessStep2ScreenState();
}

class _BusinessStep2ScreenState extends State<BusinessStep2Screen> {
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<BusinessProvider>();
      provider.updateContactInfo(
        addr: _addressController.text,
        pin: _pincodeController.text,
        cty: _cityController.text,
        st: _stateController.text,
        ph: _phoneController.text,
        em: _emailController.text,
        fName: _fNameController.text,
        lName: _lNameController.text,
      );

      final success = await provider.createNewBusiness();
      if (success && mounted) {
        // Show success feedback before redirecting
        _showSuccessDialog();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Creation failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 80),
            const SizedBox(height: 24),
            Text(
              'ATELIER READY',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your digital workspace has been crafted successfully.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => MainShell()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1D2E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'ENTER WORKSPACE',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'IDENTITY',
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
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: CustomPaint(
                painter: _SimpleArchitecturalPainter(),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepperIndicator(),
                  const SizedBox(height: 40),
                  _buildSectionTitle('LOCATION & CONTACT'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'BUSINESS ADDRESS',
                    controller: _addressController,
                    hint: 'Studio street address',
                    icon: Icons.location_on_rounded,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'PINCODE',
                          controller: _pincodeController,
                          hint: '422611',
                          icon: Icons.local_post_office_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: 'CITY',
                          controller: _cityController,
                          hint: 'Sangamner',
                          icon: Icons.apartment_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'STATE',
                    controller: _stateController,
                    hint: 'Maharashtra',
                    icon: Icons.map_rounded,
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('CURATOR DETAILS'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'FIRST NAME',
                          controller: _fNameController,
                          hint: 'Owner First Name',
                          icon: Icons.person_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: 'LAST NAME',
                          controller: _lNameController,
                          hint: 'Owner Last Name',
                          icon: Icons.person_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'OFFICIAL PHONE',
                    controller: _phoneController,
                    hint: '9359775489',
                    icon: Icons.phone_android_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'OFFICIAL EMAIL',
                    controller: _emailController,
                    hint: 'sakshi@gmail.com',
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 60),
                  _buildSubmitButton(),
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
        _buildStepIndicator(1, 'BASICS', false, true),
        Expanded(child: Container(height: 1, color: AppColors.primary, margin: const EdgeInsets.symmetric(horizontal: 12))),
        _buildStepIndicator(2, 'IDENTITY', true, false),
      ],
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive, bool isDone) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive || isDone ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isDone ? AppColors.primary : const Color(0xFFE5E7EB),
              width: 2,
            ),
          ),
          child: Center(
            child: isDone 
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
              : Text(
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
            color: isActive || isDone ? AppColors.primary : const Color(0xFF9CA3AF),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF1A1D2E),
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B7280),
              letterSpacing: 1.0,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
          validator: validator,
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
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final isLoading = context.watch<BusinessProvider>().isLoading;
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
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1D2E),
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'FINALIZE ATELIER',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.verified_rounded, size: 18, color: Colors.white),
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
