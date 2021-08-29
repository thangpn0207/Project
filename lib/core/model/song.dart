class Song{
  String songName;
  String songUrl;
  Song({required this.songUrl,required this.songName});
  Map<String,dynamic> toJson(){
    return {
      'songName':this.songName,
      'songUrl': this.songUrl,
    };
  }
}