class Song{
  String songName;
  String singerName;
  String songUrl;
  Song({required this.songUrl,required this.songName,required this.singerName});
  Map<String,dynamic> toJson(){
    return {
      'songName':this.songName,
      'songUrl': this.songUrl,
      'singerName':this.singerName
    };
  }
}