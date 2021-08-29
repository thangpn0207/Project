import 'package:app_web_project/core/model/song.dart';
import 'package:app_web_project/features/chat/presentation/blocs/song_list_bloc/song_bloc.dart';
import 'package:app_web_project/features/chat/presentation/blocs/song_list_bloc/song_event.dart';
import 'package:app_web_project/features/chat/presentation/blocs/song_list_bloc/song_state.dart';
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
        appBar: AppBar(
          title: Text('List Songs'),
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Text(
            song.songName,
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        elevation: 10.0,
      ),
    );
  }
}
