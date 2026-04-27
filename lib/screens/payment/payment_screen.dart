import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../providers/payment_provider.dart';
import '../../providers/package_provider.dart';
import '../../providers/fabric_provider.dart';
import '../../providers/measurement_provider.dart';
import '../success/order_success_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentProvider(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: _buildAppBar(context),
        body: const _PaymentScreenBody(),
        bottomNavigationBar: const _BottomNavBar(),
        floatingActionButton: _buildSecurePaymentFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Payment Details',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Widget _buildSecurePaymentFab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(8)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock, size: 14, color: AppColors.primaryDark),
                const SizedBox(width: 8),
                Text(
                  'SECURE SSL ENCRYPTED PAYMENT',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6), // Purple Sparkle Color
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome, // Sparkle icon
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentScreenBody extends StatelessWidget {
  const _PaymentScreenBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _OrderSummaryCard(),
          SizedBox(height: 20),
          _AdvancePaymentSection(),
          SizedBox(height: 28),
          _PaymentMethodSection(),
          SizedBox(height: 24),
          _CreditCardForm(),
          SizedBox(height: 80), // Padding to clear the FAB and BottomBar safely
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFE5E7EB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORDER #ORD-8832',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'AWAITING PAYMENT',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4338CA),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<PackageProvider>(
              builder: (context, packageProvider, _) {
                final product = packageProvider.selectedProduct;
                final imageUrl = product?.primaryImageUrl;

                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.checkroom,
                                        color: AppColors.textHint),
                                  )
                                : const Icon(Icons.checkroom,
                                    color: AppColors.textHint),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.name ?? 'Unknown Product',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product != null
                                    ? 'SKU: ${product.sku} • ${product.currency}'
                                    : 'No product details',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          packageProvider.estPriceFormatted,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Advance Payment Section ───────────────────────────────────────────────

class _AdvancePaymentSection extends StatefulWidget {
  const _AdvancePaymentSection();

  @override
  State<_AdvancePaymentSection> createState() => _AdvancePaymentSectionState();
}

