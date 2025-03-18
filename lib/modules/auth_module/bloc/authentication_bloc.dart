import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:bloc/bloc.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/user/firebase_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseUserRepository _userRepository;

  AuthenticationBloc(FirebaseUserRepository userRepository)
    : _userRepository = userRepository,
      super(AuthenticationInitial()) {
    on<SignInRequested>((event, emit) async {
      try {
        emit(AuthenticationLoading());
        await _userRepository.signIn(event.email, event.password);

        // Firebase, kullanıcı giriş yaptıktan sonra UID'yi atar.
        // Bu yüzden giriş event'inde UID olmaz, giriş yapıldıktan sonra FirebaseAuth'tan almak gerekir.
        final uid = FirebaseAuth.instance.currentUser!.uid;

        if (uid.isNotEmpty) {
          UserModel userModel = await _userRepository.getUserData(uid);

          if (userModel.isNotEmpty) {
            emit(AuthenticationSuccess(userModel));
          }
        } else {
          emit(AuthenticationFailure('User not found'));
        }
      } catch (e) {
        emit(AuthenticationFailure(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      try {
        emit(AuthenticationLoading());
        await _userRepository.signUp(event.user, event.password);
        final uid = FirebaseAuth.instance.currentUser!.uid;
        UserModel userModel = await userRepository.getUserData(uid);

        if (userModel.isNotEmpty) {
          emit(AuthenticationSuccess(userModel));
        } else {
          emit(AuthenticationFailure('Cannot sign up'));
        }
      } catch (e) {
        emit(AuthenticationFailure(e.toString()));
      }
    });

    on<LogOutRequested>((event, emit) async {
      try {
        await _userRepository.logOut();
        emit(AuthenticationEnded());
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
