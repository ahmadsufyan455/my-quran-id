import 'package:hijriyah_indonesia/hijriyah_indonesia.dart';
import 'package:intl/intl.dart';

class Helper {
  static String getHijrDate() {
    return Hijriyah.now().toFormat('dd MMMM yyyy');
  }

  static String getToday() {
    DateTime today = DateTime.now();
    return DateFormat('EEEE', 'id').format(today);
  }
}
