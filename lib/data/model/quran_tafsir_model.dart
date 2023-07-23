class QuranTafsir {
  int? number;
  String? name;
  String? latinName;
  int? numberOfVerse;
  String? origin;
  String? mean;
  String? description;
  String? audio;
  List<Tafsir>? tafsir;

  QuranTafsir(
      {this.number,
      this.name,
      this.latinName,
      this.numberOfVerse,
      this.origin,
      this.mean,
      this.description,
      this.audio,
      this.tafsir});

  QuranTafsir.fromJson(Map<String, dynamic> json) {
    number = json['nomor'];
    name = json['nama'];
    latinName = json['nama_latin'];
    numberOfVerse = json['jumlah_ayat'];
    origin = json['tempat_turun'];
    mean = json['arti'];
    description = json['deskripsi'];
    audio = json['audio'];
    tafsir = List.from(Tafsir.fromJson(json['tafsir']) as List);
  }
}

class Tafsir {
  int? id;
  int? chapter;
  int? verse;
  String? tafsir;

  Tafsir({
    this.id,
    this.chapter,
    this.verse,
    this.tafsir,
  });

  Tafsir.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapter = json['surah'];
    verse = json['verse'];
    tafsir = json['tafsir'];
  }
}
