part of 'quran_bloc.dart';

abstract class QuranState extends Equatable {
  const QuranState();

  @override
  List<Object> get props => [];
}

class QuranInitial extends QuranState {}

class QuranLoading extends QuranState {}

class QuranSuccess extends QuranState {
  final List<Quran> quran;
  const QuranSuccess(this.quran);
}

class QuranError extends QuranState {
  final String error;
  const QuranError(this.error);
}
