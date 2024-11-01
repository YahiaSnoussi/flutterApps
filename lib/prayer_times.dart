import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasbih/PrayerTimes.dart';

class PrayerTimesPage extends StatelessWidget {
  // You can fetch and display prayer times here.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أوقات الصلاة'),
      ),
      body: Center(
        child: Text('أوقات الصلاة ستظهر هنا'),
      ),
    );
  }
}

Future<PrayerTimes> fetchPrayerTimes(double latitude, double longitude) async {
  final response = await http.get(Uri.parse('https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return PrayerTimes(
      fajr: data['data']['timings']['Fajr'],
      sunrise: data['data']['timings']['Sunrise'],
      dhuhr: data['data']['timings']['Dhuhr'],
      asr: data['data']['timings']['Asr'],
      maghrib: data['data']['timings']['Maghrib'],
      isha: data['data']['timings']['Isha'],
    );
  } else {
    throw Exception('Failed to load prayer times');
  }
}