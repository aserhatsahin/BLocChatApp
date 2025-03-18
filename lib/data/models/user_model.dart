import 'package:bloc_chatapp/data/entitites/user_entity.dart';
import 'package:equatable/equatable.dart';


class UserModel extends Equatable {
  final String uid;
  final String email;
  final String username;

  final String imageUrl;

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.imageUrl,
  });

  UserEntity toEntity() {
    return UserEntity(uid: uid, email: email, name: username, imageUrl: imageUrl);
  }


  // getter to determine whether the current user is empty
  bool get isEmpty => this == UserModel.empty;
  //getter to determine whether the current user is not empty
  bool get isNotEmpty => this != UserModel.empty;


  UserModel copyWith({String? uid, String? email, String? username, String? imageUrl}) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  static var empty = UserModel(uid: '', email: '', username: '', imageUrl: '');
  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      username: entity.name,
      imageUrl: entity.imageUrl,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uid, email, username, imageUrl];
}
