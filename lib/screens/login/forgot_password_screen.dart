import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../providers/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // ─── Input Fields ──────────────────────────────────────────────

  Widget _buildStepPhone(ForgotPasswordProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('MOBILE NUMBER'),
        const SizedBox(height: 8),
        TextField(
          onChanged: provider.setPhone,
          keyboardType: TextInputType.phone,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your 10-digit mobile number',
            errorText: provider.phoneError,
            prefixIcon: const Icon(Icons.phone_android_rounded,
                color: AppColors.textSecondary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildStepOtp(ForgotPasswordProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('VERIFY OTP'),
            GestureDetector(
              onTap: provider.backToStart,
              child: Text(
                'Change Phone',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: provider.setOtp,
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            letterSpacing: 4,
          ),
          decoration: InputDecoration(
            hintText: 'Enter 6-digit OTP',
            hintStyle: GoogleFonts.inter(letterSpacing: 0),
            errorText: provider.otpError,
            prefixIcon: const Icon(Icons.password_rounded,
                color: AppColors.textSecondary, size: 20),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We sent a verification code to +91 ${provider.phone}',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textHint),
        ),
      ],
    );
  }

  Widget _buildStepReset(ForgotPasswordProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('NEW PASSWORD'),
        const SizedBox(height: 8),
        TextField(
          onChanged: provider.setNewPassword,
          obscureText: !provider.passwordVisible,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Enter new password',
            errorText: provider.newPasswordError,
            prefixIcon: const Icon(Icons.lock_outline_rounded,
                color: AppColors.textSecondary, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                provider.passwordVisible
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: provider.togglePasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildLabel('CONFIRM PASSWORD'),
        const SizedBox(height: 8),
        TextField(
          onChanged: provider.setConfirmPassword,
          obscureText: !provider.confirmPasswordVisible,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Re-enter new password',
            errorText: provider.confirmPasswordError,
            prefixIcon: const Icon(Icons.lock_reset_rounded,
                color: AppColors.textSecondary, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                provider.confirmPasswordVisible
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: provider.toggleConfirmPasswordVisibility,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  // ─── API Error Banner ─────────────────────────────────────────
  Widget _buildApiErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFB91C1C),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Submit Button ────────────────────────────────────────────
  Widget _buildSubmitButton(ForgotPasswordProvider provider) {
    String buttonText = 'Continue';
    if (provider.currentStep == ForgotPasswordStep.otp) {
      buttonText = 'Verify OTP';
    } else if (provider.currentStep == ForgotPasswordStep.reset) {
      buttonText = 'Reset Password';
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                
                await provider.submitField();
                
                if (provider.isSuccess && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  Navigator.pop(context); // Go back to login
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primaryLight.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: provider.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                buttonText,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Consumer<ForgotPasswordProvider>(
              builder: (context, provider, _) {
                
                // Dynamic header based on step
                String headerTitle = 'Reset Password';
                String headerSub = 'Enter your registered mobile number to receive an OTP.';
                
                if (provider.currentStep == ForgotPasswordStep.otp) {
                  headerTitle = 'Verify Check';
                  headerSub = 'Please enter the 6-digit OTP sent to your phone.';
                } else if (provider.currentStep == ForgotPasswordStep.reset) {
                  headerTitle = 'New Password';
                  headerSub = 'Please enter and confirm your new secure password.';
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Icon(
                      provider.currentStep == ForgotPasswordStep.otp
                          ? Icons.password_rounded
                          : Icons.lock_reset_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      headerTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      headerSub,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Card Form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (provider.currentStep == ForgotPasswordStep.phone)
                            _buildStepPhone(provider),
                            
                          if (provider.currentStep == ForgotPasswordStep.otp)
                            _buildStepOtp(provider),
                            
                          if (provider.currentStep == ForgotPasswordStep.reset)
                            _buildStepReset(provider),
                            
                          const SizedBox(height: 24),
                          if (provider.apiError != null) ...[
                            _buildApiErrorBanner(provider.apiError!),
                            const SizedBox(height: 16),
                          ],
                          _buildSubmitButton(provider),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
