import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the current reading progress as a value between 0.0 and 1.0.
/// Using a dedicated Cubit means only the progress bar widget rebuilds
/// on scroll — the rest of the page tree stays untouched.
class ReadProgressCubit extends Cubit<double> {
  ReadProgressCubit() : super(0.0);

  void updateProgress(double progress) {
    final clamped = progress.clamp(0.0, 1.0);
    if (clamped != state) emit(clamped);
  }
}
