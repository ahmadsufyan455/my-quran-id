import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/domain/quran_repository.dart';

part 'quran_detail_event.dart';
part 'quran_detail_state.dart';

class QuranDetailBloc extends Bloc<QuranDetailEvent, QuranDetailState> {
  final QuranRepository _quranRepository;

  QuranDetailBloc(this._quranRepository) : super(QuranDetailInitial()) {
    on<LoadQuranDetail>((event, emit) async {
      emit(QuranDetailLoading());
      try {
        final result = await _quranRepository.getDetailQuran(event.number);
        emit(QuranDetailSuccess(result.data!));
      } catch (e) {
        emit(QuranDetailError(e.toString()));
      }
    });
  }
}
