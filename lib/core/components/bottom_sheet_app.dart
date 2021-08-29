
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/core/widgets/button_app.dart';
import 'package:app_web_project/features/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
showBottomSheetApp(BuildContext context, {Widget? child, String? title, bool? isScroll}) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: isScroll ?? true,
    context: context,
    builder: (context) => AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        // top: MediaQuery.of(Routes.instance.navigatorKey.currentContext!).viewPadding.top
      ),
      duration: Duration(milliseconds: 300),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.w, bottom: 20.h, top: 20.h, right: 20.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Routes.instance.pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        title??'',style: TextStyle(
                        fontSize: 18.sp
                      ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.close,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.h,
              color: HexColor('#D9D9D9'),
            ),
            child ?? Container()
          ],
        ),
      ),
    ),
  );
}

Future<PickImageType> showBottomChooseImage(BuildContext context) async {
  FocusManager.instance.primaryFocus?.unfocus();
  final type = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: ButtonApp(
                height: 50.h,
                color: Colors.white,
                title: 'Camera',
                onTap: () async {
                  var status = await Permission.camera.status;
                  if (Platform.isIOS && status.isPermanentlyDenied) {
                    showDialogIos(context);
                    return;
                  } else if (status.isDenied) {
                    var status = await Permission.camera.request().isGranted;
                    if (status) {
                      Routes.instance.pop(result: PickImageType.camera);
                    } else {
                      showDialogIos(context);
                      return;
                    }
                  } else {
                    Routes.instance.pop(result: PickImageType.camera);
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: ButtonApp(
                title: 'Gallery',
                height: 50,
                textColor: Colors.black87,
                color: Colors.white,
                sizeText: 15,
                onTap: () async {
                  var status = await Permission.photos.status;
                  if (Platform.isIOS && status.isPermanentlyDenied) {
                    showDialogIos(context);
                    return;
                  } else if (status.isDenied) {
                    var status = await Permission.photos.request().isGranted;
                    if (status) {
                      Routes.instance.pop(result: PickImageType.gallery);
                    } else {
                      showDialogIos(context);
                      return;
                    }
                  } else {
                    Routes.instance.pop(result: PickImageType.gallery);
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: ButtonApp(
                title: 'Exit',
                height: 50,
                textColor: Colors.black87,
                color: Colors.white,
                sizeText: 15,
                onTap: () {
                  Routes.instance.pop(result: PickImageType.none);
                },
              ),
            ),
          ],
        ),
      ));

  if (type != null) {
    return type;
  }

  return PickImageType.none;
}
void showDialogIos(BuildContext context) {
  showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Warning"),
          content: Text("To do this you need to grant permission"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No")),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context).pop();
                  AppSettings.openAppSettings();
                },
                child: Text("Yes")),
          ],
        );
      });
}