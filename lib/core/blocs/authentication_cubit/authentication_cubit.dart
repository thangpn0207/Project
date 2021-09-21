import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/containts/spref_constants.dart';
import 'package:app_web_project/core/services/authentication.dart';
import 'package:app_web_project/core/utils/spref_utils.dart';
import 'package:bloc/bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  Authentication authentication;
  LoadingCubit loadingCubit;
  AuthenticationCubit(this.authentication, this.loadingCubit)
      : super(AuthenticationStateFail());

  Future<void> authenticationCheck() async {
    try {
      loadingCubit.showLoading();
      final isSignedIn = await authentication.isSignIn();
      if (isSignedIn) {
        loadingCubit.hideLoading();
        emit(AuthenticationStateSuccess());
      } else {
        loadingCubit.hideLoading();
        emit(AuthenticationStateFail());
      }
    } catch (e) {
      loadingCubit.hideLoading();
      emit(AuthenticationStateFail());
    }
  }

  Future<void> logOut() async {
    await SPrefUtil.instance.setString(SPrefConstants.userId, '');
    await authentication.signOut();
    emit(AuthenticationStateFail());
  }
}
