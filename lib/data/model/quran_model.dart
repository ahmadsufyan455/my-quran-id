class Quran {
  int? number;
  String? name;
  String? latinName;
  int? numberOfVerse;
  String? origin;
  String? mean;
  String? description;
  Audio? audio;

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
    latinName = json['namaLatin'];
    numberOfVerse = json['jumlahAyat'];
    origin = json['tempatTurun'];
    mean = json['arti'];
    description = json['deskripsi'];
    audio = Audio.fromJson(json['audioFull']);
  }
}

class Audio {
  String? audio;
  Audio({this.audio});

  Audio.fromJson(Map<String, dynamic> json) {
    audio = json['05'];
  }
}
