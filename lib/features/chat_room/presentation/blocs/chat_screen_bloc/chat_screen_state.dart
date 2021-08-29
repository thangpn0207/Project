abstract class ChatScreenState{}
class ChatScreenStateLoaded extends ChatScreenState{}
class ChatScreenStateSearching extends ChatScreenState{
String name;
ChatScreenStateSearching(this.name);
}