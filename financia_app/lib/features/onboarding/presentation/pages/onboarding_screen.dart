import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Record Your Transactions',
      'description':
      'Easily record your daily transactions with a few taps. Track income and expenses seamlessly.',
      'image': 'assets/onboarding1.png',
    },
    {
      'title': 'Visualize Your Finances',
      'description':
      'Get clear insights with line graph visualizations that help you understand your spending patterns.',
      'image': 'assets/onboarding2.png',
    },
    {
      'title': 'Budget Wisely',
      'description':
      'Set monthly budgets and receive alerts when you’re close to your limits. Stay on top of your finances!',
      'image': 'assets/onboarding3.png',
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _goToNextPage() async {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // When the last onboarding screen is reached, set the flag and navigate to login.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingSeen', true);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (data['image'] != null)
                          Image.asset(
                            data['image']!,
                            height: 250,
                          ),
                        const SizedBox(height: 40),
                        Text(
                          data['title'] ?? '',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data['description'] ?? '',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page indicator and Next button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                children: [
                  PageIndicator(
                    itemCount: _onboardingData.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _currentPage == _onboardingData.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
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
}
