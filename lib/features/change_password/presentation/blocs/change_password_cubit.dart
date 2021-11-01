import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/services/authentication.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  Authentication authentication;
  Repository repository;
  LoadingCubit loadingCubit;
  SnackBarCubit snackBarCubit;
  ChangePasswordCubit(this.authentication, this.snackBarCubit, this.repository,
      this.loadingCubit)
      : super(ChangePasswordInitial());
  Future<void> changePassword(
      String password, String newPassword, String confirmNewPassword) async {
    if (password.trim() != '' &&
        newPassword.trim() != '' &&
        confirmNewPassword.trim() != '') {
      bool check = await authentication.validatePassword(password);
      if (check == true) {
        if (newPassword == confirmNewPassword) {
          try {
            await authentication.updatePassword(newPassword);
            emit(ChangePasswordSuccess());
          } catch (e) {
            snackBarCubit.showSnackBar(SnackBarType.error, e.toString());
          }
        } else {
          snackBarCubit.showSnackBar(
              SnackBarType.error, "Wrong Confirm Password");
        }
      } else {
        snackBarCubit.showSnackBar(
            SnackBarType.error, "New password is the same with old password");
      }
    } else {
      snackBarCubit.showSnackBar(SnackBarType.error, "You forgot something");
    }
  }
}
