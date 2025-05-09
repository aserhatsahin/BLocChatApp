import 'package:bloc_chatapp/data/models/user_model.dart';

abstract class UserRepository {
  // Kullanıcı modelini stream olarak döndürür
  Stream<UserModel?> get userModel;

  // Kullanıcı girişi
  Future<void> signIn(String email, String password);

  // Kullanıcı çıkışı
  Future<void> logOut();

  // Yeni kullanıcı kaydı
  Future<UserModel> signUp(UserModel user, String password);

  // Kullanıcı verilerini Firestore'a kaydeder (yeni kullanıcı için)
  Future<void> setUserData(UserModel user);

  // Kullanıcı verilerini getirir
  Future<UserModel> getUserData(String uid);

  // Profil fotoğrafı yükler
  Future<String> uploadPicture(String filePath, String uid);

  // Kullanıcıları arar
  Future<List<UserModel>> searchUsers(String username);

  // Kullanıcı adını getirir
  Future<String> getUsername(String uid);

  // Kullanıcı verilerini günceller (mevcut kullanıcı için)
  Future<void> updateUserData(UserModel user);

  // Şifreyi günceller
  Future<void> updatePassword(String newPassword);
}
