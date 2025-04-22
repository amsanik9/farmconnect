import 'package:flutter/material.dart';
import '../../screens/welcome_screen.dart';
import 'orders_screen.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.myProfile),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appLocalizations.editProfile),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            const Divider(),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.green,
            child: Text(
              'RS',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Rahul Sharma',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'rahul.sharma@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '+91 98765 43210',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    '12',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    appLocalizations.orders,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                height: 30,
                child: VerticalDivider(
                  color: Colors.grey[300],
                  thickness: 1,
                  width: 40,
                ),
              ),
              Column(
                children: [
                  const Text(
                    '3',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    appLocalizations.negotiations,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                height: 30,
                child: VerticalDivider(
                  color: Colors.grey[300],
                  thickness: 1,
                  width: 40,
                ),
              ),
              Column(
                children: [
                  const Text(
                    '5',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    appLocalizations.favorites,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.local_shipping_outlined,
            title: appLocalizations.myOrders,
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.location_on_outlined,
            title: appLocalizations.myAddresses,
            onTap: () {
              // Navigate to addresses
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appLocalizations.addressesFeature),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.favorite_border,
            title: appLocalizations.myFavorites,
            onTap: () {
              // Navigate to favorites
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appLocalizations.favoritesFeature),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.payment_outlined,
            title: appLocalizations.paymentMethods,
            onTap: () {
              // Navigate to payment methods
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appLocalizations.paymentMethodsFeature),
                ),
              );
            },
          ),
          const Divider(),
          _buildMenuItem(
            context,
            icon: Icons.help_outline,
            title: appLocalizations.helpAndSupport,
            onTap: () {
              // Navigate to help
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appLocalizations.helpFeature),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: appLocalizations.settings,
            onTap: () {
              // Navigate to settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appLocalizations.settingsFeature),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: appLocalizations.logout,
            textColor: Colors.red,
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(appLocalizations.logout),
                  content: Text(appLocalizations.logoutConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(); // Close dialog
                      },
                      child: Text(appLocalizations.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(); // Close dialog
                        // Navigate to welcome screen and clear all routes
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                          (route) => false, // Remove all routes
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text(appLocalizations.logout),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.grey[800],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}
