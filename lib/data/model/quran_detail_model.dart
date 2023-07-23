class QuranDetail {
  int? number;
  String? name;
  String? latinName;
  int? numberOfVerse;
  String? origin;
  String? mean;
  String? description;
  Audio? audio;
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
    this.verses,
  });

  QuranDetail.fromJson(Map<String, dynamic> json) {
    number = json['nomor'];
    name = json['nama'];
    latinName = json['namaLatin'];
    numberOfVerse = json['jumlahAyat'];
    origin = json['tempatTurun'];
    mean = json['arti'];
    description = json['deskripsi'];
    audio = Audio.fromJson(json['audioFull']);
    verses = List.from(Verse.fromJson(json['ayat']) as List);
  }
}

class Audio {
  String? audio;
  Audio({this.audio});

  Audio.fromJson(Map<String, dynamic> json) {
    audio = json['05'];
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
