import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/order_management_provider.dart';
import '../../models/order_list_response.dart';
import '../shell/widgets/app_drawer.dart';
import 'order_details_screen.dart';
import '../../providers/profile_provider.dart';
import '../profile/profile_screen.dart';
import '../../utils/localization/localization_extension.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderManagementProvider>().fetchOrders(refresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<OrderManagementProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      drawer: const AppDrawer(),
      appBar: _buildAppBar(),
      body: Consumer<OrderManagementProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchOrders(refresh: true),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildPageHeader(provider),
                        const SizedBox(height: 20),
                        _buildSearchBar(provider),
                        const SizedBox(height: 24),
                        if (provider.isLoading && provider.orders.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                            ),
                          )
                        else
                          _buildOrderListSection(provider),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
        context.bespokeAtelier,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1E3A8A),
        ),
      ),

    );
  }

  Widget _buildPageHeader(OrderManagementProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.productionLabel,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF8B5CF6),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.ordersTitle,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            if (provider.totalCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  context.totalCountLabel.replaceAll('{count}', '${provider.totalCount}'),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(OrderManagementProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (val) {
                      provider.setSearchQuery(val);
                      setState(() {});
                    },
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      hintText: context.searchCustomerOrId,
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      provider.setSearchQuery('');
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        PopupMenuButton<String>(
          offset: const Offset(0, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (String result) {
            provider.setStatusFilter(result);
            setState(() {});
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'All',
              child: Text('All'),
            ),
            PopupMenuItem<String>(
              value: 'Pending',
              child: Text(context.pendingLabel),
            ),
            const PopupMenuItem<String>(
              value: 'Confirmed',
              child: Text('Confirmed'),
            ),
            const PopupMenuItem<String>(
              value: 'Ready',
              child: Text('Ready'),
            ),
            PopupMenuItem<String>(
              value: 'Delivered',
              child: Text(context.deliveredLabel),
            ),
          ],
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: provider.selectedStatusFilter != 'All' 
                  ? const Color(0xFF1E3A8A) 
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.filter_list_rounded,
              color: provider.selectedStatusFilter != 'All'
                  ? Colors.white
                  : const Color(0xFF1E3A8A),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderListSection(OrderManagementProvider provider) {
    final orders = provider.filteredOrders;
    
    if (orders.isEmpty && !provider.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              const Icon(Icons.receipt_long_outlined, size: 64, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 16),
              Text(
                context.noOrdersFound,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildOrderCard(orders[index]),
            );
          },
        ),
        if (provider.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderCard(OrderListItem order) {
    final provider = context.read<OrderManagementProvider>();
    final statusText = provider.statusLabel(order.orderStatus);
    final statusTextColor = provider.statusColor(order.orderStatus);
    final statusBgColor = provider.statusBgColor(order.orderStatus);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(orderId: order.orderId),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    order.garmentIcon,
                    color: const Color(0xFF1E1B4B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Name and Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order.customerName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusText.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: statusTextColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${context.invPrefix} ${order.billNumber}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Bottom Info Row
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.firstItemName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(order.orderDate),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Created By Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_pin_rounded,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.createdBy,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${order.createdByUser.firstName} ${order.createdByUser.lastName}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${order.grandTotal}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple format: Apr 03, 2026
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }
}
