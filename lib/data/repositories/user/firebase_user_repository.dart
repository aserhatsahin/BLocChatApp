import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

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
      await userCollection.doc(user.uid).set(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
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
  Future<void> signUp(UserModel user, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: password);
      user = user.copyWith(uid: user.uid); //user.user!.uid ?
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadPicture(String file, String uid) async {
    try {
      File imageFile = File(file);
      Reference firebaseStoreRef = FirebaseStorage.instance.ref().child(
        '$uid/PP/${uid}_lead',
        //resmin kaydedilecegi dosyanin firebase storegadaki yolu
      );
      await firebaseStoreRef.putFile(imageFile); //Upload picture to storage

      ///GET FOWNLOAD URL

      String url = await firebaseStoreRef.getDownloadURL();
      await userCollection.doc(uid).update({'imageURL': url}); //firestore a img url kaydetmek

      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
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
          username: firebaseUser.displayName ?? '',
          imageUrl: firebaseUser.photoURL ?? '',
        );
      }
    });
  }
}
