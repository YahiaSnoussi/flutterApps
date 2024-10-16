import 'package:flutter/material.dart';

class DhikrDetailPage extends StatefulWidget {
  final Map<String, dynamic> dhikr;

  const DhikrDetailPage({super.key, required this.dhikr});

  @override
  _DhikrDetailPageState createState() => _DhikrDetailPageState();
}

class _DhikrDetailPageState extends State<DhikrDetailPage> {
  late int currentCount;

  @override
  void initState() {
    super.initState();
    currentCount = 0;
  }

  void _incrementCounter() {
    setState(() {
      if (currentCount < widget.dhikr['count']) {
        currentCount++;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      currentCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color circleColor = (currentCount >= widget.dhikr['count'] - 2)
        ? Colors.green
        : const Color.fromARGB(255, 245, 91, 178);

    return Scaffold(
      appBar: AppBar(
        title: const Text('أذكاري'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: GestureDetector(
        onTap: _incrementCounter,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.dhikr['text'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$currentCount / ${widget.dhikr['count']}',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: _resetCounter,
                      backgroundColor:
                          const Color.fromARGB(255, 52, 148, 195),
                      child: const Icon(Icons.loop),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: _incrementCounter,
                      backgroundColor:
                          const Color.fromARGB(255, 245, 91, 178),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
