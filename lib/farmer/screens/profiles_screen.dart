import 'package:flutter/material.dart';
import 'package:farmconnect/screens/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String farmName;
  final String farmerName;
  final String address;
  final String kissanId;
  final String? profileImageUrl;

  const ProfileScreen({
    Key? key,
    this.farmName = '',
    this.farmerName = '',
    this.address = '',
    this.kissanId = '',
    this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile screen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Farm Name', farmName),
            _buildInfoRow('Farmer Name', farmerName),
            _buildInfoRow('Address', address),
            _buildInfoRow('Kissan ID', kissanId),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WelcomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
