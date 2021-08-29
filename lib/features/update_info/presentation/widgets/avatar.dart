import 'package:app_web_project/core/components/bottom_sheet_app.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/features/update_info/presentation/blocs/upload_avatar_bloc/upload_avatar_cubit.dart';
import 'package:app_web_project/injection_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AvatarSelect extends StatefulWidget {
  String imageUrl;

  AvatarSelect({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _AvatarSelectState createState() => _AvatarSelectState();
}

class _AvatarSelectState extends State<AvatarSelect> {
  late UploadAvatarCubit uploadAvatarCubit;

  @override
  void initState() {
    // TODO: implement initState
    uploadAvatarCubit = inject<UploadAvatarCubit>();
    uploadAvatarCubit.setAvatar(widget.imageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UploadAvatarCubit>(
      create: (context) => uploadAvatarCubit,
      child: BlocBuilder<UploadAvatarCubit, UploadAvatarState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: ()async{
              if (kIsWeb) {
                uploadAvatarCubit.pickAvatar(PickImageType.none);
              } else {
                final type = await showBottomChooseImage(context);
                uploadAvatarCubit.pickAvatar(type);
              }
            },
            child: Container(
              height: 100.h,
              width: 100.w,
              child: CircleAvatar(
                backgroundImage: NetworkImage(state.avatar??''),
              ),
            ),
          );
        },
      ),
    );
  }
}
