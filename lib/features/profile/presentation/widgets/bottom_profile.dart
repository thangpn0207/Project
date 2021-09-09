import 'package:app_web_project/core/model/image_model.dart';
import 'package:app_web_project/features/chat/presentation/widgets/full_photo.dart';
import 'package:app_web_project/features/profile/presentation/blocs/bottom_profile_cubit/bottom_profile_cubit.dart';
import 'package:app_web_project/injection_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomProfile extends StatefulWidget {
  String? userId;

  BottomProfile({Key? key, this.userId}) : super(key: key);

  @override
  _BottomProfileState createState() => _BottomProfileState();
}

class _BottomProfileState extends State<BottomProfile> {
  late BottomProfileCubit bottomProfileCubit;

  @override
  void initState() {
    // TODO: implement initState
    bottomProfileCubit = inject<BottomProfileCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomProfileCubit>(
      create: (context) => bottomProfileCubit..getDataImage(widget.userId ?? ''),
      child: Container(
        color: Color(0xfffae7e9),
        height: 430.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.only(topLeft: Radius.circular(60)),
            color: Color(0xfffcf3f4),
          ),
          child: SingleChildScrollView(
            child: BlocBuilder<BottomProfileCubit, BottomProfileState>(
              builder: (context, state) {
                if(state.listImage!=null){
                  return  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        bottom: 30.h, top: 10.h, left: 20.w, right: 20.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:3,
                      crossAxisSpacing: kIsWeb?5.w:15.w,
                      mainAxisSpacing: 15.h,
                      childAspectRatio:kIsWeb?30.w / 50.h :163.w / 218.h,
                    ),
                    itemCount: state.listImage != null
                        ? state.listImage!.length
                        : 0,
                    itemBuilder: (_, index) {
                      ImageModel image = state.listImage![index];
                      return Hero(
                        transitionOnUserGestures: true,
                        tag: image.imageUrl.replaceAll('///', '//'),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black12,

                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullPhoto(url: image.imageUrl.replaceAll('///', '//'))));
                            },
                            child: CachedNetworkImage(
                              imageUrl:image.imageUrl.replaceAll('///', '//'),
                              imageBuilder: (context, imageProvider) => Container(
                                height: 55.h,
                                width: 45.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit:kIsWeb?BoxFit.contain:BoxFit.fill,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                transform: Matrix4.translationValues(0, 0, 0),
                                child: Container(
                                    width: 55.w,
                                    height: 55.h,
                                    child: Center(child: new CircularProgressIndicator())),
                              ),
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                              width: 55.w,
                              height: 55.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }else{
                  return Center(
                    child: Container(
                      child: Text('Don\'t have photo '),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
