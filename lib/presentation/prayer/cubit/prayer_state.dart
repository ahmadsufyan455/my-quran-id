part of 'prayer_cubit.dart';

sealed class PrayerState extends Equatable {
  const PrayerState();

  @override
  List<Object> get props => [];
}

final class PrayerLoading extends PrayerState {}

final class PrayerLoaded extends PrayerState {
  final String location;
  final String cityName;
  final PrayerTimes prayerTimes;

  const PrayerLoaded({
    required this.location,
    required this.cityName,
    required this.prayerTimes,
  });

  @override
  List<Object> get props => [location, cityName, prayerTimes];
}

final class PrayerError extends PrayerState {
  final String message;

  const PrayerError(this.message);

  @override
  List<Object> get props => [message];
}
