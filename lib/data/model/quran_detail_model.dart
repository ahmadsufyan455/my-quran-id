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
    verses = List<Verse>.from(json['ayat'].map((ayat) => Verse.fromJson(ayat)));
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
  int? verseNumber;
  String? arabic;
  String? latin;
  String? translation;
  Audio? audio;

  Verse({
    this.verseNumber,
    this.arabic,
    this.latin,
    this.translation,
    this.audio,
  });

  Verse.fromJson(Map<String, dynamic> json) {
    verseNumber = json['nomorAyat'];
    arabic = json['teksArab'];
    latin = json['teksLatin'];
    translation = json['teksIndonesia'];
    audio = Audio.fromJson(json['audio']);
  }
}
