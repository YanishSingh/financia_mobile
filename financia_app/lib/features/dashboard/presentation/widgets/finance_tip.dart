import 'dart:async';

import 'package:flutter/material.dart';

class FinanceTip extends StatefulWidget {
  const FinanceTip({super.key});

  @override
  State<FinanceTip> createState() => _FinanceTipState();
}

class _FinanceTipState extends State<FinanceTip> {
  final List<String> tips = [
    "Save at least 20% of your income every month.",
    "Track your daily expenses to understand your spending habits.",
    "Invest in diversified assets for long-term growth.",
    "Create a realistic budget and stick to it.",
    "Avoid impulse purchases—wait 24 hours before buying.",
    "Maintain an emergency fund for unexpected expenses.",
    "Review subscriptions and cancel unused ones.",
    "Plan your retirement early for better financial security.",
    "Use cash instead of credit to prevent overspending.",
    "Regularly review and adjust your budget."
  ];
  String currentTip = "Loading tip...";
  Timer? tipTimer;

  @override
  void initState() {
    super.initState();
    _updateTip();
    tipTimer = Timer.periodic(const Duration(minutes: 2), (_) => _updateTip());
  }

  void _updateTip() {
    setState(() {
      currentTip = tips[DateTime.now().millisecondsSinceEpoch % tips.length];
    });
  }

  @override
  void dispose() {
    tipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.deepPurpleAccent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lightbulb, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Finance Tip: $currentTip',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
