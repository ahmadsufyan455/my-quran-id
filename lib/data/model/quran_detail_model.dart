class QuranDetail {
  int? number;
  String? name;
  String? latinName;
  int? numberOfVerse;
  String? origin;
  String? mean;
  String? description;
  String? audio;
  bool? status;
  List<Verse>? verses;

  QuranDetail({
    this.number,
    this.name,
    this.latinName,
    this.numberOfVerse,
    this.origin,
    this.mean,
    this.description,
    this.audio,
    this.status,
    this.verses,
  });

  QuranDetail.fromJson(Map<String, dynamic> json) {
    number = json['nomor'];
    name = json['nama'];
    latinName = json['nama_latin'];
    numberOfVerse = json['jumlah_ayat'];
    origin = json['tempat_turun'];
    mean = json['arti'];
    description = json['deskripsi'];
    audio = json['audio'];
    status = json['status'];
    verses = List.from(Verse.fromJson(json['ayat']) as List);
  }
}

class Verse {
  int? id;
  int? chapter;
  int? number;
  String? ar;
  String? tr;
  String? idn;

  Verse({
    this.id,
    this.chapter,
    this.number,
    this.ar,
    this.tr,
    this.idn,
  });

  Verse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapter = json['surah'];
    number = json['nomor'];
    ar = json['ar'];
    tr = json['tr'];
    idn = json['idn'];
  }
}
