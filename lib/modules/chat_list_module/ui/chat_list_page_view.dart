import 'package:bloc_chatapp/data/repositories/chat/firebase_chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/user/firebase_user_repository.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:bloc_chatapp/modules/chat_list_module/bloc/chat_list/chat_list_bloc.dart';
import 'package:bloc_chatapp/modules/chat_list_module/bloc/search_user/search_user_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/start_chat/start_chat_bloc.dart'; // Hazır BLoC'un
import 'package:bloc_chatapp/modules/chat_list_module/ui/widgets/chat_list_widget.dart';
import 'package:bloc_chatapp/modules/chat_list_module/ui/widgets/search_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (context) => FirebaseUserRepository()),
        RepositoryProvider<ChatRepository>(create: (context) => FirebaseChatRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SearchUserBloc(context.read<UserRepository>())),
          BlocProvider(create: (context) => StartChatBloc(context.read<ChatRepository>())),
          BlocProvider(create: (context) => ChatListBloc(context.read<ChatRepository>())),
        ],
        child: Builder(
          builder: (context) {
            // ChatListBloc event gönderimi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                context.read<ChatListBloc>().add(LoadChatsRequested(uid: currentUser.uid));
              }
            });

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(title: const Text("Chat List")),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SearchBarWidget(), // Sadece arama çubuğu
                      const Expanded(child: ChatListWidget()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
