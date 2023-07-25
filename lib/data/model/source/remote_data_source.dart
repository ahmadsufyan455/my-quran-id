import 'package:dio/dio.dart';
import 'package:my_quran_id/data/model/general_model.dart';

abstract class RemoteDataSource {
  Future<GeneralModel<T>> getData<T>({
    required String endPoint,
    required T Function(dynamic) modelFromJson,
  });
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://equran.id/api/v2'));

  @override
  Future<GeneralModel<T>> getData<T>({
    required String endPoint,
    required T Function(dynamic) modelFromJson,
  }) async {
    try {
      final response = await _dio.get(endPoint);
      return GeneralModel.fromJson(response.data, modelFromJson);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'];
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
