part of 'audio_cubit.dart';

sealed class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object?> get props => [];
}

final class AudioInitial extends AudioState {}

final class AudioPlay extends AudioState {
  final int index;

  const AudioPlay(this.index);

  @override
  List<Object?> get props => [index];
}

final class AudioPause extends AudioState {}

final class AudioStop extends AudioState {}
