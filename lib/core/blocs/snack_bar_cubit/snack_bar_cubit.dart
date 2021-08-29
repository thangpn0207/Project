import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'snack_bar_state.dart';

class SnackBarCubit extends Cubit<SnackBarState> {
  SnackBarCubit() : super(SnackBarInitialState());

  void showSnackBar(SnackBarType snackBarType, String msg,
      {Duration? duration}) {
    emit(ShowSnackBarState(type: snackBarType, mess: msg, duration: duration));
  }
}
