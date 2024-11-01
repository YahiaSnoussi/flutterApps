import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final TextEditingController _nameController = TextEditingController();
  String? _savedName;

  @override
  void initState() {
    super.initState();
    _loadSavedName();
  }

  Future<void> _loadSavedName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('name');
    });

    // If name is already saved, navigate to home page
    if (_savedName != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
Future<void> _saveName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (_nameController.text.isNotEmpty) {
    await prefs.setString('name', _nameController.text);
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    // Show an AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('خطأ'),
          content: Text('إذا لا تريد إدخال إسمك إضغط على زر لا أريد .'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('حسنا'),
            ),
          ],
        );
      },
    );
  }
}

  Future<void> _saveNameNull() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', '');
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Center everything in the body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers everything vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Centers everything horizontally
            children: [
              Image.asset(
                'assets/logo.png', // Your logo image path
                width: 250, // Adjust the size of the image
                height: 250,
              ),
              const SizedBox(height: 30),
              const Text(
                'سجل إسمك و إربح دعوة يوميا',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                
                textAlign: TextAlign.center, // Center the title text
              ),
              const Text(
                '(اختياري)',
                style: TextStyle(
                  fontSize: 15,
                ),
                
                textAlign: TextAlign.center, // Center the title text
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250, // Make the input box smaller by setting its width
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center, // Center the text in the input field
                  decoration: const InputDecoration(
                    labelText: 'الاسم واللقب',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveName,
                child: const Text('تسجيل الاسم'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10), // Customize button size
                  textStyle: const TextStyle(fontSize: 18), // Increase button text size
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNameNull,
                child: const Text('لا اريد'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10), // Customize button size
                  textStyle: const TextStyle(fontSize: 18), // Increase button text size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
