import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../providers/business_provider.dart';
import '../shell/main_shell.dart';
import 'business_creation_step1.dart';

class BusinessSelectionScreen extends StatefulWidget {
  const BusinessSelectionScreen({super.key});

  @override
  State<BusinessSelectionScreen> createState() => _BusinessSelectionScreenState();
}

class _BusinessSelectionScreenState extends State<BusinessSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessProvider>().fetchUserBusinesses();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onBusinessSelected(dynamic business) async {
    await context.read<BusinessProvider>().handleSelectBusiness(business);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Matching Splash background
      body: Stack(
        children: [
          // Background architectural lines
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: CustomPaint(
                painter: _ArchitecturalPatternPainter(),
              ),
            ),
          ),
          
          SafeArea(
            child: Consumer<BusinessProvider>(
              builder: (context, provider, _) {
                return RefreshIndicator(
                  onRefresh: () => provider.fetchUserBusinesses(),
                  color: AppColors.primary,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _buildAppBar(provider),
                      if (provider.isLoading && provider.businesses.isEmpty)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (provider.businesses.isEmpty)
                        _buildEmptyStateSliver()
                      else
                        _buildBusinessListSliver(provider),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildAppBar(BusinessProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY ATELIERS',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: const Color(0xFF1A1D2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                _buildSyncIcon(provider),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Choose your workspace to continue the craft.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncIcon(BusinessProvider provider) {
    return InkWell(
      onTap: provider.isLoading ? null : () => provider.fetchUserBusinesses(),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.sync_rounded,
          size: 20,
          color: provider.isLoading ? Colors.grey : AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildBusinessListSliver(BusinessProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final business = provider.businesses[index];
            final isSelected = provider.selectedBusiness?.id == business.id;
            
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final delay = (index * 0.1).clamp(0.0, 1.0);
                final animationValue = Curves.easeOutCubic.transform(
                  (_animationController.value - delay).clamp(0.0, 1.0),
                );
                
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - animationValue)),
                  child: Opacity(
                    opacity: animationValue,
                    child: _buildBusinessCard(business, isSelected),
                  ),
                );
              },
            );
          },
          childCount: provider.businesses.length,
        ),
      ),
    );
  }

  Widget _buildBusinessCard(dynamic business, bool isSelected) {
    return GestureDetector(
      onTap: () => _onBusinessSelected(business),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A1D2E).withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Subtle background accent
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.03,
                  child: Icon(Icons.storefront_rounded, size: 120, color: AppColors.primary),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.business_center_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            business.name.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A1D2E),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                (business.contactInfo?.city ?? 'New Delhi').toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 28)
                    else
                      const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFE5E7EB), size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateSliver() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: const Icon(Icons.architecture_rounded, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 40),
            Text(
              'BEGIN YOUR CRAFT',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1A1D2E),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No workspaces found. Create your first digital atelier to start managing your bespoke patterns and orders.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BusinessStep1Screen()),
        );
      },
      backgroundColor: const Color(0xFF1A1D2E), // Premium Contrast
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: Text(
        'NEW ATELIER',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          fontSize: 13,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _ArchitecturalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB).withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    const double spacing = 48;
    for (double i = 0; i < size.width + spacing; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height * 0.5, size.height), paint);
    }
    
    for (double i = -size.height; i < size.width; i += spacing * 1.5) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.width, size.width * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
