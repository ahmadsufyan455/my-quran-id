part of 'quran_bloc.dart';

@immutable
abstract class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object> get props => [];
}

class LoadQuran extends QuranEvent {}
