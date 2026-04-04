import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/home_provider.dart';
import '../../providers/order_management_provider.dart';
import 'add_staff_screen.dart';
import '../shell/widgets/app_drawer.dart';

class ArtisanModel {
  final String name;
  final String title;
  final String avatarUrl;
  final int assignedOrders;
  final int maxCapacity;
  final Color statusDotColor;
  final List<String> skills;

  const ArtisanModel({
    required this.name,
    required this.title,
    required this.avatarUrl,
    required this.assignedOrders,
    required this.maxCapacity,
    required this.statusDotColor,
    required this.skills,
  });

  double get capacityPercentage => assignedOrders / maxCapacity;
  bool get isOverCapacity => assignedOrders >= maxCapacity;
}

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchStatistics();
    });
  }

  static const List<ArtisanModel> _artisans = [
    ArtisanModel(
      name: 'Julian Thorne',
      title: 'MASTER CUTTER',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
      assignedOrders: 8,
      maxCapacity: 10, // 80%
      statusDotColor: Color(0xFF10B981), // Green
      skills: ['BESPOKE', 'SUITS'],
    ),
    ArtisanModel(
      name: 'Elena Moretti',
      title: 'SENIOR TAILOR',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80',
      assignedOrders: 12,
      maxCapacity: 13, // ~92%
      statusDotColor: Color(0xFF10B981), // Green
      skills: ['EVENINGWEAR', 'SILK'],
    ),
    ArtisanModel(
      name: 'Marcus Lin',
      title: 'APPRENTICE',
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
      assignedOrders: 3,
      maxCapacity: 12, // 25%
      statusDotColor: Color(0xFFF59E0B), // Orange
      skills: ['ALTERATIONS'],
    ),
    ArtisanModel(
      name: 'Sarah Jenkins',
      title: 'LEAD SEAMSTRESS',
      avatarUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80',
      assignedOrders: 15,
      maxCapacity: 15, // OVER CAPACITY
      statusDotColor: Color(0xFF10B981), // Green
      skills: ['BRIDAL', 'DRAPING'],
    ),
    ArtisanModel(
      name: 'Arthur Vance',
      title: 'SENIOR CUTTER',
      avatarUrl:
          'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=150&q=80',
      assignedOrders: 5,
      maxCapacity: 12, // ~41% (visual 40%)
      statusDotColor: Color(0xFF94A3B8), // Gray
      skills: ['HERITAGE', 'OUTERWEAR'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      drawer: const AppDrawer(),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 16),
            _buildAddStaffButton(context),
            const SizedBox(height: 32),
            _buildSummaryCards(context),
            const SizedBox(height: 32),
            _buildArtisanList(context),
            const SizedBox(height: 16),
            _buildOnboardButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FC),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E3A8A)),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      centerTitle: true,
      title: Text(
        'The Bespoke Atelier',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1E3A8A),
        ),
      ),

    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Staff Management',
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1B4B),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Organize and monitor your atelier\'s expert artisans.',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildAddStaffButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStaffScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
        label: Text(
          'Add Staff',
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final orderProvider = Provider.of<OrderManagementProvider>(context);
    
    return Column(
      spacing: 16,
      children: [
        // Total Artisans
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.people_outline_rounded,
                    size: 24,
                    color: Color(0xFF0F172A),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4F46E5),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total Artisans',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '12',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        // Current Workload
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E8FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_box_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Current Workload',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${homeProvider.totalOrders} Orders',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF7C3AED),
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),
        // Efficiency Rate
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.insights_rounded,
                size: 24,
                color: Color(0xFF0F172A),
              ),
              const SizedBox(height: 16),
              Text(
                'Efficiency Rate',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${orderProvider.dailyEfficiency.toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArtisanList(BuildContext context) {
    return Column(
      spacing: 20,
      children: _artisans
          .map((artisan) => _buildArtisanCard(context, artisan))
          .toList(),
    );
  }

  Widget _buildArtisanCard(BuildContext context, ArtisanModel artisan) {
    // Math logic purely for mockup visuals based on the user image logic:
    // Capacity progress logic
    final capacityVal = artisan.assignedOrders == 5 && artisan.maxCapacity == 12
        ? 40
        : (artisan.capacityPercentage * 100).toInt();
    final capString = artisan.isOverCapacity
        ? "OVER CAPACITY"
        : "Capacity: $capacityVal%";

    return Container(
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
          // Row 1: Profile, Name, Title, Edit
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(artisan.avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: artisan.statusDotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artisan.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      artisan.title,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8B5CF6), // Purple Title
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Color(0xFF64748B),
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Row 2: Capacity Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assigned Orders',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    Text(
                      artisan.assignedOrders.toString().padLeft(2, '0'),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width:
                          MediaQuery.of(context).size.width *
                          0.65 *
                          (artisan.capacityPercentage > 1.0
                              ? 1.0
                              : artisan.capacityPercentage),
                      height: 6,
                      decoration: BoxDecoration(
                        color: artisan.isOverCapacity
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFF1E3A8A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  capString,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: artisan.isOverCapacity
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Row 3: Skills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: artisan.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  skill,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
      ),
      // Mimicing dashed border with a simple solid border for standard flutter (or we can use a custom painter, but plain border works for the requested layout structure proxy)
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Color(0xFF94A3B8),
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Onboard New Artisan',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
