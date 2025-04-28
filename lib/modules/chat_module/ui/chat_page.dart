import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/data/repositories/chat/firebase_chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/user/firebase_user_repository.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPageView extends StatelessWidget {
  final String receiverUid;
  final String receiverUsername;
  const ChatPageView({super.key, required this.receiverUid, required this.receiverUsername});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(



      providers: [
        RepositoryProvider<UserRepository>(create: (context) => FirebaseUserRepository()),
        RepositoryProvider<ChatRepository>(create: (context) => FirebaseChatRepository()),

      ],
      child: MultiBlocProvider(
        providers: [
          // BlocProvider(create: (context) => ChatBloc(context.read<ChatRepository>(), receiverUid)),
          // BlocProvider(create: (context) => MessageBloc(context.read<MessageRepository>(), receiverUid)),
          // BlocProvider(create: (context) => UserBloc(context.read<UserRepository>())),
        ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            receiverUsername,
            style: TextStyle(color: AppColors.white, fontSize: AppStyles.textLarge),
          ),
          // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.back_hand))],
          backgroundColor: AppColors.darkGrey,
        ),
      ),
    ),
    );
  }
}
