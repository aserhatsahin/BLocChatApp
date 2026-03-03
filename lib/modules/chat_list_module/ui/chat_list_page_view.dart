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
import 'package:mesh_gradient/mesh_gradient.dart';

class ChatListPage extends StatelessWidget {
  final UserModel user;

  const ChatListPage({super.key, required this.user});

  Future<void> _navigateToProfile(BuildContext context, UserModel currentUser) async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePageView(user: currentUser)),
    );

    // StreamBuilder zaten güncellemeleri halledeceği için setState gerekmiyor
  }

  @override
  Widget build(BuildContext context) {
    final currentUserFirebase = FirebaseAuth.instance.currentUser;

    if (currentUserFirebase == null) {
      return const Scaffold(body: Center(child: Text('Kullanıcı Doğrulama Hatası')));
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
                      ..add(LoadChatsRequested(uid: currentUserFirebase.uid)),
          ),
        ],
        child: StreamBuilder<UserModel>(
          stream: context.read<UserRepository>().streamUserData(currentUserFirebase.uid),
          initialData: user, // Başlangıçta widget.user’ı kullan
          builder: (context, snapshot) {
            UserModel currentUser = user; // Varsayılan olarak widget.user
            if (snapshot.hasData) {
              currentUser = snapshot.data!; // Stream’den gelen güncel veri
            } else if (snapshot.hasError) {
              log('Stream hatası: ${snapshot.error}');
              return const Scaffold(body: Center(child: Text('Kullanıcı verisi yüklenemedi')));
            }

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text(
                    'Sohbetler',
                    style: TextStyle(
                      color: AppColors.darkBackground,
                      fontSize: AppStyles.textLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: false,
                  backgroundColor: AppColors.background.withOpacity(0.95),
                  elevation: 0,
                  actions: [
                    GestureDetector(
                      onTap: () => _navigateToProfile(context, currentUser),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              currentUser.imageUrl.isNotEmpty && currentUser.imageUrl != 'No Image'
                                  ? NetworkImage(
                                    '${currentUser.imageUrl}?ts=${DateTime.now().millisecondsSinceEpoch}',
                                  )
                                  : null,
                          backgroundColor: AppColors.grey,
                          child:
                              currentUser.imageUrl.isEmpty || currentUser.imageUrl == 'No Image'
                                  ? Icon(Icons.person, color: AppColors.white)
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
                body: AnimatedMeshGradient(
                  colors: const [
                    AppColors.background,
                    Colors.white,
                    AppColors.secondary,
                    AppColors.accent,
                  ],
                  options: AnimatedMeshGradientOptions(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SearchBarWidget(),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ChatListWidget(
                              user: currentUser,
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
          },
        ),
      ),
    );
  }
}
