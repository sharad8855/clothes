import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _activeFilter = 'All Activity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E3A8A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: Color(0xFF1E3A8A)),
            onPressed: () {},
            tooltip: 'Mark all as read',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilterPills(),
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPills() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F9FC),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            _buildPill('All Activity'),
            const SizedBox(width: 12),
            _buildPill('Orders'),
            const SizedBox(width: 12),
            _buildPill('Action Required'),
            const SizedBox(width: 12),
            _buildPill('Staff'),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String text) {
    final bool isActive = _activeFilter == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final List<Map<String, dynamic>> notifications = [
      {
        'id': '1',
        'type': 'order_ready',
        'title': 'Fitting Complete',
        'message': 'Julian Thorne updated the status of Order #ORD-8845 to Ready for final fitting.',
        'time': '12m ago',
        'isUnread': true,
      },
      {
        'id': '2',
        'type': 'supply_insight',
        'title': 'AI Supply Alert',
        'message': 'High demand for Navy Italian Wool. Recommend ordering 50m to avoid stockouts this month.',
        'time': '1h ago',
        'isUnread': true,
      },
      {
        'id': '3',
        'type': 'client_message',
        'title': 'Message from Elena Rossi',
        'message': '"Can we adjust the hemline by half an inch?"',
        'time': '3h ago',
        'isUnread': false,
        'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80',
      },
      {
        'id': '4',
        'type': 'payment_success',
        'title': 'Payment Received',
        'message': 'Marcus Vane paid \$3,120.00 for Bespoke Suit package.',
        'time': 'Yesterday',
        'isUnread': false,
      },
    ];

    // Filter logic
    final filtered = notifications.where((n) {
      if (_activeFilter == 'All Activity') return true;
      if (_activeFilter == 'Orders') {
        return n['type'] == 'order_ready' || n['type'] == 'payment_success';
      }
      if (_activeFilter == 'Action Required') {
        return n['type'] == 'supply_insight' || n['type'] == 'client_message';
      }
      if (_activeFilter == 'Staff') {
        // No mock data for staff yet, but logic is ready
        return n['type'] == 'staff_alert';
      }
      return true;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No notifications for this filter.',
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final notif = filtered[index];
        final bool isUnread = notif['isUnread'] as bool;

        Widget leadingItem;
        if (notif['avatar'] != null) {
          leadingItem = CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(notif['avatar'] as String),
          );
        } else {
          Color iconBg;
          Color iconColor;
          IconData iconData;

          switch (notif['type']) {
            case 'order_ready':
              iconBg = const Color(0xFFD1FAE5);
              iconColor = const Color(0xFF10B981);
              iconData = Icons.inventory_2_rounded;
              break;
            case 'supply_insight':
              iconBg = const Color(0xFFF3E8FF);
              iconColor = const Color(0xFF7C3AED);
              iconData = Icons.auto_awesome_rounded;
              break;
            case 'payment_success':
              iconBg = const Color(0xFFE0E7FF);
              iconColor = const Color(0xFF4F46E5);
              iconData = Icons.payments_rounded;
              break;
            default:
              iconBg = const Color(0xFFE2E8F0);
              iconColor = const Color(0xFF64748B);
              iconData = Icons.notifications_rounded;
          }

          leadingItem = Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 22),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnread ? const Color(0xFFF1F5F9) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnread ? const Color(0xFFE2E8F0) : Colors.transparent,
              width: 1,
            ),
            boxShadow: isUnread
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leadingItem,
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notif['title'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          notif['time'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif['message'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                    if (notif['type'] == 'supply_insight') ...[
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF7C3AED),
                          side: const BorderSide(color: Color(0xFF7C3AED)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Review Suggestion',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ] else if (notif['type'] == 'client_message') ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1E3A8A),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Reply to client',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isUnread) ...[
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
