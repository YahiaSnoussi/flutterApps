import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'swipe_dhikr_page.dart';

class ConsultationPage extends StatefulWidget {
  final List<Map<String, dynamic>> dhikrs;

  const ConsultationPage({super.key, required this.dhikrs});

  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  List<Map<String, dynamic>> _dhikrs = [];

  @override
  void initState() {
    super.initState();
    _loadDhikrs();
  }

  Future<void> _loadDhikrs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dhikrsString = prefs.getString('dhikrs');
    if (dhikrsString != null) {
      setState(() {
        _dhikrs = List<Map<String, dynamic>>.from(jsonDecode(dhikrsString));
      });
    } else {
      // If no saved dhikrs, use the ones passed from the widget.
      setState(() {
        _dhikrs = widget.dhikrs;
      });
    }
  }

  Future<void> _saveDhikrs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dhikrsString = jsonEncode(_dhikrs);
    await prefs.setString('dhikrs', dhikrsString);
  }

  void _deleteDhikr(int index) {
    setState(() {
      _dhikrs.removeAt(index);
      _saveDhikrs(); // Save updated dhikrs to local storage
    });
  }

  void _navigateToSwipePage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SwipeDhikrPage(dhikrs: _dhikrs, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أذكاري'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // Set right-to-left direction
        child: ListView.builder(
          itemCount: _dhikrs.length,
          itemBuilder: (context, index) {
            return ListTile(
              subtitle: Text(
                _dhikrs[index]['text'],
                textAlign: TextAlign.right, // Align text to the right
              ),
              title: Text(
                _dhikrs[index]['description'],
                textAlign: TextAlign.right, // Align text to the right
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
                onPressed: () => _deleteDhikr(index),
              ),
              onTap: () => _navigateToSwipePage(context, index),
            );
          },
        ),
      ),
    );
  }
}
