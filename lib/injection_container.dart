
import 'package:app_web_project/features/change_password/presentation/blocs/change_password_cubit.dart';
import 'package:app_web_project/features/chat/presentation/blocs/audio_cubit/audio_cubit.dart';
import 'package:app_web_project/features/chat/presentation/blocs/audio_web_cubit/audio_web_cubit.dart';
import 'package:app_web_project/features/main/presentation/blocs/home_cubit.dart';
import 'package:app_web_project/features/profile/presentation/blocs/bottom_profile_cubit/bottom_profile_cubit.dart';
import 'package:app_web_project/features/profile/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:app_web_project/features/update_info/presentation/blocs/update_info_cubit/update_info_cubit.dart';
import 'package:app_web_project/services/authentication.dart';
import 'package:app_web_project/services/chat_service.dart';
import 'package:app_web_project/services/repository_service.dart';
import 'package:app_web_project/services/song_service.dart';
import 'package:get_it/get_it.dart';


import 'core/blocs/authentication_cubit/authentication_cubit.dart';
import 'core/blocs/loading_cubit/loading_cubit.dart';
import 'core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'core/networks/network_info.dart';
import 'features/login/presentation/blocs/login_cubit/login_cubit.dart';
import 'features/register/presentation/blocs/sign_up_cubit/sign_up_cubit.dart';
import 'features/update_info/presentation/blocs/upload_avatar_bloc/upload_avatar_cubit.dart';
GetIt inject = GetIt.instance;


Future<void> init() async{
  _configureCubit();
  _configureRepositoriesImpl();
  _configureDataSourcesImpl();
  _configureCommon();
  _configureUseCase();
}

void _configureCommon() {
  inject.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(inject()));

}

void _configureDataSourcesImpl() {

}


void _configureRepositoriesImpl() {
  inject.registerLazySingleton(()=>Authentication(inject()));
  inject.registerLazySingleton(()=> Repository());
  inject.registerLazySingleton(() => ChatService(inject()));
  inject.registerLazySingleton(() => SongService(inject()));
}
void _configureUseCase(){

}
void _configureCubit() {
  inject.registerLazySingleton(() => LoadingCubit());
  inject.registerLazySingleton(() => SnackBarCubit());
  inject.registerLazySingleton(() => AuthenticationCubit(inject(),inject()));
  inject.registerFactory(() => LoginCubit(inject(), inject(), inject()));
  inject.registerFactory(() => SignUpCubit(inject(), inject(), inject(),inject()));
  inject.registerFactory(() => ChangePasswordCubit(inject(), inject(), inject(),inject()));
  inject.registerFactory(() => AudioCubit(inject()));
  inject.registerFactory(() => AudioWebCubit());
  inject.registerFactory(() => HomeCubit(inject(),inject(),inject()));
  inject.registerLazySingleton(() => UploadAvatarCubit(inject(),inject(),inject()));
  inject.registerLazySingleton(() => UpdateInfoCubit(inject(),inject(),inject(),inject()));
  inject.registerFactory(() => ProfileCubit(inject(),inject(),inject()));
  inject.registerFactory(() => BottomProfileCubit(inject(),inject(),inject()));

}
