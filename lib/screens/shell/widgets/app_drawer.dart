import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/session_manager.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../utils/localization/localization_extension.dart';
import '../../analytics/analytics_screen.dart';
import '../../login/login_screen.dart';
import '../../orders/order_history_screen.dart';
import '../../profile/profile_screen.dart';
import '../../../providers/profile_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<HomeProvider>().selectedNavIndex;

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.bespokeAtelier,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E3A8A), // Deep blue
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Profile Card Block
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<ProfileProvider>(
                builder: (context, provider, child) {
                  final user = provider.userProfile;
                  final hasImage = user != null && user.profileImage != null && user.profileImage!.isNotEmpty;
                  
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close Drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE2E8F0),
                              image: hasImage ? DecorationImage(
                                image: NetworkImage(user!.profileImage!),
                                fit: BoxFit.cover,
                              ) : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullName ?? 'Loading...',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1E3A8A),
                                    letterSpacing: -0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user?.email ?? '---',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user?.status.toUpperCase() ?? 'PREMIUM TIER',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF8B5CF6),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(height: 32),

            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.dashboard_rounded,
                    title:context.dashboard,
                    isSelected: currentIndex == 0,
                    onTap: () => _handleRoute(context, 0),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.history_rounded,
                    title: 'Order History',
                    isSelected: false, // Push overlay, not a tab
                    onTap: () => _handleRoute(context, 1),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.people_rounded,
                    title: 'Customers',
                    isSelected: currentIndex == 2,
                    onTap: () => _handleRoute(context, 2),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.assignment_ind_rounded,
                    title: 'Staff',
                    isSelected: currentIndex == 3,
                    onTap: () => _handleRoute(context, 3),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.photo_library_rounded,
                    title: 'Gallery',
                    isSelected: currentIndex == 4,
                    onTap: () => _handleRoute(context, 4),
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.analytics_rounded,
                    title: 'Analytics',
                    isSelected: false,
                    onTap: () => _handleRoute(context, 5),
                  ),
                ],
              ),
            ),

            // Language Selection
            _buildLanguageSelector(context),

            // Logout Footer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: const Color(0xFFE2E8F0), height: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
                title: Text(
                  'Logout',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                onTap: () => _handleLogout(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    await SessionManager.instance.clearSession();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Remove all previous routes
      );
    }
  }

  void _handleRoute(BuildContext context, int index) {
    // Pop the drawer immediately for smooth UX
    Navigator.of(context).pop();
    
    // Purge any active overlaid screens (Analytics, History) before routing
    Navigator.popUntil(context, (route) => route.isFirst);
    
    // Explicit exception strategy just for standalone modal injections
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
      );
    } else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
      );
    } else {
      // Normal tabs update the Global Stack State natively
      context.read<HomeProvider>().setNavIndex(index);
    }
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF475569),
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.translate_rounded,
                      color: Color(0xFF1E3A8A),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Language',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E3A8A),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E3A8A).withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: langProvider.currentLanguageCode,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF64748B),
                        size: 22,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: Colors.white,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                      items: LanguageProvider.supportedLanguages.map((lang) {
                        return DropdownMenuItem<String>(
                          value: lang.code,
                          child: Row(
                            children: [
                              Text(
                                _getFlagEmoji(lang.code),
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                lang.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${lang.nativeName})',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (code) {
                        if (code != null) {
                          langProvider.setLanguage(code);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getFlagEmoji(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'hi':
        return '🇮🇳';
      case 'mr':
        return '🇮🇳';
      default:
        return '🌐';
    }
  }
}
