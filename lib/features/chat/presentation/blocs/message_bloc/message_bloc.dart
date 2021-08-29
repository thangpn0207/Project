
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/services/repository_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import 'message_event.dart';
import 'message_state.dart';


class MessageBLoc extends Bloc<MessageEvent, MessageState> {
  MessageBLoc() :super(MessageStateLoading());
  Repository _repository = inject<Repository>();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    // TODO: implement mapEventToState
    if (event is MessageEventStart) {
        String userId = event.message.sendBy;
          var user = await _repository.getUser(userId).then((user) {
          if (user == null) {
            return UserModel(id: '', email: '', displayName: '', imgUrl: '');
          } else {
            return user;
          }
        });
      yield MessageStateLoaded(userModel: user, message: event.message);
    }
  }
}