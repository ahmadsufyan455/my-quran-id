part of 'quran_detail_bloc.dart';

abstract class QuranDetailState extends Equatable {
  const QuranDetailState();

  @override
  List<Object> get props => [];
}

class QuranDetailInitial extends QuranDetailState {}

class QuranDetailLoading extends QuranDetailState {}

class QuranDetailSuccess extends QuranDetailState {
  final QuranDetail quranDetail;
  const QuranDetailSuccess(this.quranDetail);
}

class QuranDetailError extends QuranDetailState {
  final String error;
  const QuranDetailError(this.error);
}
