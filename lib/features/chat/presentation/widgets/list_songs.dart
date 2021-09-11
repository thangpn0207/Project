import 'package:app_web_project/core/model/song.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/features/chat/presentation/blocs/song_list_bloc/song_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/song_list_bloc/song_event.dart';
import 'package:app_web_project/features/chat/presentation/blocs/song_list_bloc/song_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ListSongs extends StatefulWidget {
  String chatRoomId;

  ListSongs({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ListSongsState createState() => _ListSongsState();
}

class _ListSongsState extends State<ListSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#f2ad9f'),
        appBar: AppBar(
          title: Text('List Songs',style: TextStyle(color: Colors.black45),),
          automaticallyImplyLeading: !kIsWeb,
          iconTheme: IconThemeData(color: Colors.black38),
          backgroundColor: Color(0xfffcf3f4),
          centerTitle: false,
        ),
        body: BlocProvider(
          create: (context) =>
              SongBLoc(chatRoomId: widget.chatRoomId)..add(SongEventStart()),
          child: BlocBuilder<SongBLoc, SongState>(
            builder: (context, state) {
              if (state is SongStateLoadSuccess) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.listSong.length,
                        itemBuilder: (context, index) {
                          return buildList(context, state.listSong[index]);
                        }),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  Widget buildList(BuildContext context, Song song) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(song);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.music_note_sharp,size: 25,),
              SizedBox(width: 5,),
              Container(
                width: 250.w,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container(child: Text(song.songName,style: TextStyle(fontSize: 18.sp,color: Colors.black),overflow: TextOverflow.ellipsis,))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Container(child: Text(song.singerName,style: TextStyle(fontSize: 16.sp,color: Colors.grey),overflow: TextOverflow.ellipsis))),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(Icons.leaderboard_outlined,size: 25,)
            ],
          )
        ),
        elevation: 10.0,
      ),
    );
  }
}
