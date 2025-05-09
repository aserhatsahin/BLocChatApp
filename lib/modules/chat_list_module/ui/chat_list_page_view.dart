import 'dart:developer';
import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/chat/firebase_chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/user/firebase_user_repository.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:bloc_chatapp/modules/chat_list_module/bloc/chat_list/chat_list_bloc.dart';
import 'package:bloc_chatapp/modules/chat_list_module/bloc/search_user/search_user_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/start_chat/start_chat_bloc.dart';
import 'package:bloc_chatapp/modules/chat_list_module/ui/widgets/chat_list_widget.dart';
import 'package:bloc_chatapp/modules/chat_list_module/ui/widgets/search_bar_widget.dart';
import 'package:bloc_chatapp/modules/profile_module/ui/profile_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListPage extends StatelessWidget {
  final UserModel user;

  const ChatListPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('User Authentication Error')));
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (context) => FirebaseUserRepository()),
        RepositoryProvider<ChatRepository>(create: (context) => FirebaseChatRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SearchUserBloc(context.read<UserRepository>())),
          BlocProvider(create: (context) => StartChatBloc(context.read<ChatRepository>())),
          BlocProvider(
            create:
                (context) =>
                    ChatListBloc(context.read<ChatRepository>())
                      ..add(LoadChatsRequested(uid: currentUser.uid)),
          ),
        ],
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Sohbetler',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppStyles.textLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColors.chatApp,
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: () {
                    log('Navigating to ProfilePageView for user: ${user.uid}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MultiRepositoryProvider(
                              providers: [
                                RepositoryProvider<UserRepository>(
                                  create: (context) => FirebaseUserRepository(),
                                ),
                              ],
                              child: ProfilePageView(user: user),
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          user.imageUrl.isNotEmpty && user.imageUrl != 'No Image'
                              ? NetworkImage(user.imageUrl)
                              : null,
                      backgroundColor: AppColors.grey,
                      child:
                          user.imageUrl.isEmpty || user.imageUrl == 'No Image'
                              ? Icon(Icons.person, color: AppColors.white)
                              : null,
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SearchBarWidget(),
                  Expanded(
                    child: ChatListWidget(
                      user: user,
                      userRepository: context.read<UserRepository>(),
                      chatRepository: context.read<ChatRepository>(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
