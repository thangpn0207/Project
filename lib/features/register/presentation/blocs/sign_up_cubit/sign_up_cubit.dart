import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/services/authentication.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final Authentication _authentication;
  final Repository repository;
  LoadingCubit loadingCubit;
  SnackBarCubit snackBarCubit;
  SignUpCubit(this.repository, this._authentication, this.snackBarCubit,
      this.loadingCubit)
      : super(SignUpState.initial());

  Future<void> registerUser(String email, String password,
      String confirmPassword, String displayName) async {
    if (password == confirmPassword) {
      loadingCubit.showLoading();
      try {
        UserCredential userCredential = await _authentication
            .signUpWithEmailAndPassword(email, password, displayName);
        User? userDetails = userCredential.user;
        UserModel newUser = UserModel(
            id: userDetails!.uid,
            email: userDetails.email,
            displayName: displayName,
            imgUrl:
                'https://9mobi.vn/cf/images/ba/2018/4/16/anh-avatar-dep-1.jpg');
        repository.registerUser(newUser);
        for (int i = 0; i < 5; i++) {
          await repository.updateUserChatList(userDetails.uid, i.toString());
        }
        loadingCubit.hideLoading();
        emit(SignUpState.success());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          loadingCubit.hideLoading();
          snackBarCubit.showSnackBar(SnackBarType.error, "weak-password");
          emit(SignUpState.initial());
        } else if (e.code == 'email-already-in-use') {
          loadingCubit.hideLoading();
          snackBarCubit.showSnackBar(
              SnackBarType.error, " user name already in use");
          emit(SignUpState.initial());
        } else {
          loadingCubit.hideLoading();
          snackBarCubit.showSnackBar(SnackBarType.error, "Wrong information");
          emit(SignUpState.initial());
        }
      }
    } else {
      snackBarCubit.showSnackBar(
          SnackBarType.error, "Password and Confirm Password are different");
      return;
    }
  }
}
