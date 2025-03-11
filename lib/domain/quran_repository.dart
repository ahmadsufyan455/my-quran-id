import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:my_quran_id/data/model/general_model.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/data/model/quran_model.dart';

class QuranRepository {
  Future<GeneralModel<List<Quran>>> getListQuran() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/datas/quran_data.json',
      );
      final jsonData = jsonDecode(jsonString);
      final List<dynamic> listSurah = jsonData['data'];
      final quranList =
          listSurah.map((surah) => Quran.fromJson(surah)).toList();
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
      final jsonData = jsonDecode(jsonString);
      final quranDetail = QuranDetail.fromJson(jsonData['data']);

      return GeneralModel<QuranDetail>(data: quranDetail);
    } catch (e) {
      return GeneralModel<QuranDetail>(
        message: 'Error loading Surah $number: $e',
      );
    }
  }
}
