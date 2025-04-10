import 'dart:developer';
import 'package:bloc_chatapp/data/entitites/user_entity.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');

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

  // Diğer metodlar değişmedi
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
      _firebaseAuth.signOut();
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
      throw Exception("Firestore kullanıcı eklenemedi");
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
      throw e;
    }
  }

  @override
  Future<String> uploadPicture(String file, String uid) async {
    throw UnimplementedError();
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
          username: firebaseUser.displayName ?? '',
          imageUrl: firebaseUser.photoURL ?? '',
        );
      }
    });
  }
Future<String> getUsername(String uid) async {
    final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return doc.data()?['username'] ?? 'Unknown';
  }
}
