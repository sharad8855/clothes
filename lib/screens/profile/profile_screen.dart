import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';

import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        final user = provider.userProfile;
        
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: provider.isLoading && user == null
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAppBar(context, provider),
                        _buildHeader(provider),
                        const SizedBox(height: 24),
                        _buildContactInfo(provider),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context, ProfileProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 20,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              provider.userProfile?.fullName ?? 'Profile',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Profile Header ──────────────────────────────────────────────────────

  Widget _buildHeader(ProfileProvider provider) {
    final user = provider.userProfile;
    final hasImage = user != null && user.profileImage != null && user.profileImage!.isNotEmpty;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.inputBg,
              image: hasImage ? DecorationImage(
                image: NetworkImage(user.profileImage!),
                fit: BoxFit.cover,
              ) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  user?.fullName ?? 'Loading...',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.verified_rounded,
                size: 16,
                color: Color(0xFF7C3AED),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 11,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Status: ${user?.status ?? 'Active'}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Contact Info ────────────────────────────────────────────────────────

  Widget _buildContactInfo(ProfileProvider provider) {
    final user = provider.userProfile;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.contact_mail_rounded,
                  size: 14,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 8),
                Text(
                  'Contact Information',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ContactRow(
              icon: Icons.phone_rounded,
              label: 'PHONE',
              value: user?.phone ?? 'N/A',
            ),
            const SizedBox(height: 16),
            _ContactRow(
              icon: Icons.email_rounded,
              label: 'EMAIL',
              value: user?.email ?? 'N/A',
            ),
          ],
        ),
      ),
    );
  }

}

// ─── Sub Widgets ──────────────────────────────────────────────────────────

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.inputBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: AppColors.primaryDark),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.textHint,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

