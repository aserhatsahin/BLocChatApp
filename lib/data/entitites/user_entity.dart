import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String username; // name yerine username
  final String email;
  final String imageUrl;

  UserEntity({
    required this.uid,
    required this.username, // name yerine username
    required this.email,
    required this.imageUrl,
  });

  static UserEntity fromDocument(Map<String, dynamic> doc) {
    return UserEntity(
      uid: doc["uid"] as String? ?? '',
      username: doc["username"] as String? ?? '', // name yerine username
      email: doc["email"] as String? ?? '',
      imageUrl: doc["imageUrl"] as String? ?? 'No Image',
    );
  }

  Map<String, Object> toDocument() {
    return {'uid': uid, 'username': username, 'email': email, 'imageUrl': imageUrl};
  }

  @override
  List<Object?> get props => [uid, username, email, imageUrl];

  @override
  String toString() {
    return ' UserEntity\nuid: $uid, username: $username, email: $email, imageUrl: $imageUrl ';
  }
}
