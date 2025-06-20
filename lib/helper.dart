import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hijriyah_indonesia/hijriyah_indonesia.dart';
import 'package:intl/intl.dart';

class Helper {
  static String getHijrDate() {
    return Hijriyah.now().toFormat('dd MMMM yyyy');
  }

  static String getDate() {
    return DateFormat("d MMMM yyyy", "id_ID").format(DateTime.now());
  }

  static String getToday() {
    DateTime today = DateTime.now();
    return DateFormat('EEEE', 'id').format(today);
  }

  static Future<bool> hasInternet() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);
  }

  static String getNearestPrayer(
    List<Map<String, dynamic>> times,
    DateTime now,
  ) {
    final now = DateTime.now();
    final upcoming = times.where((p) => p['time'].isAfter(now)).toList()
      ..sort(
        (a, b) => (a['time'] as DateTime).compareTo(b['time'] as DateTime),
      );
    final upcomingLabel = upcoming.isNotEmpty
        ? upcoming.first['name'] as String
        : '';
    return upcomingLabel;
  }
}
