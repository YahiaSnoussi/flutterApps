import 'package:flutter/material.dart';

class CircularVerseNumber extends StatelessWidget {
  final String verseNumber;

  const CircularVerseNumber({Key? key, required this.verseNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0, // Adjust the width as necessary
      height: 50.0, // Adjust the height as necessary
      child: Stack(
        alignment: Alignment.center, // Center the text over the image
        children: [
          Image.asset(
            'assets/separator.png', // Your PNG image
            fit: BoxFit.cover, // Cover the entire container
          ),
          Directionality(
            textDirection: TextDirection.rtl, // Ensure RTL for Arabic text
            child: Text(
              verseNumber,
              style: const TextStyle(
                fontSize: 18, // Increase font size if necessary
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change as needed
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
