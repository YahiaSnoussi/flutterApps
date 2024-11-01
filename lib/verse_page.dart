import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quran_model.dart';
import 'separator.dart';
import 'dart:convert';

class VersePage extends StatefulWidget {
  final Chapter chapter;

  const VersePage({Key? key, required this.chapter}) : super(key: key);

  @override
  _VersePageState createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  Map<String, String> arabicNumbers = {};

  @override
  void initState() {
    super.initState();
    loadArabicNumbers();
  }

  Future<void> loadArabicNumbers() async {
    final String response = await rootBundle.loadString('assets/num.json');
    final data = json.decode(response);

    setState(() {
      // Convert JSON to a map for easy lookup
      arabicNumbers = {for (var num in data['numbers']) num['english'].toString(): num['arabic']};
    });
  }

  String getArabicNumber(int number) {
    // Check if the Arabic version exists, otherwise return the original number
    return arabicNumbers[number.toString()] ?? number.toString();
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
              itemCount: versesForPage.length + (pageIndex == 0 && shouldAddBismillah() ? 1 : 0),
              itemBuilder: (context, index) {
                if (pageIndex == 0 && shouldAddBismillah() && index == 0) {
                  return _buildBismillahText();
                }
                final verse = versesForPage[index - (pageIndex == 0 && shouldAddBismillah() ? 1 : 0)];
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

  Widget _buildBismillahText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ",
        style: const TextStyle(
          fontSize: 24,
          fontFamily: 'quranic',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  bool shouldAddBismillah() {
    return widget.chapter.chapterNumber != 1 && widget.chapter.chapterNumber != 9;
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