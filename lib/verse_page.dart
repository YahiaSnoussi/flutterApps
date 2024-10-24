import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'quran_model.dart';
import 'separator.dart'; // Make sure to import your CircularVerseNumber class
import 'dart:convert';

class VersePage extends StatefulWidget {
  final Chapter chapter;

  const VersePage({Key? key, required this.chapter}) : super(key: key);

  @override
  _VersePageState createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  List<Map<String, String>> arabicNumbers = [];

  @override
  void initState() {
    super.initState();
    loadArabicNumbers();
  }

  Future<void> loadArabicNumbers() async {
    final String response = await rootBundle.loadString('assets/num.json');
    final data = json.decode(response);
    
    setState(() {
      arabicNumbers = List<Map<String, String>>.from(data['numbers']);
    });
  }

  String getArabicNumber(int number) {
  final found = arabicNumbers.firstWhere(
    (num) => num['english'] == number.toString(),
    orElse: () => {'arabic': ''}, // Fallback if not found
  );
  if (found['arabic'] == null || found['arabic'] == '') {
    print("Arabic number for $number not found.");
    return number.toString(); // Return original number if Arabic conversion fails
  }
  return found['arabic']!;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سورة ${widget.chapter.chapterNumber}'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: PageView.builder(
        reverse: true,
        itemCount: _calculatePageCount(context),
        itemBuilder: (context, pageIndex) {
          final versesForPage = _getVersesForPage(context, pageIndex);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: versesForPage.length,
              itemBuilder: (context, index) {
                final verse = versesForPage[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        verse.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'quranic',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      _buildVerseSeparator(verse.verse),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerseSeparator(int verseNumber) {
    String arabicNumber = getArabicNumber(verseNumber);
    return CircularVerseNumber(verseNumber: arabicNumber);
  }

  int _calculatePageCount(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final verseHeight = 100.0;
    final versesPerPage = (screenHeight / verseHeight).floor();
    return (versesPerPage > 0) ? (widget.chapter.verses.length / versesPerPage).ceil() : 1;
  }

  List<Verse> _getVersesForPage(BuildContext context, int pageIndex) {
    final screenHeight = MediaQuery.of(context).size.height;
    final verseHeight = 80.0;
    final versesPerPage = (screenHeight / verseHeight).floor();

    final start = pageIndex * versesPerPage;
    final end = (start + versesPerPage > widget.chapter.verses.length) 
        ? widget.chapter.verses.length 
        : start + versesPerPage;

    return widget.chapter.verses.sublist(start, end);
  }
}