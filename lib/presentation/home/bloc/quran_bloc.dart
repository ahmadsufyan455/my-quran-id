import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_quran_id/data/model/quran_model.dart';
import 'package:my_quran_id/domain/quran_repository.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final QuranRepository _quranRepository;

  QuranBloc(this._quranRepository) : super(QuranInitial()) {
    on<LoadQuran>((event, emit) async {
      emit(QuranLoading());
      try {
        final result = await _quranRepository.getListQuran();
        emit(QuranSuccess(result.data!));
      } catch (e) {
        emit(QuranError(e.toString()));
      }
    });
  }
}
