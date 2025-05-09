import 'dart:developer';
import 'dart:io';
import 'package:bloc_chatapp/data/entitites/user_entity.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<UserModel>> searchUsers(String username) async {
    try {
      log("Searching users for: $username");
      final snapshot =
          await userCollection
              .where('username', isGreaterThanOrEqualTo: username)
              .where('username', isLessThanOrEqualTo: username + '\uf8ff')
              .get();
      log('Search complete ${snapshot.docs.length} users found');
      final users =
          snapshot.docs.map((doc) {
            final data = doc.data();
            log("User found: $data");
            return UserModel.fromEntity(UserEntity.fromDocument(data));
          }).toList();
      log('Fetched users: $users');
      return users;
    } catch (e) {
      log("Error in searchUsers: $e");
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserData(String uid) {
    try {
      return userCollection
          .doc(uid)
          .get()
          .then((doc) => UserModel.fromEntity(UserEntity.fromDocument(doc.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(UserModel user) async {
    try {
      await userCollection.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'username': user.username,
        'imageUrl': user.imageUrl,
      });
    } catch (e) {
      throw Exception("Firestore kullanıcı eklenemedi: $e");
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp(UserModel user, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      UserModel updatedUser = UserModel(
        uid: userCredential.user!.uid,
        email: user.email,
        username: user.username,
        imageUrl: user.imageUrl,
      );
      return updatedUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadPicture(String filePath, String uid) async {
    try {
      File file = File(filePath);
      String fileName = 'profile_$uid.jpg';
      Reference storageRef = _storage.ref().child('profile_pictures/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("Error uploading picture: $e");
      throw Exception("Profil fotoğrafı yüklenemedi: $e");
    }
  }

  @override
  Stream<UserModel?> get userModel {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      } else {
        return UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          username: '', // Authentication'dan username almıyoruz
          imageUrl: '', // Authentication'dan imageUrl almıyoruz
        );
      }
    });
  }

  @override
  Future<String> getUsername(String uid) async {
    final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return doc.data()?['username'] ?? 'Unknown';
  }

  // Kullanıcı adını chats koleksiyonunda güncelle
  Future<void> _updateUsernameInChats(String uid, String newUsername) async {
    try {
      final chatsSnapshot =
          await firestore.collection('chats').where('participantIds', arrayContains: uid).get();

      for (var doc in chatsSnapshot.docs) {
        final data = doc.data();
        final participantIds = List<String>.from(data['participantIds'] ?? []);
        final participantNames = List<String>.from(data['participantNames'] ?? []);
        final index = participantIds.indexOf(uid);
        if (index != -1 && index < participantNames.length) {
          participantNames[index] = newUsername;
          await firestore.collection('chats').doc(doc.id).update({
            'participantNames': participantNames,
          });
        }
      }
    } catch (e) {
      log("Error updating username in chats: $e");
      throw Exception("Sohbetlerde kullanıcı adı güncellenemedi: $e");
    }
  }

  // Kullanıcı bilgilerini güncelle
  Future<void> updateUserData(UserModel user) async {
    try {
      await userCollection.doc(user.uid).update({
        'username': user.username,
        'imageUrl': user.imageUrl,
      });

      // Kullanıcı adını chats koleksiyonunda güncelle
      await _updateUsernameInChats(user.uid, user.username);
    } catch (e) {
      log("Error updating user data: $e");
      throw Exception("Kullanıcı bilgileri güncellenemedi: $e");
    }
  }

  // Şifreyi güncelle
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        await user.reload();
      } else {
        throw Exception("Kullanıcı oturumu açık değil");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception("Şifre değiştirmek için lütfen tekrar giriş yapın.");
      }
      log("Error updating password: $e");
      throw Exception("Şifre güncellenemedi: $e");
    } catch (e) {
      log("Error updating password: $e");
      throw Exception("Şifre güncellenemedi: $e");
    }
  }
}
