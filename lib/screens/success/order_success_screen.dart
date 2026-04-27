import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../providers/order_success_provider.dart';
import '../../providers/package_provider.dart';
import '../../providers/order_management_provider.dart';
import '../orders/order_details_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderSuccessProvider(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: _buildAppBar(context),
        body: _OrderSuccessScreenBody(orderId: widget.orderId),
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
        'ORDER CONFIRMED',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
          letterSpacing: 1.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Consumer<PackageProvider>(
            builder: (context, packageProvider, _) {
              final customer = packageProvider.selectedCustomer;
              return Center(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.inputBg,
                  child: Text(
                    customer?.initials ?? '?',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrderSuccessScreenBody extends StatelessWidget {
  final String orderId;
  const _OrderSuccessScreenBody({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const _HeroCheckmark(),
          const SizedBox(height: 32),
          const _TypographySection(),
          const SizedBox(height: 32),
          _OrderSummarySheet(orderId: orderId),
          const SizedBox(height: 32),
          _ActionButtons(orderId: orderId),
          const SizedBox(height: 60),
          const _AiTipCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _HeroCheckmark extends StatelessWidget {
  const _HeroCheckmark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6), // Primary Purple
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }
}

class _TypographySection extends StatelessWidget {
  const _TypographySection();

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageProvider>(
      builder: (context, packageProvider, _) {
        final customerName =
            packageProvider.selectedCustomer?.fullName ?? 'the customer';
        return Column(
          children: [
            Text(
              'Order Successfully\nPlaced',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'The bespoke crafting process for $customerName\'s order has been initiated in your workshop queue.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OrderSummarySheet extends StatelessWidget {
  final String orderId;
  const _OrderSummarySheet({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          _SummaryRow(
            label: 'ORDER ID',
            child: Text(
              '#ORD-${(orderId.length >= 6 ? orderId.substring(0, 6) : orderId).toUpperCase()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'CUSTOMER',
            child: Consumer<PackageProvider>(
              builder: (context, packageProvider, _) {
                return Text(
                  packageProvider.selectedCustomer?.fullName ??
                      'Unknown Customer',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'ORDER DATE',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primaryDark),
                const SizedBox(width: 8),
                Text(
                  _formatDate(DateTime.now()),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'PAYMENT STATUS',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE), // Light purple background
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primaryDark),
                  const SizedBox(width: 6),
                  Text(
                    'Payment Recorded',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _SummaryRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.textHint,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String orderId;
  const _ActionButtons({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: orderId)),
              );
            },
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
                Text(
                  'View Order Details',
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
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // Clear current order state
            context.read<PackageProvider>().clearAll();
            
            // Refresh orders list so the new order shows up immediately
            context.read<OrderManagementProvider>().fetchOrders(refresh: true);
            
            // Drop entire modal/screen stack back to root (home screen)
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Text(
            'Back to Dashboard',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _AiTipCard extends StatelessWidget {
  const _AiTipCard();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderSuccessProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF8B5CF6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Tip',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Would you like me to send a WhatsApp notification to the customer?',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                _buildWhatsappAction(context, provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsappAction(BuildContext context, OrderSuccessProvider provider) {
    if (provider.whatsAppStatus == WhatsAppStatus.sent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981), // Green Success
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              'Message Sent!',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: provider.whatsAppStatus == WhatsAppStatus.sending 
          ? null 
          : provider.sendWhatsAppNotification,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (provider.whatsAppStatus == WhatsAppStatus.sending)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          else ...[
            Text(
              'Send Now',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.send_rounded, size: 12),
          ]
        ],
      ),
    );
  }
}
