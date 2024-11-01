import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:tasbih/PrayerTimes.dart';
import 'consultation_page.dart';
import 'adhkar_predifinis_page.dart';
import 'add_dhikr_dialog.dart';
import 'quranpage.dart';
import 'Prayer_times.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  PrayerTimes? _prayerTimes;
bool _isLoading = true;
  List<Map<String, dynamic>> _dhikrs = [];
  String _userName = '';

  final List<Map<String, dynamic>> _predefinedDhikrs = [
    {'text': 'الله أكبر', 'count': 34, 'description': 'تكبير'},
    {'text': 'سبحان الله', 'count': 33, 'description': 'تسبيح'},
    {'text': 'الحمد لله', 'count': 33, 'description': 'شكر الله'},
    {'text': 'استغفر الله العظيم و اتوب اليه', 'count': 70, 'description': 'استغفار'},
    {'text': 'أشهد أن لا إله إلا الله وحده لا شريك له', 'count': 100, 'description': 'تشهد'},
    {'text': 'اللهم صل على محمد وعلى آل محمد', 'count': 100, 'description': 'صلاة على النبي'},
    {'text': 'اللهم إني أسألك الجنة وأعوذ بك من النار', 'count': 10, 'description': 'دعاء للجنة'},
    {'text': 'لا إله إلا الله', 'count': 100, 'description': 'تهليل'},
    {'text': 'اللهم إني أسألك رزقاً طيباً', 'count': 33, 'description': 'دعاء الرزق'},
    {'text': 'أصبحنا وأصبح الملك لله', 'count': 10, 'description': 'دعاء الصباح'},
    {'text': 'اللهم اشفني شفاءً لا يغادر سقماً', 'count': 33, 'description': 'دعاء الشفاء'},
    {'text': 'بسم الله، توكلت على الله، ولا حول ولا قوة إلا بالله', 'count': 7, 'description': 'دعاء الخروج من المنزل'},
    {'text': 'اللهم افتح لي أبواب رحمتك', 'count': 1, 'description': 'دعاء دخول المسجد'},
    {'text': 'أعوذ بكلمات الله التامات من شر ما خلق', 'count': 33, 'description': 'دعاء الحفظ'},
    {'text': 'اللهم اجعل لي في هذا العمل نجاحاً', 'count': 33, 'description': 'دعاء النجاح'},
    {'text': 'اللهم ارحمنا واغفر لنا وارزقنا', 'count': 33, 'description': 'دعاء القنوت'},
    {'text': 'سبحان الذي سخر لنا هذا وما كنا له مقرنين', 'count': 1, 'description': 'دعاء السفر'},
    {'text': 'اللهم أعز الإسلام والمسلمين وأذل الشرك والمشركين ودمر أعداء الدين وانصر عبادك الموحدين واجعل اللهم بلاد الإسلام آمنه مطمئنة يارب العالمين', 'count': 33, 'description': 'طلب النصر'},
  ];

 @override
void initState() {
  super.initState();
  _loadDhikrs();
  _loadUserName();
  _fetchPrayerTimes(); // Fetch prayer times on startup
}

Future<void> _fetchPrayerTimes() async {
  // Use your actual location coordinates or implement a location service to get user's location
  double latitude = 35.6892; // Example latitude for Tunis
  double longitude = 10.1658; // Example longitude for Tunis
  
  try {
    PrayerTimes prayerTimes = await fetchPrayerTimes(latitude, longitude);
    setState(() {
      _prayerTimes = prayerTimes;
      _isLoading = false; // Set loading to false after fetching
    });
  } catch (e) {
    // Handle error (you might want to show an error message)
    setState(() {
      _isLoading = false; // Stop loading even if there is an error
    });
  }
}

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? '';
    });
  }

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
      _saveDhikrs(); // Save dhikrs to local storage
    });
  }

  Future<void> _loadDhikrs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dhikrsString = prefs.getString('dhikrs');
    if (dhikrsString != null) {
      List<dynamic> dhikrsList = jsonDecode(dhikrsString);
      setState(() {
        _dhikrs = List<Map<String, dynamic>>.from(dhikrsList);
      });
    }
  }

  Future<void> _saveDhikrs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dhikrsString = jsonEncode(_dhikrs);
    await prefs.setString('dhikrs', dhikrsString);
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
Widget _buildPrayerTimeBox(String prayerName, String prayerTime) {
  return Card(
    margin: const EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            prayerName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            prayerTime,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
///////////////////////

////////////////////////
Widget _buildDefaultScreen() {
  return GestureDetector(
    onTap: _incrementCounter,
    child: Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Horizontal ListView for Prayer Times
            if (_isLoading) 
              CircularProgressIndicator() // Show a loading spinner while fetching
            else if (_prayerTimes != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  height: 100, // Adjust height based on design preference
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildPrayerTimeBox('عشاء', _prayerTimes!.isha),
                      _buildPrayerTimeBox('مغرب', _prayerTimes!.maghrib),
                      _buildPrayerTimeBox('عصر', _prayerTimes!.asr),
                      _buildPrayerTimeBox('ظهر', _prayerTimes!.dhuhr),
                      _buildPrayerTimeBox('شروق', _prayerTimes!.sunrise),
                      _buildPrayerTimeBox('فجر', _prayerTimes!.fajr),
                      
                      
                      
                      
                      
                    ],
                  ),
                ),
              )
            else
              Text('فشل في تحميل أوقات الصلاة'), // Handle failure case

            const SizedBox(height: 20),
            Text(
              '$_userName انت الان في الذكر عدد',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color.fromARGB(255, 229, 176, 238),
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
                  backgroundColor: const Color.fromARGB(255, 176, 176, 176),
                  child: const Icon(Icons.loop),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _incrementCounter,
                  backgroundColor: const Color.fromARGB(255, 229, 176, 238),
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
////////////////////////
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
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 220, 153, 232),
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
                  title: const Text(' اضافة ذكر'),
                  onTap: onAddDhikr,
                ),
                ListTile(
                  title: const Text(' أذكاري'),
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
          ),
          const Divider(), // Divider at the bottom
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'تم التنفيذ بواسطة: يحيى السنوسي',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
