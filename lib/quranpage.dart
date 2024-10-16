import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tasbih/quran_model.dart';
import 'verse_page.dart';

class QuranPage extends StatefulWidget {
  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<Chapter> chapters = [];
  List<Map<String, dynamic>> surahDetails = [];

  @override
  void initState() {
    super.initState();
    loadQuranData();
    loadSurahData(); // Load surah data
  }

  Future<void> loadQuranData() async {
    final String response = await rootBundle.loadString('assets/quran.json');
    final data = json.decode(response);
    
    List<Chapter> loadedChapters = [];

    data.forEach((key, value) {
      List<Verse> verses = [];
      for (var verse in value) {
        verses.add(Verse(
          chapter: verse['chapter'],
          verse: verse['verse'],
          text: verse['text'],
        ));
      }
      loadedChapters.add(Chapter(
        chapterNumber: int.parse(key),
        verses: verses,
      ));
    });

    setState(() {
      chapters = loadedChapters;
    });
  }

  Future<void> loadSurahData() async {
    final String response = await rootBundle.loadString('assets/souratdetails.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      surahDetails = List<Map<String, dynamic>>.from(data); // Store surah details
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // Set right-to-left direction
        child: ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            // Safely find the details for the current chapter
            final chapterDetails = surahDetails.firstWhere(
              (surah) => surah['id'] == chapters[index].chapterNumber,
              orElse: () => {'name': 'غير متوفر', 'total_verses': 0, 'type': 'غير محدد'}, // Fallback details
            );

            return ListTile(
              title: Text(
                'سورة ${chapters[index].chapterNumber}',
                textAlign: TextAlign.right, // Align title to the right
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapterDetails['name'], // Surah name
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right, // Align name to the right
                  ),
                  Text(
                    'عدد الايات: ${chapterDetails['total_verses']}, سورة: ${chapterDetails['type'] == 'medinan' ? 'مدنيّة' : 'مكيّة'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.right, // Align subtitle to the right
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VersePage(chapter: chapters[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
