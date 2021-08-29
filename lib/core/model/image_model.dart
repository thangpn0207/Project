class ImageModel{
  String imageTs;
  String imageUrl;
  ImageModel({required this.imageTs,required this.imageUrl});
  Map<String,dynamic> toJson(){
    return {
      'imageTs':this.imageTs,
      'imageUrl': this.imageUrl,
    };
  }
}