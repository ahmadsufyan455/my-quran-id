import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerCountdownState {
  final Duration countdown;
  final String label;

  PrayerCountdownState({required this.countdown, required this.label});
}

class PrayerCountdownCubit extends Cubit<PrayerCountdownState> {
  final List<Map<String, dynamic>> prayers;
  Timer? _timer;

  PrayerCountdownCubit(this.prayers) : super(_getInitialState(prayers)) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(_getInitialState(prayers));
    });
  }

  static PrayerCountdownState _getInitialState(
    List<Map<String, dynamic>> prayers,
  ) {
    final now = DateTime.now();
    final upcoming = prayers.where((p) => p['time'].isAfter(now)).toList();
    if (upcoming.isEmpty) {
      return PrayerCountdownState(countdown: Duration.zero, label: '');
    }
    upcoming.sort((a, b) => a['time'].compareTo(b['time']));
    final nearest = upcoming.first;
    final countdown = (nearest['time'] as DateTime).difference(now);
    return PrayerCountdownState(
      countdown: countdown,
      label: nearest['name'] as String,
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
