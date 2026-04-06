import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../models/order_list_response.dart';
import '../../models/order_timeline_response.dart';
import '../../services/auth_service.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderListItem? _order;
  List<OrderTimelineItem> _timeline = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      // Fetch both details and timeline in parallel
      final results = await Future.wait([
        AuthService.getOrderDetails(widget.orderId),
        AuthService.getOrderTimeline(widget.orderId),
      ]);

      setState(() {
        _order = results[0] as OrderListItem;
        _timeline = results[1] as List<OrderTimelineItem>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchOrderDetails,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_order == null) {
      return const Scaffold(body: Center(child: Text('Order not found')));
    }

    final order = _order!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: _buildAppBar(context, order),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CustomerProfileCard(customer: order.customer),
            const SizedBox(height: 24),
            _GarmentConfigurationCard(order: order),
            const SizedBox(height: 24),
            _ProductionProgressCard(
              status: order.orderStatus, 
              date: order.orderDate,
              timeline: _timeline,
            ),
            const SizedBox(height: 24),
            // Measurements depend on items - if items exist, look for measurements
            _MeasurementsGridCard(),
            const SizedBox(height: 32),
            _SpecialRequestsCard(order: order),
            const SizedBox(height: 48),
            _PaymentSummaryCard(order: order),
            const SizedBox(height: 100), // Safe area bottom padding
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, OrderListItem order) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FC),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Order #${order.billNumber.replaceAll('INV', '')}',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryDark,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary, size: 20),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData? trailingIcon;
  const _SectionTitle(this.title, {this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF475569), // AppColors.textSecondary but darker
            letterSpacing: 1.0,
          ),
        ),
        if (trailingIcon != null)
          Icon(trailingIcon, size: 16, color: AppColors.primaryDark),
      ],
    );
  }
}

class _CustomerProfileCard extends StatelessWidget {
  final OrderCustomer? customer;
  const _CustomerProfileCard({this.customer});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Decorational background swoosh (conceptual)
        Positioned(
          top: -20,
          right: -20,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.05),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                          Expanded(
                            child: Text(
                              customer != null ? '${customer!.firstName} ${customer!.lastName}'.trim() : 'Guest Customer',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (customer != null && customer!.email.contains('elite'))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ELITE\nMEMBER',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                customer?.email ?? 'No email provided',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone_rounded, size: 12, color: Color(0xFF8B5CF6)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      customer?.phoneNumber ?? 'N/A',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                  const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFF8B5CF6)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Address\non File', // API doesn't return full address string easily here
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8B5CF6),
                      ),
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
      ],
    );
  }
}

class _GarmentConfigurationCard extends StatelessWidget {
  final OrderListItem order;
  const _GarmentConfigurationCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('GARMENT CONFIGURATION'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GARMENT TYPE',
                style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHint,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
                  Text(
                    order.firstItemName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FABRIC SELECTION',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHint,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.texture_rounded, size: 10, color: Color(0xFF8B5CF6)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.orderItems.isNotEmpty ? (order.orderItems.first.product.sku ?? 'Custom Selection') : 'Default Fabric',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CUT STYLE',
                          style: GoogleFonts.inter(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHint,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Slim Fit',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LAPEL',
                          style: GoogleFonts.inter(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHint,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Peak Lapel',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Fabric Swatch Image
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?auto=format&fit=crop&w=600&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductionProgressCard extends StatelessWidget {
  final String status;
  final DateTime date;
  final List<OrderTimelineItem> timeline;

  const _ProductionProgressCard({
    required this.status,
    required this.date,
    required this.timeline,
  });

  @override
  Widget build(BuildContext context) {
    // Define the fixed steps the user requested
    final steps = [
      {'id': 'pending', 'label': 'Pending', 'icon': Icons.pending_actions_rounded},
      {'id': 'confirmed', 'label': 'Confirmed', 'icon': Icons.check_circle_outline_rounded},
      {'id': 'cancelled', 'label': 'Cancelled', 'icon': Icons.cancel_outlined},
    ];

    // Determine current status index
    int currentStepIndex = -1;
    final currentStatus = status.toLowerCase();
    
    if (currentStatus == 'pending') currentStepIndex = 0;
    else if (currentStatus == 'confirmed') currentStepIndex = 1;
    else if (currentStatus == 'cancelled') currentStepIndex = 2;
    else if (currentStatus == 'completed') currentStepIndex = 1; // Treat completed as past confirmed

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('PRODUCTION PROGRESS'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              final stepId = step['id'] as String;
              
              // Find if this step is in history
              final historyEntry = timeline.firstWhere(
                (h) => h.status.toLowerCase() == stepId,
                orElse: () => OrderTimelineItem(
                  id: '', orderId: '', status: '', 
                  timestamp: DateTime.now(), createdBy: '', 
                  createdAt: DateTime.now(), updatedAt: DateTime.now()
                ),
              );

              bool isCompleted = false;
              bool isActive = false;
              String subtitle = 'Schedule Pending';

              // Logic for status rendering
              if (historyEntry.id.isNotEmpty) {
                isCompleted = true;
                subtitle = DateFormat('MMM dd, yyyy • HH:mm').format(historyEntry.timestamp);
              } else if (index <= currentStepIndex) {
                 // Even if not in timeline API yet, if main status says it's confirmed, pending is completed
                 isCompleted = true;
                 subtitle = index == currentStepIndex ? 'Current Status' : 'Completed';
              } else if (index == currentStepIndex + 1 && currentStatus != 'cancelled') {
                 isActive = true;
                 subtitle = 'Next Phase';
              }

              // Special case for Cancelled - only show if it happened or if we are there
              if (stepId == 'cancelled' && currentStatus != 'cancelled' && historyEntry.id.isEmpty) {
                return const SizedBox.shrink();
              }

              return _TimelineStep(
                title: step['label'] as String,
                subtitle: subtitle,
                status: isCompleted ? _StepStatus.completed : (isActive ? _StepStatus.active : _StepStatus.pending),
                isFirst: index == 0,
                isLast: index == steps.length - 1 || (stepId == 'confirmed' && currentStatus != 'cancelled' && !steps.any((s) => s['id'] == 'cancelled' && status.toLowerCase() == 'cancelled')),
              );
            }).where((w) => w is! SizedBox).toList(),
          ),
        ),
      ],
    );
  }
}

