import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/services/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  Authentication authentication;
  LoadingCubit loadingCubit;
  SnackBarCubit snackBarCubit;

  LoginCubit(this.authentication, this.loadingCubit, this.snackBarCubit)
      : super(LoginState.initial());

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    loadingCubit.showLoading();
    if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
      try {
        await authentication.signIn(email.trim(), password.trim());
        loadingCubit.hideLoading();
        emit(LoginState.success());
      } on FirebaseAuthException catch (e) {
        loadingCubit.hideLoading();
        snackBarCubit.showSnackBar(SnackBarType.warning, e.code);
        emit(LoginState.failure());
      }
    } else {
      loadingCubit.hideLoading();
      snackBarCubit.showSnackBar(
          SnackBarType.warning, "Email or Password is not valid");
      emit(LoginState.initial());
    }
  }

  Future<void> loginWithGG() async {
    loadingCubit.showLoading();
    try {
      await authentication.signInWithGoggle();
      loadingCubit.hideLoading();
      emit(LoginState.success());
    } catch (e) {
      loadingCubit.hideLoading();
      snackBarCubit.showSnackBar(SnackBarType.error, "Login fail");
      emit(LoginState.failure());
    }
  }

  Future<void> loginWithFacebook() async {
    loadingCubit.showLoading();
    try {
      await authentication.signInWithFacebook();
      loadingCubit.hideLoading();
      emit(LoginState.success());
    } catch (e) {
      loadingCubit.hideLoading();
      snackBarCubit.showSnackBar(SnackBarType.error, "Login fail");
      emit(LoginState.failure());
    }
  }
}
