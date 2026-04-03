import 'package:flutter/material.dart';

enum ClientTier { vip, premium, standard }

class ClientListModel {
  final String id;
  final String fullName;
  final String phone;
  final ClientTier tier;
  final String lastOrderName;
  final String clientSince;
  final int totalOrders;
  final double lifetimeValue;
  final String tailorNote;
  final Map<String, double> measurements;

  ClientListModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.tier,
    required this.lastOrderName,
    required this.clientSince,
    required this.totalOrders,
    required this.lifetimeValue,
    required this.tailorNote,
    required this.measurements,
  });

  String get initials {
    List<String> parts = fullName.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }
}

class ClientsProvider extends ChangeNotifier {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final List<ClientListModel> _allClients = [
    ClientListModel(
      id: 'c1',
      fullName: 'Julian Anderson',
      phone: '+1 (555) 012-3456',
      tier: ClientTier.vip,
      lastOrderName: 'Navy Double-Breasted Suit',
      clientSince: 'Executive Client Since 2021',
      totalOrders: 24,
      lifetimeValue: 12450.0,
      tailorNote: 'Prefers Italian slim-cut silhouettes.\nAlways specify functional cuff buttons and midnight blue linings.',
      measurements: {
        'Chest': 42.5,
        'Waist': 34.0,
        'Sleeve': 35.0,
        'Neck': 16.5,
        'Shoulder': 19.2,
        'Inseam': 32.0,
      },
    ),
    ClientListModel(
      id: 'c2',
      fullName: 'Sophia Chen',
      phone: '+1 (555) 987-6543',
      tier: ClientTier.premium,
      lastOrderName: 'Silk Evening Gown Alteration',
      clientSince: 'Premium Client Since 2022',
      totalOrders: 12,
      lifetimeValue: 4850.0,
      tailorNote: 'Requires extra care on delicate fabrics.',
      measurements: {
        'Bust': 36.0,
        'Waist': 28.5,
        'Hips': 38.0,
        'Shoulder': 15.5,
        'Length': 58.0,
      },
    ),
    ClientListModel(
      id: 'c3',
      fullName: 'Marcus Rodriguez',
      phone: '+1 (555) 234-5678',
      tier: ClientTier.standard,
      lastOrderName: 'Linen Summer Blazer',
      clientSince: 'Client Since March 2023',
      totalOrders: 3,
      lifetimeValue: 850.0,
      tailorNote: 'Prefers relaxed fit for casual wear.',
      measurements: {
        'Chest': 40.0,
        'Waist': 34.0,
        'Sleeve': 34.0,
        'Neck': 16.0,
        'Shoulder': 18.5,
        'Inseam': 30.0,
      },
    ),
  ];

  List<ClientListModel> get filteredClients {
    if (_searchQuery.isEmpty) return _allClients;
    final lowerQuery = _searchQuery.toLowerCase();
    return _allClients.where((client) {
      return client.fullName.toLowerCase().contains(lowerQuery) ||
             client.phone.contains(lowerQuery);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
