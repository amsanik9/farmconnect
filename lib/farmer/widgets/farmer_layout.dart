import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/products_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/profiles_screen.dart';

class FarmerLayout extends StatefulWidget {
  static const routeName = '/farmer-layout';

  const FarmerLayout({Key? key}) : super(key: key);

  @override
  State<FarmerLayout> createState() => _FarmerLayoutState();
}

class _FarmerLayoutState extends State<FarmerLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProductsScreen(),
    const OrdersScreen(),
    ProfileScreen(), // Profile Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
