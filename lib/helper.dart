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
    for (var i = 0; i < times.length; i++) {
      final startTime = times[i]['time'] as DateTime?;
      if (startTime == null) continue;
      final twoHoursBefore = startTime.subtract(const Duration(hours: 2));
      final diff = now.difference(twoHoursBefore).inMinutes;
      if (diff >= 0 && now.isBefore(startTime.add(const Duration(hours: 2)))) {
        return times[i]['name'] as String;
      }
    }
    return 'Subuh';
  }
}
