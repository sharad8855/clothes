import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../providers/home_provider.dart';
import '../home/home_screen.dart';
import '../orders/order_management_screen.dart';
import '../customers/customers_screen.dart';
import '../staff/staff_management_screen.dart';
import '../gallery/gallery_screen.dart';

import '../../providers/business_provider.dart';
import '../../providers/order_management_provider.dart';
import '../../providers/clients_provider.dart';
import '../../utils/localization/localization_extension.dart';

/// MainShell is the single Scaffold that owns the app's bottom navigation bar.
/// All top-level screens (Home, Orders, Customers, Staff, Profile) render
/// inside its body via IndexedStack — never as separate pushed routes.
class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String? _lastBusinessId;

  @override
  void initState() {
    super.initState();
    _lastBusinessId = context.read<BusinessProvider>().selectedBusiness?.id;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().setNavIndex(widget.initialIndex);
    });
  }

  void _handleBusinessChange() {
    final currentBusinessId = context.read<BusinessProvider>().selectedBusiness?.id;
    if (currentBusinessId != _lastBusinessId) {
      _lastBusinessId = currentBusinessId;
      // Trigger global refresh
      context.read<HomeProvider>().refresh();
      context.read<OrderManagementProvider>().fetchOrders(refresh: true);
      context.read<ClientsProvider>().fetchCustomers(refresh: true);
    }
  }

  void _onTabTapped(int index) {
    context.read<HomeProvider>().setNavIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for business change
    _handleBusinessChange();
    
    final effectiveIndex = context.watch<HomeProvider>().selectedNavIndex;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: IndexedStack(
        index: effectiveIndex,
        children: const [
          HomeScreen(),
          OrderManagementScreen(),
          CustomersScreen(),
          StaffManagementScreen(),
          GalleryScreen(),
        ],
      ),
      bottomNavigationBar: _ShellBottomNav(
        currentIndex: effectiveIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// ─── Bottom Navigation Bar ─────────────────────────────────────────────────

class _ShellBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ShellBottomNav({required this.currentIndex, required this.onTap});

  List<_NavDef> _items(BuildContext context) => [
    _NavDef(
      icon: Icons.dashboard_rounded,
      outlined: Icons.dashboard_outlined,
      label: context.navHome,
    ),
    _NavDef(
      icon: Icons.receipt_long_rounded,
      outlined: Icons.receipt_long_outlined,
      label: context.navOrders,
    ),
    _NavDef(
      icon: Icons.people_rounded,
      outlined: Icons.people_outline_rounded,
      label: context.navCustomers,
    ),
    _NavDef(
      icon: Icons.person_pin_circle_rounded,
      outlined: Icons.person_pin_circle_outlined,
      label: context.navStaff,
    ),
    _NavDef(
      icon: Icons.photo_library_rounded,
      outlined: Icons.photo_library_outlined,
      label: context.navGallery,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items(context).length, (i) {
              final item = _items(context)[i];
              final isSelected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF0F5FF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.icon : item.outlined,
                        color: isSelected
                            ? const Color(0xFF6366F1)
                            : const Color(0xFFA1A1AA),
                        size: 22,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFA1A1AA),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavDef {
  final IconData icon;
  final IconData outlined;
  final String label;
  const _NavDef({
    required this.icon,
    required this.outlined,
    required this.label,
  });
}
