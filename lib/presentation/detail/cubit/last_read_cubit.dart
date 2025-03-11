import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastReadState {
  final int? lastReadIndex;
  final String? lastReadVerse;
  final String? lastReadSurah;
  final int? verseNumber;
  final int? number;

  LastReadState({
    this.lastReadIndex,
    this.lastReadVerse,
    this.lastReadSurah,
    this.verseNumber,
    this.number,
  });
}

class LastReadCubit extends Cubit<LastReadState> {
  LastReadCubit() : super(LastReadState());

  Future<void> saveLastRead(
    int index,
    String verseText,
    String surah,
    int verseNumber,
    int number,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_read_index', index);
    await prefs.setString('last_read_verse', verseText);
    await prefs.setString('last_read_surah', surah);
    await prefs.setInt('verse_number', verseNumber);
    await prefs.setInt('number', number);
    emit(
      LastReadState(
        lastReadIndex: index,
        lastReadVerse: verseText,
        lastReadSurah: surah,
        number: number,
      ),
    );
  }

  Future<void> loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('last_read_index');
    final verse = prefs.getString('last_read_verse');
    final surah = prefs.getString('last_read_surah');
    final verseNumber = prefs.getInt('verse_number');
    final number = prefs.getInt('number');
    emit(
      LastReadState(
        lastReadIndex: index,
        lastReadVerse: verse,
        lastReadSurah: surah,
        verseNumber: verseNumber,
        number: number,
      ),
    );
  }
}
