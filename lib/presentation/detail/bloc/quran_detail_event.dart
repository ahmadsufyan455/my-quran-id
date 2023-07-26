part of 'quran_detail_bloc.dart';

@immutable
abstract class QuranDetailEvent extends Equatable {
  const QuranDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadQuranDetail extends QuranDetailEvent {
  final int number;
  const LoadQuranDetail(this.number);
}
