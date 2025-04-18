import 'package:bloc_chatapp/data/models/user_model.dart';

abstract class UserRepository {
  Stream<UserModel?> get userModel;
  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<UserModel> signUp(UserModel user, String password);

  Future<void> setUserData(UserModel user);

  Future<UserModel> getUserData(String uid);

  Future<String> uploadPicture(String file, String uid);

  Future<List<UserModel>> searchUsers(String username);
}
