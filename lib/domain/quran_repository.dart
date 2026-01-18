import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:my_quran_id/data/model/general_model.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/data/model/quran_model.dart';

QuranDetail _parseQuranDetail(String jsonString) {
  final jsonData = jsonDecode(jsonString);
  return QuranDetail.fromJson(jsonData['data']);
}

/// Surahs with 100+ verses - these benefit from compute() isolate
/// to prevent UI jank during JSON parsing
const _longSurahs = {
  2, // Al-Baqarah (286)
  3, // Ali 'Imran (200)
  4, // An-Nisa (176)
  6, // Al-An'am (165)
  7, // Al-A'raf (206)
  9, // At-Tawbah (129)
  10, // Yunus (109)
  11, // Hud (123)
  12, // Yusuf (111)
  16, // An-Nahl (128)
  17, // Al-Isra (111)
  18, // Al-Kahf (110)
  20, // Taha (135)
  21, // Al-Anbya (112)
  23, // Al-Mu'minun (118)
  26, // Ash-Shu'ara (227)
  37, // As-Saffat (182)
};

class QuranRepository {
  Future<GeneralModel<List<Quran>>> getListQuran() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/datas/quran_data.json',
      );

      // Surah list is small, direct parsing is fine
      final jsonData = jsonDecode(jsonString);
      final List<dynamic> listSurah = jsonData['data'];
      final quranList = listSurah
          .map((surah) => Quran.fromJson(surah))
          .toList();

      return GeneralModel<List<Quran>>(data: quranList);
    } catch (e) {
      return GeneralModel<List<Quran>>(message: 'Error loading Quran list: $e');
    }
  }

  Future<GeneralModel<QuranDetail>> getDetailQuran(int number) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/datas/surah/$number.json',
      );

      // Use compute() only for long surahs to avoid isolate overhead
      // for short surahs while preventing jank for long ones
      final QuranDetail quranDetail;
      if (_longSurahs.contains(number)) {
        // Long surah: use isolate to prevent UI jank
        quranDetail = await compute(_parseQuranDetail, jsonString);
      } else {
        // Short surah: direct parsing is faster (no isolate overhead)
        final jsonData = jsonDecode(jsonString);
        quranDetail = QuranDetail.fromJson(jsonData['data']);
      }

      return GeneralModel<QuranDetail>(data: quranDetail);
    } catch (e) {
      return GeneralModel<QuranDetail>(
        message: 'Error loading Surah $number: $e',
      );
    }
  }
}
