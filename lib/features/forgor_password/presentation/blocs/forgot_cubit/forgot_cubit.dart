import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/services/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forgot_state.dart';

class ForgotCubit extends Cubit<ForgotState> {
  final Authentication _authentication;
  final LoadingCubit loadingCubit;
  final SnackBarCubit snackBarCubit;
  ForgotCubit(this._authentication, this.loadingCubit, this.snackBarCubit)
      : super(ForgotInitial());

  void sendEmailReset(String email) {
    loadingCubit.showLoading();
    if (email != '') {
      _authentication.resetPassword(email);
    } else {
      snackBarCubit.showSnackBar(
          SnackBarType.warning, 'Please enter your email');
    }
    loadingCubit.hideLoading();
    emit(SendEmailSuccess(email: email));
  }
}
