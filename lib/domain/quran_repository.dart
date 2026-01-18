import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:my_quran_id/data/model/general_model.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/data/model/quran_model.dart';

// Top-level function for isolate - must be outside the class
QuranDetail _parseQuranDetail(String jsonString) {
  final jsonData = jsonDecode(jsonString);
  return QuranDetail.fromJson(jsonData['data']);
}

// Top-level function for parsing list of Quran
List<Quran> _parseQuranList(String jsonString) {
  final jsonData = jsonDecode(jsonString);
  final List<dynamic> listSurah = jsonData['data'];
  return listSurah.map((surah) => Quran.fromJson(surah)).toList();
}

class QuranRepository {
  Future<GeneralModel<List<Quran>>> getListQuran() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/datas/quran_data.json',
      );

      // Parse in background isolate using compute()
      final quranList = await compute(_parseQuranList, jsonString);

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

      // Parse in background isolate using compute()
      final quranDetail = await compute(_parseQuranDetail, jsonString);

      return GeneralModel<QuranDetail>(data: quranDetail);
    } catch (e) {
      return GeneralModel<QuranDetail>(
        message: 'Error loading Surah $number: $e',
      );
    }
  }
}
