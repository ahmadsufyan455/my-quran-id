class GeneralModel<T> {
  int? code;
  String? message;
  T? data;

  GeneralModel({this.code, this.message, this.data});

  GeneralModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    code = json['code'];
    message = json['message'];
    data = fromJson(json['data']);
  }
}
