class QuranDetail {
  final int number;
  final String name;
  final String latinName;
  final int numberOfVerse;
  final String origin;
  final String mean;
  final String description;
  final Audio audio;
  final List<Verse> verses;

  QuranDetail({
    required this.number,
    required this.name,
    required this.latinName,
    required this.numberOfVerse,
    required this.origin,
    required this.mean,
    required this.description,
    required this.audio,
    required this.verses,
  });

  factory QuranDetail.fromJson(Map<String, dynamic> json) => QuranDetail(
    number: json['nomor'],
    name: json['nama'],
    latinName: json['namaLatin'],
    numberOfVerse: json['jumlahAyat'],
    origin: json['tempatTurun'],
    mean: json['arti'],
    description: json['deskripsi'],
    audio: Audio.fromJson(json['audioFull']),
    verses: List<Verse>.from(json['ayat'].map((ayat) => Verse.fromJson(ayat))),
  );
}

class Audio {
  final String audio;
  Audio({required this.audio});

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(audio: json['05']);
}

class Verse {
  final int verseNumber;
  final String arabic;
  final String latin;
  final String translation;
  final Audio audio;

  Verse({
    required this.verseNumber,
    required this.arabic,
    required this.latin,
    required this.translation,
    required this.audio,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
    verseNumber: json['nomorAyat'],
    arabic: json['teksArab'],
    latin: json['teksLatin'],
    translation: json['teksIndonesia'],
    audio: Audio.fromJson(json['audio']),
  );
}
