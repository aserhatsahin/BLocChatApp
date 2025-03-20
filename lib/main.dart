import 'package:bloc_chatapp/app.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   if (user == null) {
  //     log("⚠️ Kullanıcı oturumu açık değil.");
  //   } else {
  //     log("✅ Kullanıcı giriş yapmış: ${user.email}");
  //   }
  // });

  // FirebaseAuth.instance
  //     // ignore: deprecated_member_use
  //     .fetchSignInMethodsForEmail("test@gmail.com")
  //     .then((methods) {
  //       if (methods.isEmpty) {
  //         log("🔴 Bu e-posta ile kayıtlı kullanıcı YOK.");
  //       } else {
  //         log("✅ Kullanıcı Firebase'de var: ${methods}");
  //       }
  //     })
  //     .catchError((error) {
  //       log("🚨 Firebase Kullanıcı Hatası: $error");
  //     });

  runApp(MainApp());
}
