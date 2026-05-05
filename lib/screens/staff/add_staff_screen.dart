import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../utils/localization/localization_extension.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  
  bool _isLoading = false;
  String? _phoneError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhone);
    _emailController.removeListener(_validateEmail);
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    final digits = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    setState(() {
      if (digits.isNotEmpty && digits.length != 10) {
        _phoneError = context.phoneMustBe10Digits;
      } else {
        _phoneError = null;
      }
    });
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      if (email.isNotEmpty && !RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
        _emailError = context.pleaseEnterValidEmail;
      } else {
        _emailError = null;
      }
    });
  }

  Future<void> _handleSaveStaff() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final jobTitle = _jobTitleController.text.trim();

    if (name.isEmpty || phone.isEmpty || jobTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.pleaseFillRequiredFields)),
      );
      return;
    }

    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 10) {
      setState(() => _phoneError = context.phoneMustBe10Digits);
      return;
    }

    if (email.isNotEmpty && !RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      setState(() => _emailError = context.pleaseEnterValidEmail);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.inviteStaff(
        name: name,
        phone: phone,
        email: email,
        jobTitle: jobTitle,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.staffInvitedSuccessfully)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Cool Grey background
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 140), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoCard(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActions(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF3F4F6),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827), size: 24),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        context.addStaffTitle,
        style: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.badge_rounded, size: 24, color: Color(0xFF111827)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  context.basicInformation,
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildTextFieldLabel(context.fullNameRequired),
          _buildCustomTextField(context.egJohnDoe, controller: _nameController, icon: Icons.person_outline_rounded),
          const SizedBox(height: 24),
          _buildTextFieldLabel(context.phoneNumberRequired),
          _buildCustomTextField(
            '',
            controller: _phoneController,
            keyboardType: TextInputType.number,
            icon: Icons.phone_outlined,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            errorText: _phoneError,
          ),
          const SizedBox(height: 24),
          _buildTextFieldLabel(context.emailOptional),
          _buildCustomTextField(
            '',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            icon: Icons.email_outlined,
            errorText: _emailError,
          ),
          const SizedBox(height: 24),
          _buildTextFieldLabel(context.designationRequired),
          _buildCustomTextField(context.egSeniorStylist, controller: _jobTitleController, icon: Icons.work_outline_rounded),
        ],
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF6B7280),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCustomTextField(String hint, {
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB), // Very light grey
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText != null ? const Color(0xFFEF4444) : const Color(0xFFE5E7EB), 
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              errorText,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: Text(
                context.cancelButton,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4B5563),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSaveStaff,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading 
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                  : Text(
                      context.inviteStaff,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
