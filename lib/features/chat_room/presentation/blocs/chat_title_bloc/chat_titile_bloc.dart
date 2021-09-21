import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/services/repository_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import 'chat_titile_event.dart';
import 'chat_title_state.dart';

class ChatTitleBloc extends Bloc<ChatTitleEvent, ChatTitleState> {
  ChatTitleBloc() : super(ChatTitleLoading());
  Repository _repository = inject<Repository>();
  @override
  Stream<ChatTitleState> mapEventToState(ChatTitleEvent event) async* {
    // TODO: implement mapEventToState
    if (event is ChatTitleStart) {
      var userChat;
      if (event.chatRoomInfo.lastMessageBy!.isNotEmpty) {
        String? userId = event.chatRoomInfo.lastMessageBy;
        var user = await _repository.getUser(userId).then((user) {
          if (user == null) {
            return UserModel(id: '', email: '', displayName: '', imgUrl: '');
          } else {
            return user;
          }
        });
        userChat = user;
      } else {
        userChat = UserModel(id: '', email: '', displayName: '', imgUrl: '');
      }
      yield ChatTitleLoaded(
          chatRoomInfo: event.chatRoomInfo, userModel: userChat);
    }
  }
}
