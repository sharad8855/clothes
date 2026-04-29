import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/package_provider.dart';
import '../measurement/measurement_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PACKAGE SCREEN (Step 2 of Create Order flow)
// Replaces the old hardcoded "Select Garment Type" with a live product grid
// fetched from the backend API.
// ─────────────────────────────────────────────────────────────────────────────

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackageProvider>().fetchProducts();
    });
  }

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
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          Text(
            'Select Product',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          Text(
            'Step 2 — Order Flow',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BODY
// ─────────────────────────────────────────────────────────────────────────────
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
          _SectionTitle(),
          SizedBox(height: 16),
          _ProductGrid(),
          SizedBox(height: 24),
          _SelectionSummaryPanel(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEPPER (unchanged visual)
// ─────────────────────────────────────────────────────────────────────────────
class _StepperTop extends StatelessWidget {
  const _StepperTop();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStep(label: 'CUSTOMER', isActive: false, isCompleted: true, stepNumber: 1),
        _buildDivider(isActive: true),
        _buildStep(label: 'PACKAGE', isActive: true, isCompleted: false, stepNumber: 2),
        _buildDivider(isActive: false),
        _buildStep(label: 'MEASUREMENTS', isActive: false, isCompleted: false, stepNumber: 3),
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

// ─────────────────────────────────────────────────────────────────────────────
// SELECTED CUSTOMER CHIP
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select Package or Product',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
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

// ─────────────────────────────────────────────────────────────────────────────
// PRODUCT GRID — fetches and displays live products
// ─────────────────────────────────────────────────────────────────────────────
class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingProducts) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (provider.productsError != null) {
          return _buildError(context, provider);
        }

        if (provider.products.isEmpty) {
          return _buildEmpty();
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            return _ProductCard(product: provider.products[index]);
          },
        );
      },
    );
  }

  Widget _buildError(BuildContext context, PackageProvider provider) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFEF4444), size: 36),
          const SizedBox(height: 10),
          Text(
            'Failed to load products',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: provider.fetchProducts,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primaryDark),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Retry',
                style:
                    GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 40, color: AppColors.textHint),
          const SizedBox(height: 10),
          Text(
            'No products available',
            style: GoogleFonts.inter(
                fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRODUCT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();
    final isSelected = provider.selectedProduct?.productId == product.productId;
    final imageUrl = product.primaryImageUrl;
    final price = product.displayPrice;

    return GestureDetector(
      onTap: () => provider.setSelectedProduct(product),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryDark.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product image — fixed height
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderImage(),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return _loadingImage();
                        },
                      )
                    : _placeholderImage(),
              ),
            ),
            // Product info — no Spacer, compact layout
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.productCategory.isNotEmpty)
                    Text(
                      product.productCategory.first.name,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: AppColors.textHint,
                      ),
                      maxLines: 1,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (price > 0)
                        Text(
                          '₹${price.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: AppColors.inputBg,
      child: const Center(
        child: Icon(Icons.checkroom_rounded,
            size: 40, color: AppColors.textHint),
      ),
    );
  }

  Widget _loadingImage() {
    return Container(
      color: AppColors.inputBg,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SELECTION SUMMARY PANEL
// ─────────────────────────────────────────────────────────────────────────────
class _SelectionSummaryPanel extends StatelessWidget {
  const _SelectionSummaryPanel();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();
    if (provider.selectedProduct == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded,
                  color: AppColors.primaryDark, size: 18),
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
          _SummaryRow(label: 'Product', value: provider.selectedProductName),
          if (provider.selectedCategoryName.isNotEmpty) ...[
            const SizedBox(height: 10),
            _SummaryRow(label: 'Category', value: provider.selectedCategoryName),
          ],
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Base Price',
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
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAV BAR — disabled until a product is selected
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();
    final hasSelection = provider.selectedProduct != null;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBg,
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: hasSelection
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MeasurementScreen()),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            disabledBackgroundColor: AppColors.border,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next: Measurements',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
