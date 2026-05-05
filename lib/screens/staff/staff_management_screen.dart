import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/home_provider.dart';
import '../../providers/order_management_provider.dart';
import '../../providers/staff_provider.dart';
import '../../models/business_staff_response.dart';
import '../../utils/localization/localization_extension.dart';
import 'add_staff_screen.dart';
import '../shell/widgets/app_drawer.dart';

// Design Tokens
const _bgScaffold  = Color(0xFFF7F8FA);
const _bgCard      = Colors.white;
const _bgChip      = Color(0xFFF0F1F5);
const _bgInner     = Color(0xFFF7F8FA);
const _borderLight = Color(0xFFE8EAF0);
const _textPrimary = Color(0xFF1A1D2B);
const _textSec     = Color(0xFF6E7491);
const _textMuted   = Color(0xFFA0A6C0);
const _accent      = Color(0xFF5B6BF8);
const _accentLight = Color(0xFFEEF0FD);
const _success     = Color(0xFF22C55E);
const _danger      = Color(0xFFEF4444);

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
      context.read<StaffProvider>().fetchStaff();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgScaffold,
      drawer: const AppDrawer(),
      appBar: _buildAppBar(),
      body: Consumer<StaffProvider>(builder: (context, staffProvider, _) {
        if (staffProvider.isLoading && staffProvider.staffList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: _accent));
        }
        if (staffProvider.error != null && staffProvider.staffList.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${context.errorPrefix}: ${staffProvider.error}',
                  style: GoogleFonts.inter(color: _textSec)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => staffProvider.fetchStaff(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(12)),
                  child: Text(context.retry,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ]),
          );
        }
        return RefreshIndicator(
          onRefresh: () => staffProvider.fetchStaff(),
          color: _accent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildPageHeader(),
              const SizedBox(height: 28),
              _buildHeroAddCard(context),
              const SizedBox(height: 28),
              _buildSummaryRow(context, staffProvider),
              const SizedBox(height: 32),
              Text("YOUR ARTISANS",
                  style: GoogleFonts.inter(
                      fontSize: 11, fontWeight: FontWeight.w700, color: _textMuted, letterSpacing: 1.5)),
              const SizedBox(height: 16),
              _buildArtisanList(context, staffProvider.staffList),
            ]),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _bgScaffold,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Builder(builder: (ctx) => IconButton(
        icon: const Icon(Icons.menu_rounded, color: _textPrimary, size: 26),
        onPressed: () => Scaffold.of(ctx).openDrawer(),
      )),
      centerTitle: true,
      title: Text(context.bespokeAtelier,
          style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: _textPrimary)),
    );
  }

  Widget _buildPageHeader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        text: TextSpan(children: [
          TextSpan(text: "Staff ",
              style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800,
                  color: _textPrimary, letterSpacing: -0.5, height: 1.2)),
          TextSpan(text: "Management",
              style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800,
                  color: _textPrimary, letterSpacing: -0.5, height: 1.2)),
        ]),
      ),
      const SizedBox(height: 6),
      Text(context.staffManagementDesc,
          style: GoogleFonts.inter(fontSize: 13, color: _textSec, height: 1.5)),
    ]);
  }

  Widget _buildHeroAddCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AddStaffScreen())),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _accent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: _accent.withValues(alpha: 0.22), blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.person_add_alt_1_rounded, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.addStaff,
                style: GoogleFonts.manrope(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 3),
            Text("Invite a new artisan to your team",
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.72))),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Colors.white70),
        ]),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, StaffProvider staffProvider) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final orderProvider = Provider.of<OrderManagementProvider>(context);
    return Row(children: [
      Expanded(child: _summaryCard(
          icon: Icons.groups_2_rounded, label: "Total\nArtisans",
          value: '${staffProvider.staffList.length}',
          iconBg: _accentLight, iconColor: _accent)),
      const SizedBox(width: 12),
      Expanded(child: _summaryCard(
          icon: Icons.assignment_turned_in_rounded, label: "Orders\nActive",
          value: '${homeProvider.totalOrders}',
          iconBg: const Color(0xFFEDF7F0), iconColor: _success)),
      const SizedBox(width: 12),
      Expanded(child: _summaryCard(
          icon: Icons.speed_rounded, label: "Efficiency\nRate",
          value: '${orderProvider.dailyEfficiency.toInt()}%',
          iconBg: const Color(0xFFFFF4EC), iconColor: const Color(0xFFF97316))),
    ]);
  }

  Widget _summaryCard({required IconData icon, required String label,
      required String value, required Color iconBg, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bgCard, borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(height: 12),
        Text(value,
            style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800,
                color: _textPrimary, letterSpacing: -0.5)),
        const SizedBox(height: 3),
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500,
                color: _textSec, height: 1.4)),
      ]),
    );
  }

  Widget _buildArtisanList(BuildContext context, List<BusinessStaff> staffList) {
    if (staffList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: _accentLight, shape: BoxShape.circle),
              child: const Icon(Icons.people_outline_rounded, size: 40, color: _accent),
            ),
            const SizedBox(height: 20),
            Text("No staff members yet",
                style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 8),
            Text("Tap the card above to invite your first artisan",
                style: GoogleFonts.inter(fontSize: 14, color: _textSec)),
          ]),
        ),
      );
    }
    return Column(
      children: staffList.map((s) => _buildArtisanCard(context, s)).toList(),
    );
  }

  Widget _buildArtisanCard(BuildContext context, BusinessStaff staff) {
    const int maxCap = 20;
    final int assigned = staff.assignedOrderCount;
    final double factor = (assigned / maxCap).clamp(0.0, 1.0);
    final bool isOver = assigned >= maxCap;
    final String role = staff.service?.serviceName ?? context.staffArtisanUpper;
    final String initial = staff.user.firstName.isNotEmpty
        ? staff.user.firstName.substring(0, 1).toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bgCard, borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x07000000), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(children: [
        Row(children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: _accentLight, borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text(initial,
                  style: GoogleFonts.manrope(color: _accent, fontWeight: FontWeight.w800, fontSize: 20))),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 14, height: 14,
                decoration: BoxDecoration(
                    color: _success, shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5)),
              ),
            ),
          ]),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(staff.user.fullName,
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: _bgChip, borderRadius: BorderRadius.circular(8)),
              child: Text(role.toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700,
                      color: _textSec, letterSpacing: 0.8)),
            ),
          ])),
          const Icon(Icons.chevron_right_rounded, color: _textMuted, size: 22),
        ]),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _bgInner, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderLight),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(context.assignedOrders,
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _textSec)),
              Text('$assigned / $maxCap',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800,
                      color: isOver ? _danger : _textPrimary)),
            ]),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: factor, minHeight: 7,
                backgroundColor: _borderLight,
                valueColor: AlwaysStoppedAnimation<Color>(isOver ? _danger : _accent),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isOver ? context.overCapacity : "${context.capacityLabel} ${(factor * 100).toInt()}%",
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600,
                  color: isOver ? _danger : _textMuted),
            ),
          ]),
        ),
      ]),
    );
  }
}