class _AdvancePaymentSectionState extends State<_AdvancePaymentSection> {
  @override
  void initState() {
    super.initState();
    // Listen to controller changes to update the UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().advanceController.addListener(_onChanged);
    });
  }

  void _onChanged() {
    context.read<PaymentProvider>().onAdvanceChanged();
  }

  @override
  void dispose() {
    // Listener is cleaned up with the controller in the provider
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();
    final packageProvider = context.watch<PackageProvider>();

    // Parse total amount from formatted string (remove ₹, commas etc.)
    final rawPrice = packageProvider.estPriceFormatted
        .replaceAll(RegExp(r'[^\d.]'), '');
    final totalAmount = double.tryParse(rawPrice) ?? 0.0;
    final advance = provider.advanceAmount;
    final remaining = provider.remainingBalance(totalAmount);
    final hasAdvance = advance > 0;

    return Container(
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
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Advance Payment',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'OPTIONAL',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ADVANCE AMOUNT',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasAdvance
                          ? const Color(0xFF4F46E5).withValues(alpha: 0.3)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          '₹',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: provider.advanceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textHint,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      if (hasAdvance)
                        GestureDetector(
                          onTap: () {
                            provider.advanceController.clear();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Icon(
                              Icons.cancel_rounded,
                              color: AppColors.textHint,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Remaining Balance (visible only when advance > 0)
                if (hasAdvance) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Color(0xFF16A34A),
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Advance Received',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF16A34A),
                              ),
                            ),
                            Text(
                              '₹${advance.toStringAsFixed(2)} paid in advance',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: const Color(0xFF16A34A).withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'REMAINING',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '₹${remaining.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: remaining == 0
                                    ? const Color(0xFF16A34A)
                                    : AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Payment Method Section ──────────────────────────────────────────────────

class _PaymentMethodSection extends StatelessWidget {
  const _PaymentMethodSection();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        _MethodTile(
          method: PaymentMethod.card,
          title: 'Credit or Debit Card',
          icon: Icons.credit_card_rounded,
          isSelected: provider.selectedMethod == PaymentMethod.card,
          onTap: () => provider.setPaymentMethod(PaymentMethod.card),
        ),
        const SizedBox(height: 12),
        _MethodTile(
          method: PaymentMethod.paypal,
          title: 'PayPal',
          icon: Icons.payments_rounded,
          isSelected: provider.selectedMethod == PaymentMethod.paypal,
          isDisabled: true, // Coming Soon
          onTap: () => provider.setPaymentMethod(PaymentMethod.paypal),
          badge: 'COMING SOON',
        ),
        const SizedBox(height: 12),
        _MethodTile(
          method: PaymentMethod.bank,
          title: 'Bank Transfer',
          icon: Icons.account_balance_rounded,
          isSelected: provider.selectedMethod == PaymentMethod.bank,
          onTap: () => provider.setPaymentMethod(PaymentMethod.bank),
        ),
        const SizedBox(height: 12),
        _MethodTile(
          method: PaymentMethod.payLater,
          title: 'Pay Later',
          icon: Icons.access_time_rounded,
          isSelected: provider.selectedMethod == PaymentMethod.payLater,
          onTap: () => provider.setPaymentMethod(PaymentMethod.payLater),
          badge: 'IN-PERSON',
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  final PaymentMethod method;
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;
  final String? badge;

  const _MethodTile({
    required this.method,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFFF3F4F6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : (isDisabled ? Colors.transparent : Colors.white),
            width: 2,
          ),
          boxShadow: [
            if (!isDisabled)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryDark : (isDisabled ? AppColors.textHint : AppColors.textPrimary),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isDisabled ? AppColors.textSecondary : AppColors.primaryDark,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
            const Spacer(),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryDark : AppColors.border,
                  width: isSelected ? 6 : 2,
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditCardForm extends StatelessWidget {
  const _CreditCardForm();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    if (provider.selectedMethod != PaymentMethod.card) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormField(
            label: 'CARDHOLDER NAME',
            hint: 'ALEXANDER STERLING',
            controller: provider.cardholderController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 16),
          _FormField(
            label: 'CARD NUMBER',
            hint: '**** **** **** 8832',
            controller: provider.cardNumberController,
            keyboardType: TextInputType.number,
            suffixIcon: Icons.credit_card_rounded,
            inputFormatters: [_CardNumberFormatter()],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _FormField(
                  label: 'EXPIRY DATE',
                  hint: 'MM / YY',
                  controller: provider.expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_ExpiryDateFormatter()],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _FormField(
                  label: 'CVV',
                  hint: '***',
                  controller: provider.cvvController,
                  keyboardType: TextInputType.number,
                  suffixIcon: Icons.info_outline_rounded,
                  maxLength: 4,
                  obscureText: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final IconData? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscureText;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            obscureText: obscureText,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: obscureText ? 2.0 : 1.0,
            ),
            decoration: InputDecoration(
              hintText: hint,
              counterText: '', // Hide default maxLength counter
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16, 
                vertical: suffixIcon != null ? 14 : 16
              ),
              suffixIcon: suffixIcon != null 
                ? Icon(suffixIcon, color: AppColors.textHint, size: 18) 
                : null,
              hintStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(color: AppColors.scaffoldBg),
      child: ElevatedButton(
        onPressed: provider.isProcessing ? null : () => _confirmPayment(context, provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (provider.isProcessing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            else ...[
              const Icon(Icons.verified_user_rounded, size: 18),
              const SizedBox(width: 8),
              Text(
                provider.selectedMethod == PaymentMethod.payLater ? 'Confirm Order' : 'Confirm Payment',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _confirmPayment(BuildContext context, PaymentProvider provider) async {
    final packageProvider = context.read<PackageProvider>();
    final fabricProvider = context.read<FabricProvider>();
    final measurementProvider = context.read<MeasurementProvider>();
    
    final customerId = packageProvider.selectedCustomer?.id ?? "unknown";
    final measurementData = measurementProvider.getMeasurementMap(customerId);

    try {
      final orderId = await provider.processPayment(
        packageProvider: packageProvider,
        measurementData: measurementData,
        fabricType: fabricProvider.selectedFabricType,
        fabricPattern: fabricProvider.selectedPrimaryPattern,
        fabricModifiers: fabricProvider.selectedModifiers.toList(),
      );

      if (orderId != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.selectedMethod == PaymentMethod.payLater ? 'Order Confirmed!' : 'Payment Confirmed!',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Route perfectly to Order Success!
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: orderId)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// Simple Input Formatters
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write(' / ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
