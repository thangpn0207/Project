class UserModel{
  final String? id;
  final String? email;
  final String? displayName;
  final String? location;
  final String? phone;
  final String? age;
  final int? photos;
  final String? imgUrl;
  UserModel( {this.location, this.phone, this.age, this.photos,required this.id,required this.email,required this.displayName,required this.imgUrl});
}