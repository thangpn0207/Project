import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_web_project/core/components/text_field_nomal.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:flutter/material.dart';

class UploadSongInfo extends StatefulWidget {
  ChatRoomBloc chatRoomBloc;
  UploadSongInfo(
      {Key? key, required this.chatRoomBloc,})
      : super(key: key);

  @override
  _UploadSongInfoState createState() => _UploadSongInfoState();
}

class _UploadSongInfoState extends State<UploadSongInfo> {
  TextEditingController nameSong = TextEditingController();
  TextEditingController nameSinger = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFieldNormal(labelText: 'Type song name',
              textEditingController: nameSong),
          SizedBox(height: 20.h),
          TextFieldNormal(labelText: 'Type singer name',
              textEditingController: nameSinger),
          SizedBox(height: 20.h),
          Container(
            margin:
            EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w, bottom: 5.h),
            width: 364.w,
            height: 48.h,
            child: ButtonTheme(
                child: ElevatedButton(
                  onPressed: () {
                    if (
                    nameSong.text != '' && nameSinger.text!=''
                    ){
                      widget.chatRoomBloc.add(UploadInfoSong(nameSinger.text, nameSong.text, widget.chatRoomBloc.state.filePickerResult));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Upload Song",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.redAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.redAccent))),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
