abstract class ChatScreeEvent {}
class ChatScreenEventToSearching extends ChatScreeEvent{
  String name;
  ChatScreenEventToSearching(this.name);
}
class ChatScreenEventBack extends ChatScreeEvent{}