import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayers_times/prayers_times.dart';

part 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  PrayerCubit() : super(PrayerLoading());

  /// Get user's location and prayer times
  Future<void> fetchPrayerTimes() async {
    try {
      emit(PrayerLoading());

      // Get current position
      Position position = await _determinePosition();
      double lat = position.latitude;
      double lon = position.longitude;

      // Get location name
      final timeZone = await FlutterTimezone.getLocalTimezone();

      // Calculate prayer times
      PrayerTimes prayerTimes = _calculatePrayerTimes(lat, lon, timeZone);
      final cityName = await _getLocationName(lat, lon);

      emit(
        PrayerLoaded(
          location: timeZone,
          cityName: cityName,
          prayerTimes: prayerTimes,
        ),
      );
    } catch (e) {
      emit(PrayerError(e.toString()));
    }
  }

  Future<String> _getLocationName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      Placemark place = placemarks.first;
      return "${place.locality}, ${place.country}";
    } catch (e) {
      return "Unknown Location";
    }
  }

  /// Request location permission and fetch current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location service disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );
  }

  /// Calculate prayer times
  PrayerTimes _calculatePrayerTimes(double lat, double lon, String location) {
    PrayerCalculationParameters params = PrayerCalculationMethod.ummAlQura();
    params.madhab = PrayerMadhab.shafi;

    return PrayerTimes(
      coordinates: Coordinates(lat, lon),
      calculationParameters: params,
      precision: true,
      locationName: location,
      dateTime: DateTime.now(),
    );
  }
}
