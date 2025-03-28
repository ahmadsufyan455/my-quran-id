import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_quran_id/helper.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentlyPlayingIndex;

  AudioCubit() : super(AudioInitial());

  Future<void> playAudio(String url, int index) async {
    try {
      final isConnected = await Helper.hasInternet();
      if (!isConnected) {
        emit(const NoInternet('Butuh koneksi internet!'));
      }
      if (_currentlyPlayingIndex == index && _audioPlayer.playing) {
        _audioPlayer.pause();
        emit(AudioPause());
      } else {
        await _audioPlayer.setUrl(url);
        _audioPlayer.play();
        _currentlyPlayingIndex = index;
        emit(AudioPlay(index));

        _audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            emit(AudioPause());
            _currentlyPlayingIndex = null;
          }
        });
      }
    } catch (e) {
      emit(AudioStop());
    }
  }

  void stopAudio() {
    _audioPlayer.stop();
    emit(AudioStop());
    _currentlyPlayingIndex = null;
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
