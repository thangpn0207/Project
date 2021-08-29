import 'dart:async';

import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/model/image_model.dart';
import 'package:app_web_project/services/repository_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_profile_state.dart';

class BottomProfileCubit extends Cubit<BottomProfileState> {
  LoadingCubit loadingCubit;
  Repository repository;
  SnackBarCubit snackBarCubit;
  BottomProfileCubit(this.repository,this.loadingCubit,this.snackBarCubit) : super(BottomProfileState());
  StreamSubscription? listImage;
  Future<void> getDataImage(String userId) async {
    listImage?.cancel();
    listImage =   repository.getListPhotos(userId).listen((listPhoto) {
      emit(state.copyWith(listPhoto));
    });
  }
  @override
  Future<void> close() {
    // TODO: implement close
    listImage?.cancel();
    return super.close();
  }
}
