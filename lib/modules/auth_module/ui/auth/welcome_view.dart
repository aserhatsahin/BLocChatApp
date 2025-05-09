import 'package:bloc_chatapp/data/repositories/chat/firebase_chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/user/firebase_user_repository.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:bloc_chatapp/modules/auth_module/bloc/authentication_bloc.dart';
import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/sign_in_layout.dart';
import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/sign_up_layout.dart';
import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/tab_bar_widget.dart';
import 'package:bloc_chatapp/modules/chat_list_module/ui/chat_list_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (context) => FirebaseUserRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthenticationBloc(context.read<UserRepository>()),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MultiRepositoryProvider(
                        providers: [
                          RepositoryProvider<UserRepository>(
                            create: (_) => FirebaseUserRepository(),
                          ),
                          RepositoryProvider<ChatRepository>(
                            create: (_) => FirebaseChatRepository(),
                          ),
                        ],
                        child: ChatListPage(user: state.user),
                      ),
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Welcome to Chat App!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(height: 50, child: TabBarWidget(tabController: tabController)),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: TabBarView(
                          controller: tabController,
                          children: const [SignInLayout(), SignUpLayout()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
