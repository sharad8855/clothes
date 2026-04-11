import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/login_provider.dart';
import '../../providers/profile_provider.dart';
import '../login/login_screen.dart';
import '../staff/staff_order_screen.dart';
class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F5), // Stitch surface_container_low
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                Consumer<ProfileProvider>(
                  builder: (context, profile, _) {
                    final name = profile.userProfile?.firstName ?? 'Julian';
                    return _buildSectionTitle('QUEUE OVERVIEW', 'Active Tasks for $name');
                  },
                ),
                const SizedBox(height: 20),
                _buildSearchAndFilter(),
                const SizedBox(height: 24),
                _buildSummaryGrid(),
                const SizedBox(height: 24),
                _buildTaskList(),
                const SizedBox(height: 24),
                _buildAIAssistant(),
                const SizedBox(height: 24),
                _buildFabricAvailability(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6200EE), // Stitch primary_container
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.auto_awesome, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Color(0xFF191C1D)),
          offset: const Offset(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          onSelected: (value) {
            if (value == 'logout') {
              _handleLogout(context);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, color: Color(0xFFD50000), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Log Out',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD50000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          'Staff\nPortal',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF191C1D),
            height: 1.1,
          ),
        ),
        const Spacer(),
        const Icon(Icons.search, color: Color(0xFF494456)),
        const SizedBox(width: 16),
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFE1E3E4),
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String subtitle, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6200EE),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF191C1D),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF191C1D).withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search orders...',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF7A7488),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF7A7488), size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF191C1D).withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.filter_list, color: Color(0xFF494456), size: 18),
              const SizedBox(width: 8),
              Text(
                'Priority',
                style: GoogleFonts.inter(
                  color: const Color(0xFF191C1D),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        _buildSummaryCard(Icons.inbox_outlined, '12', 'TOTAL TASKS', const Color(0xFF191C1D)),
        _buildSummaryCard(Icons.content_cut, '05', 'CUTTING STAGE', const Color(0xFF6200EE)),
        _buildSummaryCard(Icons.priority_high, '02', 'HIGH PRIORITY', const Color(0xFFD50000)),
        _buildSummaryCard(Icons.check_circle_outline, '08', 'COMPLETED', const Color(0xFF00C853)),
      ],
    );
  }

  Widget _buildSummaryCard(IconData icon, String count, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF191C1D).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF191C1D),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF494456),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Column(
      children: [
        _buildTaskCard(
          icon: Icons.checkroom,
          iconBgColor: const Color(0xFFCFBDFF).withOpacity(0.3),
          iconColor: const Color(0xFF4800B2),
          orderId: 'ORD-0021',
          priority: 'HIGH PRIORITY',
          priorityColor: const Color(0xFFFFFFFF),
          priorityBgColor: const Color(0xFFAC0000), // tertiary_container
          title: 'Navy Silk-Wool Tuxedo',
          client: 'Alexander Thorne',
          badgeText: 'CUTTING',
          badgeColor: const Color(0xFFE8DDFF),
          badgeTextColor: const Color(0xFF22005D),
          dueTime: 'Today, 12:00',
        ),
        const SizedBox(height: 16),
        _buildTaskCard(
          icon: Icons.layers_outlined,
          iconBgColor: const Color(0xFFE1E3E4),
          iconColor: const Color(0xFF494456),
          orderId: 'ORD-0031',
          priority: '',
          priorityColor: Colors.transparent,
          priorityBgColor: Colors.transparent,
          title: 'Herringbone Tweed Overcoat',
          client: 'Marcus Sterling',
          badgeText: 'MEASUREMENT CHECK',
          badgeColor: const Color(0xFFE7E8E9),
          badgeTextColor: const Color(0xFF191C1D),
          dueTime: 'Oct 24',
        ),
        const SizedBox(height: 16),
        _buildTaskCard(
          icon: Icons.accessibility_new_rounded,
          iconBgColor: const Color(0xFFCFBDFF).withOpacity(0.3),
          iconColor: const Color(0xFF6200EE),
          orderId: 'ORD-0038',
          priority: '',
          priorityColor: Colors.transparent,
          priorityBgColor: Colors.transparent,
          title: 'White Egyptian Cotton Shirt',
          client: 'Gregory Vance',
          badgeText: 'PATTERN PREP',
          badgeColor: const Color(0xFFE8DDFF),
          badgeTextColor: const Color(0xFF22005D),
          dueTime: 'Tomorrow',
        ),
      ],
    );
  }

  Widget _buildTaskCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String orderId,
    required String priority,
    required Color priorityColor,
    required Color priorityBgColor,
    required String title,
    required String client,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String dueTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF191C1D).withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                orderId,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF494456),
                ),
              ),
              if (priority.isNotEmpty) ...[
                const SizedBox(width: 8),
                const Text('•', style: TextStyle(color: Color(0xFFCBC3D9))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    priority,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: priorityColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF191C1D),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Client: $client',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF7A7488),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                'Due: $dueTime',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF494456),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIAssistant() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCFBDFF).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6200EE).withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF6200EE), size: 20),
              const SizedBox(width: 8),
              Text(
                'AI Efficiency Suggest',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF191C1D),
                ),
              ),
              const Spacer(),
              const Icon(Icons.auto_awesome_outlined, color: Color(0xFFCFBDFF), size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Batch cutting for ORD-0042 and ORD-0050 is recommended. Both use similar weight interfacing.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF494456),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF4800B2), Color(0xFF6200EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Optimize Workflow',
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

  Widget _buildFabricAvailability() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF191C1D).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fabric Availability',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF191C1D),
            ),
          ),
          const SizedBox(height: 24),
          _buildFabricRow('Navy Silk (120s)', 'IN STOCK', const Color(0xFF00732C), 0.85, const Color(0xFF00C853)),
          const SizedBox(height: 20),
          _buildFabricRow('Tweed (Harris)', 'LOW STOCK', const Color(0xFFFFFFFF), 0.2, const Color(0xFFD50000), badgeBg: const Color(0xFFAC0000)),
        ],
      ),
    );
  }

  Widget _buildFabricRow(String name, String status, Color statusColor, double progress, Color progressColor, {Color? badgeBg}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF191C1D),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg ?? Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: statusColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFFEDEEEF),
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF191C1D).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6200EE),
        unselectedItemColor: const Color(0xFF7A7488),
        selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, height: 1.5),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, height: 1.5),
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffOrderScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 6, top: 8), child: Icon(Icons.inbox)),
            label: 'TASKS',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 6, top: 8), child: Icon(Icons.receipt_long_outlined)),
            label: 'ORDERS',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 6, top: 8), child: Icon(Icons.inventory_2_outlined)),
            label: 'INVENTORY',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 6, top: 8), child: Icon(Icons.chat_bubble_outline)),
            label: 'CHAT',
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final loginProvider = context.read<LoginProvider>();
    await loginProvider.logout();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
