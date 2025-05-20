import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollCubit extends Cubit<bool> {
  ScrollCubit() : super(false); // false = don't show button

  void showButton() => emit(true);
  void hideButton() => emit(false);
}
