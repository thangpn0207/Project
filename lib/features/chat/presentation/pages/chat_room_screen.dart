import 'package:app_web_project/core/components/bottom_sheet_app.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/song.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/navigator/route_names.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/core/utils/list_room_default.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_event.dart';
import 'package:app_web_project/features/chat/presentation/blocs/chat_room_bloc/chat_room_state.dart';
import 'package:app_web_project/features/chat/presentation/blocs/message_bloc/message_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/message_bloc/message_event.dart';
import 'package:app_web_project/features/chat/presentation/widgets/chat_message_input.dart';
import 'package:app_web_project/features/chat/presentation/widgets/import_song_url.dart';
import 'package:app_web_project/features/chat/presentation/widgets/infor_song.dart';
import 'package:app_web_project/features/chat/presentation/widgets/message.dart';
import 'package:app_web_project/features/chat/presentation/widgets/play_music.dart';
import 'package:app_web_project/features/chat/presentation/widgets/play_music_web/play_music_web.dart';
import 'package:app_web_project/features/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/list_songs.dart';

class ChatRoomScreen extends StatefulWidget {
  final UserModel userModel;
  final ChatRoom chatRoomInfo;

  ChatRoomScreen(
      {Key? key, required this.userModel, required this.chatRoomInfo})
      : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  bool check = false;
  late ChatRoomBloc chatRoomBloc;
  late bool isSimpleRoom;
  @override
  void initState() {
    chatRoomBloc = ChatRoomBloc(
        user: widget.userModel, chatRoomId: widget.chatRoomInfo.id ?? '')
      ..add(ChatRoomLoad());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isNumber = _isNumeric(widget.chatRoomInfo.id);
    if (isNumber == true) {
      isSimpleRoom =
          listRoomDefault.contains(int.parse(widget.chatRoomInfo.id ?? ''));
    } else {
      isSimpleRoom = false;
    }
    return BlocProvider<ChatRoomBloc>(
      create: (context) => chatRoomBloc,
      child: Scaffold(
          backgroundColor: HexColor('#f2ad9f'),
          //Color(0xffffae88),
          appBar: AppBar(
            automaticallyImplyLeading: !kIsWeb,
            iconTheme: IconThemeData(color: Colors.black38),
            backgroundColor: Color(0xfffcf3f4),
            centerTitle: false,
            title: Text(
              widget.chatRoomInfo.title ?? '',
              style: TextStyle(
                fontSize: 22.sp,
                color: Color(0xff6a515e),
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: <Widget>[
              isSimpleRoom == false && kIsWeb == false
                  ? IconButton(
                      onPressed: () {
                        Routes.instance.navigateTo(RouteNames.videoCall,
                            arguments: widget.chatRoomInfo);
                      },
                      icon: Icon(Icons.videocam))
                  : Container(),
              PopupMenuButton<int>(
                color: Color(0xfffcf3f4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Song',
                          textAlign: TextAlign.start,
                        ),
                        Icon(Icons.list, color: Colors.black),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Upload Song'),
                        Icon(Icons.cloud_upload_rounded, color: Colors.black),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                      value: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Song from Url'),
                          Icon(Icons.link, color: Colors.black),
                        ],
                      ))
                ],
                onCanceled: () {},
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListSongs(
                                    chatRoomId: widget.chatRoomInfo.id ?? '')))
                        .then((value) {
                      if (value != null) {
                        chatRoomBloc.add(SetUrlSong(value));
                      }
                    });
                  } else if (value == 2) {
                    chatRoomBloc.add(UploadSong());
                  } else if (value == 3) {
                    chatRoomBloc.add(ImportSongURl());
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              )
            ],
          ),
          body: BlocConsumer<ChatRoomBloc, ChatRoomState>(
            bloc: chatRoomBloc,
            listener: (context, state) {
              if (state.selectSuccess == true) {
                return showBottomSheetApp(context,
                    child: UploadSongInfo(chatRoomBloc: chatRoomBloc));
              } else if (state.setSongUrl == true) {
                return showBottomSheetApp(context,
                    child: ImportSongUrl(chatRoomBloc: chatRoomBloc));
              }
            },
            builder: (context, state) {
              if (state.isLoading == false) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Column(
                    children: <Widget>[
                      //check ? playMusic(context, path) : Container(),
                      state.isPlay == true
                          ? playMusic(
                              context,
                              state.song ??
                                  Song(
                                      singerName: '',
                                      songName: '',
                                      songUrl: ''),
                              widget.chatRoomInfo.imgUrl ?? '',
                              chatRoomBloc)
                          : Container(),
                      Expanded(
                        child: SingleChildScrollView(
                          reverse: true,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.messages!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                String beforeMessTs = '';
                                String beforeMessageSendBy = '';
                                if (index - 1 >= 0) {
                                  beforeMessTs =
                                      state.messages![index - 1].lastMessageTs;
                                  beforeMessageSendBy =
                                      state.messages![index - 1].sendBy;
                                }
                                return BlocProvider(
                                  create: (_) => MessageBLoc()
                                    ..add(MessageEventStart(
                                        message: state.messages![index])),
                                  child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<ChatRoomBloc>(context)
                                          .add(DeleteMessage(
                                              message: state.messages![index]));
                                    },
                                    child: MessageItem(
                                      userId: widget.userModel.id ?? '',
                                      message: state.messages![index],
                                      beforeMessageTs: beforeMessTs,
                                      beforeMessageSendBy: beforeMessageSendBy,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      ChatMessageInput(
                        chatRoomBloc: chatRoomBloc,
                        voidCallback: () async {
                          if (kIsWeb) {
                            chatRoomBloc.add(SendPhoto(PickImageType.none));
                          } else {
                            final type = await showBottomChooseImage(context);
                            chatRoomBloc.add(SendPhoto(type));
                          }
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('Loading'),
                );
              }
            },
          )),
    );
  }

  Widget playMusic(BuildContext context, Song song, String roomUrl,
      ChatRoomBloc chatRoomBloc) {
    if (kIsWeb) {
      return PlayMusicWeb(
          song: song,
          roomUrl: roomUrl,
          callback: () {
            chatRoomBloc.add(CloseMusic());
          });
    } else {
      return PlayAudioMusic(
          song: song,
          roomUrl: roomUrl,
          callback: () {
            chatRoomBloc.add(CloseMusic());
          });
    }
  }

  // Widget playMusic(BuildContext context, String path) {
  //   List<IconData> _icons = [Icons.play_circle_fill, Icons.pause_circle_filled];
  //   return BlocProvider<MusicBloc>(
  //     create: (context) => MusicBloc(url: path)..add(MusicStart()),
  //     child: BlocBuilder<MusicBloc, MusicState>(
  //       builder: (context, state) {
  //         if (state is MusicStateLoaded) {
  //           return Container(
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(25), color: Colors.white),
  //             padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     IconButton(
  //                       onPressed: () {
  //                         check = false;
  //                         BlocProvider.of<MusicBloc>(context)
  //                             .add(OnCloseButton());
  //                         setState(() {});
  //                       },
  //                       icon: Icon(Icons.close),
  //                       color: Colors.black,
  //                     )
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(left: 20.w, right: 20.w),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         state.newPosition.toString().split('.')[0],
  //                         style: TextStyle(fontSize: 16.sp),
  //                       ),
  //                       Text(
  //                         state.newDuration.toString().split('.')[0],
  //                         style: TextStyle(fontSize: 16.sp),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Slider(
  //                     activeColor: Colors.blue,
  //                     inactiveColor: Colors.grey,
  //                     value: state.newPosition.inSeconds.toDouble(),
  //                     min: 0.0,
  //                     max: state.newDuration.inSeconds.toDouble(),
  //                     onChanged: (double value) {
  //                       BlocProvider.of<MusicBloc>(context)
  //                           .add(OnChangeSlide(second: value.toInt()));
  //                       value = value;
  //                     }),
  //               ],
  //             ),
  //           );
  //         } else {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }
  bool _isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}
