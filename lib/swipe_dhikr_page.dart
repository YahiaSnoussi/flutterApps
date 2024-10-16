import 'package:flutter/material.dart';
import 'dhikr_detail_page.dart';

class SwipeDhikrPage extends StatelessWidget {
  final List<Map<String, dynamic>> dhikrs;
  final int initialIndex;

  const SwipeDhikrPage({super.key, required this.dhikrs, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    // Calculate the reverse index
    int reverseIndex = dhikrs.length - 1 - initialIndex;

    return Scaffold(
      body: PageView.builder(
        itemCount: dhikrs.length,
        itemBuilder: (context, index) {
          // Calculate the actual index in the reversed order
          int actualIndex = dhikrs.length - 1 - index;
          return DhikrDetailPage(dhikr: dhikrs[actualIndex]);
        },
        controller: PageController(initialPage: reverseIndex), // Set the initial page to the reversed index
      ),
    );
  }
}