enum _StepStatus { completed, active, pending }

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final _StepStatus status;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.status,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    Color nodeColor;
    Color nodeInner;
    Color textColor;
    Color subtitleColor;

    switch (status) {
      case _StepStatus.completed:
        nodeColor = const Color(0xFF1E3A8A); // Match dark blue tick
        nodeInner = Colors.transparent;
        textColor = AppColors.textPrimary;
        subtitleColor = AppColors.textHint;
        break;
      case _StepStatus.active:
        nodeColor = const Color(0xFF8B5CF6);
        nodeInner = Colors.white;
        textColor = const Color(0xFF8B5CF6);
        subtitleColor = const Color(0xFF8B5CF6).withValues(alpha: 0.8);
        break;
      case _StepStatus.pending:
        nodeColor = const Color(0xFFE5E7EB);
        nodeInner = const Color(0xFFE5E7EB);
        textColor = AppColors.textHint;
        subtitleColor = AppColors.border;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Node & Line
          SizedBox(
            width: 30,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: status == _StepStatus.pending ? const Color(0xFFF3F4F6) : const Color(0xFFE5E7EB),
                    ),
                  )
                else
                  const SizedBox(height: 6),
                  
                // The Node Dot
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status == _StepStatus.completed ? nodeColor : nodeInner,
                    border: Border.all(
                      color: nodeColor,
                      width: status == _StepStatus.active ? 4.0 : 0.0,
                    ),
                  ),
                  child: status == _StepStatus.completed
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : (status == _StepStatus.active
                          ? Center(
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: nodeColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: status == _StepStatus.pending ? const Color(0xFFF3F4F6) : const Color(0xFFE5E7EB),
                    ),
                  )
                else
                  const SizedBox(height: 6),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: status == _StepStatus.active ? FontWeight.w500 : FontWeight.w400,
                      fontStyle: status == _StepStatus.active || status == _StepStatus.pending 
                          ? FontStyle.italic 
                          : FontStyle.normal,
                      color: subtitleColor,
                    ),
                  ),
                  if (!isLast) const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementsGridCard extends StatelessWidget {
  const _MeasurementsGridCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('MEASUREMENTS', trailingIcon: Icons.view_sidebar_rounded),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MeasureSquare('CHEST', '42.5', 'in'),
            _MeasureSquare('WAIST', '34.0', 'in'),
            _MeasureSquare('SLEEVE', '25.5', 'in'),
            _MeasureSquare('SHOULDER', '18.2', 'in'),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'VIEW FULL SPEC SHEET',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MeasureSquare extends StatelessWidget {
  final String label;
  final String val;
  final String unit;

  const _MeasureSquare(this.label, this.val, this.unit);

  @override
  Widget build(BuildContext context) {
    // Determine responsive width (half of screen minus paddings)
    final w = (MediaQuery.of(context).size.width - 40 - 12) / 2;

    return Container(
      width: w,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: AppColors.textHint,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                val,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  final OrderListItem order;
  const _PaymentSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('PAYMENT SUMMARY'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Contract',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${order.grandTotal}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    order.paymentStatus.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: order.paymentStatus.toLowerCase() == 'paid' ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2), // Light red bg
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remaining Balance',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFDC2626), // Red
                      ),
                    ),
                    Text(
                      '£1,350.00',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'PROCESS FINAL PAYMENT',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecialRequestsCard extends StatelessWidget {
  final OrderListItem order;
  const _SpecialRequestsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.note_alt_outlined, size: 14, color: AppColors.primaryDark),
            const SizedBox(width: 8),
            Text(
              'SPECIAL REQUESTS',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Text(
            order.notes ?? "No special requests specified.",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF334155),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
