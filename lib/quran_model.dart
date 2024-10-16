class Verse {
  final int chapter;
  final int verse;
  final String text;

  Verse({required this.chapter, required this.verse, required this.text});
}

class Chapter {
  final int chapterNumber;
  final List<Verse> verses;

  Chapter({required this.chapterNumber, required this.verses});
}