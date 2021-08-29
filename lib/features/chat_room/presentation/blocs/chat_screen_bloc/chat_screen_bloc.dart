import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_screen_event.dart';
import 'chat_screen_state.dart';
class ChatScreenBloc extends Bloc<ChatScreeEvent,ChatScreenState>{
  ChatScreenBloc():super(ChatScreenStateLoaded());
  @override
  Stream<ChatScreenState> mapEventToState(ChatScreeEvent event) async*{
    // TODO: implement mapEventToState
    if(event is ChatScreenEventToSearching){
      yield ChatScreenStateSearching(event.name);
    } else if(event is ChatScreenEventBack){
      yield ChatScreenStateLoaded();
    }
  }

}