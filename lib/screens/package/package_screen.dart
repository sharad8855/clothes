import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../providers/package_provider.dart';
import '../measurement/measurement_screen.dart';

class PackageScreen extends StatelessWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(context),
      body: const _PackageScreenBody(),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.textPrimary),
        onPressed: () {},
      ),
      title: Text(
        'Royal Stitch',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: CircleAvatar(
              radius: 18,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PackageScreenBody extends StatelessWidget {
  const _PackageScreenBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _StepperTop(),
          SizedBox(height: 24),
          _ClientProfileCard(),
          SizedBox(height: 32),
          _SectionTitle(title: 'Select Garment Type', required: true),
          SizedBox(height: 16),
          _GarmentTypeGrid(),
          SizedBox(height: 32),
          _SectionTitle(title: 'Core Customization', required: false),
          SizedBox(height: 16),
          _CustomizationRows(),
          SizedBox(height: 24),
          _SmartSuggestCard(),
          SizedBox(height: 24),
          _SelectionSummaryPanel(),
          SizedBox(height: 16),
          _InfoBanner(),
          SizedBox(height: 32), // Padding before bottom nav
        ],
      ),
    );
  }
}

class _StepperTop extends StatelessWidget {
  const _StepperTop();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStep(
          label: 'CUSTOMER',
          isActive: false,
          isCompleted: true,
          stepNumber: 1,
        ),
        _buildDivider(isActive: true),
        _buildStep(
          label: 'PACKAGE',
          isActive: true,
          isCompleted: false,
          stepNumber: 2,
        ),
        _buildDivider(isActive: false),
        _buildStep(
          label: 'MEASUREMENTS',
          isActive: false,
          isCompleted: false,
          stepNumber: 3,
        ),
      ],
    );
  }

  Widget _buildStep({
    required String label,
    required bool isActive,
    required bool isCompleted,
    required int stepNumber,
  }) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted || isActive ? AppColors.primaryDark : AppColors.inputBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : Text(
                  '$stepNumber',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: isActive ? AppColors.primaryDark : AppColors.textHint,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider({required bool isActive}) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(top: 13, left: 8, right: 8),
      color: isActive ? const Color(0xFFE0E7FF) : AppColors.inputBg,
    );
  }
}

class _ClientProfileCard extends StatelessWidget {
  const _ClientProfileCard();

  @override
  Widget build(BuildContext context) {
    final selectedCustomer = context.watch<PackageProvider>().selectedCustomer;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.inputBg,
            child: Text(
              selectedCustomer?.initials ?? '?',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCustomer?.fullName ?? 'Unknown Customer',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  selectedCustomer != null 
                    ? '${selectedCustomer.countryCode} ${selectedCustomer.phoneNumber}'
                    : 'No contact information',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Change',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool required;

  const _SectionTitle({required this.title, required this.required});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (required)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Required',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

class _GarmentTypeGrid extends StatelessWidget {
  const _GarmentTypeGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: const [
        _GarmentCard(
          type: GarmentType.suit,
          title: 'Two-Piece Suit',
          description: 'Jacket and trousers matched for business or formal wear.',
          icon: Icons.checkroom_rounded,
        ),
        _GarmentCard(
          type: GarmentType.tuxedo,
          title: 'Tuxedo',
          description: 'Evening wear featuring satin lapels and refined details.',
          icon: Icons.checkroom_outlined,
        ),
        _GarmentCard(
          type: GarmentType.overcoat,
          title: 'Overcoat',
          description: 'Heavyweight outer garment designed for warmth and style.',
          icon: Icons.layers_rounded,
        ),
        _GarmentCard(
          type: GarmentType.shirt,
          title: 'Bespoke Shirt',
          description: 'Precision fitted shirts with custom collars and cuffs.',
          icon: Icons.dry_cleaning_rounded,
        ),
      ],
    );
  }
}

class _GarmentCard extends StatelessWidget {
  final GarmentType type;
  final String title;
  final String description;
  final IconData icon;

  const _GarmentCard({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();
    final isSelected = provider.selectedGarment == type;

    return GestureDetector(
      onTap: () => provider.setGarmentType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            width: 1.5,
          ),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE0E7FF) : AppColors.inputBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomizationRows extends StatelessWidget {
  const _CustomizationRows();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildRow(
            icon: Icons.label_important_rounded,
            label: 'Lapel Type',
            value: provider.lapelName,
            isFirst: true,
          ),
          const Divider(height: 1, indent: 50, endIndent: 20, color: AppColors.inputBg),
          _buildRow(
            icon: Icons.waves_rounded,
            label: 'Vent Style',
            value: provider.ventName,
          ),
          const Divider(height: 1, indent: 50, endIndent: 20, color: AppColors.inputBg),
          _buildRow(
            icon: Icons.radio_button_checked_rounded,
            label: 'Button Count',
            value: provider.buttonName,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _SmartSuggestCard extends StatelessWidget {
  const _SmartSuggestCard();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();
    final selectedCustomer = provider.selectedCustomer;
    if (provider.isSmartSuggestApplied) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 10),
              Text(
                'SMART SUGGEST',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF7C3AED),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            provider.suggestPackageName,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                TextSpan(text: "Based on ${selectedCustomer?.fullName ?? 'customer'}'s previous orders, they prefer the "),
                TextSpan(
                  text: "Slim Fit silhouette",
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: const Color(0xFF7C3AED)),
                ),
                const TextSpan(
                  text: " with unstructured shoulders. This package auto-populates these preferences.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.applySmartSuggest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Apply Recommended Config',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionSummaryPanel extends StatelessWidget {
  const _SelectionSummaryPanel();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: AppColors.primaryDark, size: 18),
              const SizedBox(width: 8),
              Text(
                'Selection Summary',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Garment Base', value: provider.garmentName),
          const SizedBox(height: 12),
          // Show craftsmanship only if suit
          if (provider.selectedGarment == GarmentType.suit) ...[
            _SummaryRow(
              label: 'Craftsmanship', 
              value: '${provider.craftsmanshipName} (+ \$${provider.craftsmanshipMarkup.toStringAsFixed(0)})',
            ),
            const SizedBox(height: 12),
          ],
          _SummaryRow(
            label: 'Package', 
            value: provider.isSmartSuggestApplied ? 'Savile Slim' : 'Standard',
            valueColor: provider.isSmartSuggestApplied ? const Color(0xFF7C3AED) : AppColors.textPrimary,
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Est. Base Price',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                provider.estPriceFormatted,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Fabric selection will follow measurement verification to ensure yardage accuracy for the selected cut.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 18, color: AppColors.textSecondary),
            label: Text(
              'Back',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MeasurementScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Next: Measurements',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
