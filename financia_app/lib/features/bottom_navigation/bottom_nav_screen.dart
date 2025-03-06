import 'package:financia_app/features/budget/presentation/pages/budget_page.dart';
import 'package:financia_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:financia_app/features/profile/presentation/pages/profile_page.dart';
import 'package:financia_app/features/transaction/presentation/pages/transaction_page.dart';
import 'package:flutter/material.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  // List of pages that correspond to bottom navigation items.
  final List<Widget> _pages = const [
    DashboardPage(),
    TransactionPage(),
    BudgetPage(),
    ProfilePage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: [
          _buildNavItem(Icons.dashboard, 'Dashboard'),
          _buildNavItem(Icons.list_alt, 'Transactions'),
          _buildNavItem(Icons.account_balance_wallet, 'Budgets'),
          _buildNavItem(Icons.person, 'Profile'),
        ],
      ),
    );
  }
}
