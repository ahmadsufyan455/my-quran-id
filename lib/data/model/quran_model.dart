class Quran {
  int? number;
  String? name;
  String? latinName;
  int? numberOfVerse;
  String? origin;
  String? mean;
  String? description;
  String? audio;

  Quran({
    this.number,
    this.name,
    this.latinName,
    this.numberOfVerse,
    this.origin,
    this.mean,
    this.description,
    this.audio,
  });

  Quran.fromJson(Map<String, dynamic> json) {
    number = json['nomor'];
    name = json['nama'];
    latinName = json['nama_latin'];
    numberOfVerse = json['jumlah_ayat'];
    origin = json['tempat_turun'];
    mean = json['arti'];
    description = json['deskripsi'];
    audio = json['audio'];
  }
}
