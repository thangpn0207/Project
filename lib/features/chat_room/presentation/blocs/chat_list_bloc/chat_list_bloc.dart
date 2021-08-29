import 'dart:async';
import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/services/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent,ChatListState>{
  final UserModel userModel;
  ChatListBloc({required this.userModel}):super(ChatListInitial());
  ChatService _chatService = inject<ChatService>();
  StreamSubscription ?chatList;
  StreamSubscription ?chatRoomInfoList;

  @override
  Stream<ChatListState> mapEventToState(ChatListEvent event) async*{
    // TODO: implement mapEventToState
  if(event is ChatListStart){
    yield ChatListLoading();
    chatList?.cancel();
    chatList = _chatService.getChatList(userModel.id).listen((list){
      chatRoomInfoList?.cancel();
     if(list.length==0){
       add(ChatListLoaded(chatList: <ChatRoom>[]));
     }else{
       chatRoomInfoList=_chatService.getChatRoomInfo(list).listen((rooms) {
         add(ChatListLoaded(chatList: rooms));
       });
     }
    }
    );
  }else if(event is ChatListLoaded){
    yield* _mapChatListLoadToState(event.chatList);
  }
  }
  Stream<ChatListState> _mapChatListLoadToState(List<ChatRoom> rooms) async* {
    rooms.sort((a, b) {
      if(a.lastMessageTs!='' && b.lastMessageTs!=''){
        return b.lastMessageTs!.compareTo(a.lastMessageTs!);
      }else{
        return b.id!.compareTo(a.id!);
      }
    });

    yield ChatListLoadSuccess(chatList: rooms);
  }
  @override
  Future<void> close() {
    chatList?.cancel();
    chatRoomInfoList?.cancel();
    return super.close();
  }
}