import 'package:my_quran_id/data/model/general_model.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/data/model/quran_model.dart';
import 'package:my_quran_id/data/model/source/remote_data_source.dart';

class QuranRepository {
  final RemoteDataSource _dataSource;

  QuranRepository(this._dataSource);

  Future<GeneralModel<List<Quran>>> getListQuran() {
    return _dataSource.getData(
      endPoint: '/surat',
      modelFromJson: (json) {
        final List<dynamic> listSurah = json as List<dynamic>;
        return listSurah.map((surah) => Quran.fromJson(surah)).toList();
      },
    );
  }

  Future<GeneralModel<QuranDetail>> getDetailQuran(int number) {
    return _dataSource.getData(
      endPoint: '/surat/$number',
      modelFromJson: (json) => QuranDetail.fromJson(json),
    );
  }
}
