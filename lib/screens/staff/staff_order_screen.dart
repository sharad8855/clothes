import 'package:flutter/material.dart';

class StaffOrderScreen extends StatelessWidget {
  const StaffOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Orders'),
      ),
      body: const Center(
        child: Text('Staff Order Screen'),
      ),
    );
  }
}
