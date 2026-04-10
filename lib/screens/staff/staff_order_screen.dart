import 'package:flutter/material.dart';

class StaffOrderScreen extends StatelessWidget {
  const StaffOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F1741)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Order #ORD-8824',
              style: TextStyle(
                color: Color(0xFF0F1741),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'BESPOKE NAVY THREE-PIECE SUIT',
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, color: Color(0xFF9E9E9E)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductionStageCard(),
            const SizedBox(height: 16),
            _buildWorkshopCommentsCard(),
            const SizedBox(height: 16),
            _buildCustomerDetailsCard(),
            const SizedBox(height: 16),
            _buildAISuggestCard(),
            const SizedBox(height: 16),
            _buildOrderHistoryCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildProductionStageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Production',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F1741),
                      ),
                    ),
                    Text(
                      'Stage',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F1741),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'IN PROGRESS',
                  style: TextStyle(
                    color: Color(0xFF3730A3),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildStepperBar(),
        ],
      ),
    );
  }

  Widget _buildStepperBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        return SizedBox(
          height: 80,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 16,
                left: 20,
                right: 20,
                child: Container(height: 2, color: const Color(0xFFEEEEEE)),
              ),
              Positioned(
                top: 16,
                left: 20,
                child: Container(
                  height: 2,
                  width: (width > 40) ? (width - 40) * 0.4 : 0,
                  color: const Color(0xFF0F1741),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep(label: 'Measurement', state: 2, icon: Icons.check),
                  _buildStep(label: 'Fabric', state: 2, icon: Icons.check),
                  _buildStep(
                    label: 'Cutting',
                    state: 1,
                    icon: Icons.content_cut,
                  ),
                  _buildStep(
                    label: 'Stitching',
                    state: 0,
                    icon: Icons.linear_scale,
                  ),
                  _buildStep(label: 'Fitting', state: 0, icon: Icons.person),
                  _buildStep(label: 'Ready', state: 0, icon: Icons.all_inbox),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep({
    required String label,
    required int state,
    required IconData icon,
  }) {
    Color bgColor;
    Color borderColor;
    Widget childIcon;
    Color textColor;

    if (state == 2) {
      bgColor = const Color(0xFF0F1741);
      borderColor = Colors.transparent;
      childIcon = const Icon(Icons.check, color: Colors.white, size: 16);
      textColor = const Color(0xFF0F1741);
    } else if (state == 1) {
      bgColor = Colors.white;
      borderColor = const Color(0xFF8B5CF6);
      childIcon = Icon(icon, color: const Color(0xFF8B5CF6), size: 16);
      textColor = const Color(0xFF8B5CF6);
    } else {
      bgColor = const Color(0xFFEEEEEE);
      borderColor = Colors.transparent;
      childIcon = Icon(icon, color: const Color(0xFF9E9E9E), size: 16);
      textColor = const Color(0xFF9E9E9E);
    }

    return SizedBox(
      width: 48,
      child: Column(
        children: [
          Container(
            width: state == 1 ? 40 : 32,
            height: state == 1 ? 40 : 32,
            decoration: BoxDecoration(
              color: state == 1 ? const Color(0x1A8B5CF6) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: childIcon,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: state == 1 ? FontWeight.bold : FontWeight.w600,
              color: textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopCommentsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.notes, color: Color(0xFF8B5CF6)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Workshop Comments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F1741),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Describe progress, fabric nuances, or adjustments for the stitching team...',
                hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('Fabric arrived'),
              _buildChip('Pattern completed'),
              _buildChip('Minor delay: Thread supply'),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F1741),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Update & Notify Manager',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.send, color: Colors.white, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Notifications will be sent to the Lead Manager\nand the Client via the Royal Stitch App.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF0F1741),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCustomerDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Arthur Sterling',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F1741),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Premium Member • Gold Class',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow(
            'Deadline',
            'Oct 24, 2023 (5 days left)',
            const Color(0xFFD32F2F),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Fabric',
            'Loro Piana Navy Silk-Wool',
            const Color(0xFF0F1741),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Lining',
            'Royal Purple Bemberg',
            const Color(0xFF0F1741),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.remove_red_eye,
                size: 16,
                color: Color(0xFF0F1741),
              ),
              label: const Text(
                'View Full Measurement Profile',
                style: TextStyle(
                  color: Color(0xFF0F1741),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAISuggestCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI WORKSHOP SUGGEST',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Based on the fabric weight (320g), we recommend a 48-hour hang-time post-cutting to ensure drape stability before first stitching.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0x40FFFFFF),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Accept Adjustment',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F1741),
            ),
          ),
          const SizedBox(height: 20),
          _buildHistoryItem(
            time: 'Today, 09:15 AM',
            description: 'Fabric inspection completed by Marcus.',
            isFirst: true,
          ),
          _buildHistoryItem(
            time: 'Oct 18, 02:30 PM',
            description: 'Initial measurements verified.',
            isFirst: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String time,
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 3,
            height: 35,
            color: isFirst ? const Color(0xFF8B5CF6) : const Color(0xFFE0E0E0),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isFirst
                        ? const Color(0xFF0F1741)
                        : const Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isFirst ? Colors.black87 : const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.assignment,
            label: 'TASKS',
            isActive: false,
          ),
          _buildNavItem(
            icon: Icons.shopping_bag,
            label: 'ORDERS',
            isActive: true,
          ),
          _buildNavItem(
            icon: Icons.all_inbox,
            label: 'INVENTORY',
            isActive: false,
          ),
          _buildNavItem(
            icon: Icons.chat_bubble,
            label: 'CHAT',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF3730A3), size: 20),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Icon(icon, color: const Color(0xFFBDBDBD), size: 24),
          ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFF3730A3) : const Color(0xFFBDBDBD),
          ),
        ),
      ],
    );
  }
}
