import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;

  UserEntity({required this.uid, required this.name, required this.email, required this.imageUrl});

  static UserEntity fromDocument(Map<String, dynamic> doc) {
    return UserEntity(
      uid: doc["uid"] as String,
      name: doc["name"] as String,
      email: doc["email"] as String,
      imageUrl: doc["imageUrl"] as String,
    );
  }

  Map<String, Object> toDocument() {
    return {'uid': uid, 'name': name, 'email': email, 'imageUrl': imageUrl};
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uid, name, email, imageUrl];

  @override
  String toString() {
    return ' UserEntity\nuid: $uid, name: $name, email: $email, imageUrl: $imageUrl ';
  }
}
