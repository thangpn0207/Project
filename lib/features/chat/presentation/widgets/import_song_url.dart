import 'package:app_web_project/core/components/text_field_nomal.dart';
import 'package:app_web_project/core/model/song.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImportSongUrl extends StatefulWidget {
  ChatRoomBloc chatRoomBloc;
  ImportSongUrl(
      {Key? key, required this.chatRoomBloc,})
      : super(key: key);

  @override
  _ImportSongUrlState createState() => _ImportSongUrlState();
}

class _ImportSongUrlState extends State<ImportSongUrl> {
  TextEditingController nameSong = TextEditingController();
  TextEditingController nameSinger = TextEditingController();
  TextEditingController songUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFieldNormal(labelText: 'Type song name',
              textEditingController: nameSong),
          SizedBox(height: 5.h),
          TextFieldNormal(labelText: 'Type singer name',
              textEditingController: nameSinger),
          SizedBox(height: 5.h),
          TextFieldNormal(labelText: 'Type song url',
              textEditingController: songUrl),
          SizedBox(height: 5.h),
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
                      Song song =Song(songUrl: songUrl.text,songName: nameSong.text,singerName: nameSinger.text);
                      widget.chatRoomBloc.add(SetUrlSong(song));
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
