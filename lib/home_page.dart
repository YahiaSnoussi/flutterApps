import 'package:flutter/material.dart';
import 'consultation_page.dart';
import 'adhkar_predifinis_page.dart';
import 'add_dhikr_dialog.dart';
import 'quranpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Map<String, dynamic>> _dhikrs = [];

  final List<Map<String, dynamic>> _predefinedDhikrs = [
    {'text': 'الله أكبر', 'count': 34, 'description': 'Takbir'},
    {'text': 'سبحان الله', 'count': 33, 'description': 'Tasbih'},
    {'text': 'الحمد لله', 'count': 33, 'description': 'Praise to Allah'},
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _addDhikr() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDhikrDialog(onAddDhikr: _onAddDhikr);
      },
    );
  }

  void _onAddDhikr(Map<String, dynamic> dhikr) {
    setState(() {
      _dhikrs.add(dhikr);
    });
  }

  void _consultDhikr() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsultationPage(dhikrs: _dhikrs),
      ),
    );
  }

  void _consultAdhkarPredifinis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdhkarPredifinisPage(dhikrs: _predefinedDhikrs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Center(child: Text(widget.title)),
      ),
      endDrawer: AppDrawer(
        onAddDhikr: _addDhikr,
        onConsultDhikr: _consultDhikr,
        onConsultPredefined: _consultAdhkarPredifinis,
      ),
      body: _buildDefaultScreen(),
    );
  }

  Widget _buildDefaultScreen() {
    return GestureDetector(
      onTap: _incrementCounter,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'سنية انت الان في الذكر عدد',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 245, 91, 178),
                child: Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                      ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _resetCounter,
                    backgroundColor: const Color.fromARGB(255, 52, 148, 195),
                    child: const Icon(Icons.loop),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _incrementCounter,
                    backgroundColor: const Color.fromARGB(255, 245, 91, 178),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final VoidCallback onAddDhikr;
  final VoidCallback onConsultDhikr;
  final VoidCallback onConsultPredefined;

  const AppDrawer({
    required this.onAddDhikr,
    required this.onConsultDhikr,
    required this.onConsultPredefined,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 245, 91, 178),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
                const Text(
                  'قائمة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text(' اضافة ذكر ( مؤقت )'),
            onTap: onAddDhikr,
          ),
          ListTile(
            title: const Text(' أذكاري المؤقتة'),
            onTap: onConsultDhikr,
          ),
          ListTile(
            title: const Text('القرآن الكريم'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuranPage()),
              );
            },
          ),
          ListTile(
            title: const Text('أذكار أخرى'),
            onTap: onConsultPredefined,
          ),
        ],
      ),
    );
  }
}
