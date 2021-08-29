import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(HideLoading());

  void showLoading() {
    emit(ShowLoading());
  }

  void hideLoading() {
    emit(HideLoading());
  }
}