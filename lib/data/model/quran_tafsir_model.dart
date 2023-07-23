class QuranTafsir {
  int? number;
  String? name;
  String? latinName;
  int? numberOfVerse;
  String? origin;
  String? mean;
  String? description;
  List<Tafsir>? tafsir;

  QuranTafsir({
    this.number,
    this.name,
    this.latinName,
    this.numberOfVerse,
    this.origin,
    this.mean,
    this.description,
    this.tafsir,
  });

  QuranTafsir.fromJson(Map<String, dynamic> json) {
    number = json['nomor'];
    name = json['nama'];
    latinName = json['namaLatin'];
    numberOfVerse = json['jumlahAyat'];
    origin = json['tempatTurun'];
    mean = json['arti'];
    description = json['deskripsi'];
    tafsir = List.from(Tafsir.fromJson(json['tafsir']) as List);
  }
}

class Tafsir {
  int? verse;
  String? tafsir;

  Tafsir({
    this.verse,
    this.tafsir,
  });

  Tafsir.fromJson(Map<String, dynamic> json) {
    verse = json['ayat'];
    tafsir = json['teks'];
  }
}
