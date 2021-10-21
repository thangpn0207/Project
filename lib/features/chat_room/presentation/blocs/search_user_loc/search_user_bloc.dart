import 'dart:async';

import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/services/chat_service.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/search_user_loc/search_user_event.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/search_user_loc/search_user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

class SearchUserBloc extends Bloc<SearchEvent, SearchUserState> {
  SearchUserBloc() : super(SearchUserStateInitial());
  Repository _repository = inject<Repository>();
  ChatService _chatService = inject<ChatService>();
  // StreamSubscription? searchUser;

  @override
  Stream<SearchUserState> mapEventToState(SearchEvent event) async* {
    // TODO: implement mapEventToState
    if (event is SearchEventButtonPressed) {
      yield SearchUserStateLoading();
      // searchUser?.cancel();
      //  searchUser =
      //      _repository.searchUserInfo(event.displayName).listen((users) {
      //        add(SearchEventLoad(users: users));
      //      });
      yield* _mapSearchToState(event.displayName);
    } else if (event is SearchEventLoad) {
      yield SearchUserStateLoaded(user: event.users);
    } else if (event is EventCreateChatRoom) {
      yield* _mapAddToState(event.user, event.friendUser);
    } else if (event is EventAddChatRoom) {
      yield* _mapAddChatRoomState(event.user, event.friendUser, event.nameRoom);
    } else if (event is EventGotoChatRoom) {
      yield GoToChatRoom(userModel: event.user, chatRoomInfo: event.chatRoom);
    }
  }

  Stream<SearchUserState> _mapSearchToState(String email) async* {
    UserModel? user = await _repository.searchUserByEmail(email);
    if (user != null) {
      add(SearchEventLoad(users: user));
    } else {
      yield SearchUserStateNotFound();
    }
  }

  Stream<SearchUserState> _mapAddToState(
      UserModel user, UserModel friendModel) async* {
    yield CreateChatRoom(user, friendModel);
  }

  Stream<SearchUserState> _mapAddChatRoomState(
      UserModel user, UserModel friendModel, String title) async* {
    yield SearchUserStateLoading();
    String chatRoomId =
        await _chatService.addChatRoom(user, friendModel, title);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _repository.getChatRoom(chatRoomId);
    ChatRoom chatRoomInfo = ChatRoom(
        id: documentSnapshot.data()!['id'],
        title: documentSnapshot.data()!['title'],
        imgUrl: documentSnapshot.data()!['imgUrl'],
        lastMessageBy: documentSnapshot.data()!['lastMessageBy'],
        lastMessageType: documentSnapshot.data()!['lastMessageType']);
    add(EventGotoChatRoom(user, chatRoomInfo));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
