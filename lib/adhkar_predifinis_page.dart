import 'package:flutter/material.dart';
import 'swipe_adhkar_page.dart';

class AdhkarPredifinisPage extends StatelessWidget {
  final List<Map<String, dynamic>> dhikrs;

  const AdhkarPredifinisPage({super.key, required this.dhikrs});

  void _navigateToSwipePage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SwipeAdhkarPage(dhikrs: dhikrs, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أذكار أخرى'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // Set right-to-left direction
        child: ListView.builder(
          itemCount: dhikrs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                dhikrs[index]['text'],
                textAlign: TextAlign.right, // Align text to the right
              ),
              subtitle: Text(
                dhikrs[index]['description'],
                textAlign: TextAlign.right, // Align text to the right
              ),
              onTap: () => _navigateToSwipePage(context, index),
            );
          },
        ),
      ),
    );
  }
}
