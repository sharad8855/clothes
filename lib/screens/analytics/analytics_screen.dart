import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shell/widgets/app_drawer.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E3A8A)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'Royal Stitch BI',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopMetricsBar(),
            const SizedBox(height: 24),
            _buildRevenueTrendCard(),
            const SizedBox(height: 24),
            _buildClientRetentionCard(),
            const SizedBox(height: 32),
            _buildAIStrategyHeader(),
            const SizedBox(height: 16),
            _buildAIStrategyCard(
              icon: Icons.inventory_2_rounded,
              tag: 'SUPPLY INSIGHT',
              tagColor: const Color(0xFF8B5CF6),
              titleText: 'High Demand Alert: ',
              descText: 'Loro Piana fabrics are trending. Suggest increasing inventory by ',
              highlightText: '20%.',
              buttonLabel: 'Adjust Inventory',
            ),
            const SizedBox(height: 16),
            _buildAIStrategyCard(
              icon: Icons.schedule_rounded,
              tag: 'OPS EFFICIENCY',
              tagColor: const Color(0xFF8B5CF6),
              titleText: 'Lead Time Optimization: ',
              descText: 'Reducing bespoke lead time to 3.5 weeks could increase capacity by ',
              highlightText: '12%.',
              buttonLabel: 'Review Staffing',
            ),
            const SizedBox(height: 24),
            _buildRevenueByCategory(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMetricsBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildMetricCard(
            title: 'Total Revenue',
            value: '\$142.8k',
            trend: '↗ +14% vs last month',
            trendColor: const Color(0xFF10B981),
            icon: Icons.payments_rounded,
          ),
          const SizedBox(width: 16),
          _buildMetricCard(
            title: 'Active Orders',
            value: '48',
            trend: '7 scheduled this week',
            trendColor: const Color(0xFF64748B),
            icon: null,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required Color trendColor,
    IconData? icon,
  }) {
    return Container(
      width: 180,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              if (icon != null)
                Icon(icon, size: 16, color: const Color(0xFF1E3A8A)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: trendColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTrendCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Revenue Trend',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      '6 Months',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.more_vert_rounded, size: 20, color: Color(0xFF64748B)),
            ],
          ),
          const SizedBox(height: 32),
          // Bar Chart Proxy
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartBar(60, false),
                    _buildChartBar(80, false),
                    _buildChartBar(70, false),
                    _buildChartBar(100, false),
                    _buildChartBar(120, false),
                    _buildChartBar(160, true), // Active Jun highlighting
                  ],
                ),
                // Pseudo Line chart
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(double.infinity, 50),
                    painter: _CurveLinePainter(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // X Axis
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'].map((m) {
              return Text(
                m,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(double height, bool isHighlighted) {
    return Container(
      width: 32,
      height: height,
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFF02206B) : const Color(0xFFCBD5E1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
    );
  }

  Widget _buildClientRetentionCard() {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Client Retention',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: 0.78,
                  strokeWidth: 12,
                  backgroundColor: const Color(0xFFE2E8F0),
                  color: const Color(0xFF7C3AED),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '78%',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -1.0,
                    ),
                  ),
                  Text(
                    'LOYALTY',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF64748B),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'Repeat customer rate is '),
                TextSpan(
                  text: 'up 4%',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7C3AED),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' from Q1\nperformance.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIStrategyHeader() {
    return Row(
      children: [
        const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7C3AED), size: 20),
        const SizedBox(width: 8),
        Text(
          'AI Business Strategy',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E3A8A),
          ),
        ),
      ],
    );
  }

  Widget _buildAIStrategyCard({
    required IconData icon,
    required String tag,
    required Color tagColor,
    required String titleText,
    required String descText,
    required String highlightText,
    required String buttonLabel,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF).withValues(alpha: 0.6), // Ultra light purple
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: tagColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                tag,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: tagColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0F172A),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: titleText,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: descText),
                TextSpan(
                  text: highlightText,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    color: tagColor,
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
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonLabel,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueByCategory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue by Category',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 24),
          _buildProgressBar('Bespoke Suits', '\$84,000', 0.8, const Color(0xFF02206B)),
          const SizedBox(height: 16),
          _buildProgressBar('Evening Gowns', '\$32,500', 0.5, const Color(0xFF8B5CF6)),
          const SizedBox(height: 16),
          _buildProgressBar('Luxury Shirts', '\$18,200', 0.35, const Color(0xFF8B5CF6)),
          const SizedBox(height: 16),
          _buildProgressBar('Alterations', '\$8,100', 0.15, const Color(0xFFCBD5E1)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String title, String value, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            LayoutBuilder(
              builder: (ctx, constraints) {
                return Container(
                  height: 8,
                  width: constraints.maxWidth * percentage,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Painter for drawing the smooth bezier curve overlay matching the mockup trend
class _CurveLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.3,
      size.width * 0.5, size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.9,
      size.width, size.height * 0.4,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
