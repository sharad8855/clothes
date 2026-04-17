import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/session_manager.dart';
import '../../core/app_colors.dart';
import '../../providers/login_provider.dart';
import '../../utils/localization/localization_extension.dart';
import '../shell/main_shell.dart';
import '../home/hello_screen.dart';
import '../business/business_selection_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _credentialController = TextEditingController();
  final _passwordController = TextEditingController();
  final _credentialFocus = FocusNode();
  final _passwordFocus = FocusNode();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _credentialController.dispose();
    _passwordController.dispose();
    _credentialFocus.dispose();
    _passwordFocus.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(),
                const SizedBox(height: 36),
                _buildHeader(),
                const SizedBox(height: 28),
                _buildCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Logo ────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.checkroom_outlined,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'The Bespoke Atelier',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ─── Header ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.welcomeBack,
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.enterCredentials,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ─── Card ────────────────────────────────────────────────────
  Widget _buildCard() {
    return Container(
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
      padding: const EdgeInsets.all(24),
      child: Consumer<LoginProvider>(
        builder: (context, login, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCredentialField(login),
              const SizedBox(height: 20),
              if (login.authMode == AuthMode.password) ...[
                _buildPasswordField(login),
                const SizedBox(height: 16),
              ],
              _buildRememberForgotRow(login),
              const SizedBox(height: 24),
              // ─── API Error Banner ─────────────────────────────
              if (login.apiError != null) ...[
                _buildApiErrorBanner(login.apiError!),
                const SizedBox(height: 16),
              ],
              _buildSubmitButton(login),
              const SizedBox(height: 20),
              _buildSignUpRow(),
            ],
          );
        },
      ),
    );
  }

  // ─── Credential Field ─────────────────────────────────────────
  Widget _buildCredentialField(LoginProvider login) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MOBILE NUMBER',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _credentialController,
          focusNode: _credentialFocus,
          keyboardType: TextInputType.phone,
          onChanged: login.setCredential,
          decoration: InputDecoration(
            hintText: '+91 98765 43210',
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.textHint,
              size: 18,
            ),
            errorText: login.credentialError,
          ),
        ),
      ],
    );
  }

  // ─── Password Field ───────────────────────────────────────────
  Widget _buildPasswordField(LoginProvider login) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PASSWORD',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            GestureDetector(
              onTap: login.toggleAuthMode,
              child: Text(
                'Use OTP Instead?',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          obscureText: !login.passwordVisible,
          onChanged: login.setPassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textHint,
              size: 18,
            ),
            suffixIcon: GestureDetector(
              onTap: login.togglePasswordVisibility,
              child: Icon(
                login.passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textHint,
                size: 18,
              ),
            ),
            errorText: login.passwordError,
          ),
        ),
      ],
    );
  }

  // ─── Remember / Forgot ───────────────────────────────────────
  Widget _buildRememberForgotRow(LoginProvider login) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: login.rememberDevice,
            onChanged: (_) => login.toggleRememberDevice(),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Remember device',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            );
          },
          child: Text(
            'Forgot Password?',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Submit Button ────────────────────────────────────────────
  Widget _buildSubmitButton(LoginProvider login) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: login.isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                final success = await login.submit();
                if (!success || !context.mounted) return;

                final user = login.loggedInUser;
                Widget destination;

                if (user?.isBusinessStaff == true) {
                  // STAFF: Auto-select business and go to HelloScreen
                  final businessId = user?.firstBusinessId;
                  if (businessId != null) {
                    await SessionManager.instance.saveSelectedBusinessId(businessId);
                    destination = const HelloScreen();
                  } else {
                    // This case should ideally be handled by an error state
                    destination = const LoginScreen();
                  }
                } else {
                  // ADMIN: Go to selection/creation
                  destination = const BusinessSelectionScreen();
                }

                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (_, animation, _) => destination,
                    transitionsBuilder: (_, animation, _, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primaryLight.withValues(
            alpha: 0.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 0,
        ),
        child: login.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    login.authMode == AuthMode.password
                        ? 'Enter Atelier'
                        : 'Send OTP',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
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
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 18,
          ),
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

  // ─── Sign Up Row ──────────────────────────────────────────────
  Widget _buildSignUpRow() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'New to the management suite?  ',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to partner registration
                },
                child: Text(
                  'Join as a Partner',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
