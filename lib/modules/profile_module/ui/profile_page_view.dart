import 'dart:io';
import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/user/firebase_user_repository.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:bloc_chatapp/modules/auth_module/ui/auth/welcome_view.dart';
import 'package:bloc_chatapp/modules/profile_module/bloc/profile_change_bloc.dart';
import 'package:bloc_chatapp/modules/profile_module/ui/widgets/profile_actions_widget.dart';
import 'package:bloc_chatapp/modules/profile_module/ui/widgets/profile_form_widget.dart';
import 'package:bloc_chatapp/modules/profile_module/ui/widgets/profile_header_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePageView extends StatelessWidget {
  final UserModel user;

  const ProfilePageView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (context) => FirebaseUserRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProfileChangeBloc(context.read<UserRepository>())),
        ],
        child: ProfileView(user: user),
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  final UserModel user;

  const ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  XFile? _image;
  String? _usernameError;
  String? _passwordError;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profil',
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppStyles.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.chatApp,
        elevation: 0,
      ),
      body: BlocListener<ProfileChangeBloc, ProfileChangeState>(
        listener: (context, state) {
          if (state is ProfileChangeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: AppStyles.bodyText),
                backgroundColor: AppColors.secondary,
              ),
            );
            if (state.message == 'Log out successfully') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeView()),
                (route) => false,
              );
            }
          } else if (state is ProfileChangeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error, style: AppStyles.bodyText),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppStyles.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileHeaderWidget(
                user: widget.user,
                selectedImage: _image,
                onPickImage: _pickImage,
              ),
              SizedBox(height: AppStyles.heightLarge),
              ProfileFormWidget(
                user: widget.user,
                usernameController: _usernameController,
                passwordController: _passwordController,
                usernameError: _usernameError,
                passwordError: _passwordError,
                onUsernameErrorChanged: (error) => setState(() => _usernameError = error),
                onPasswordErrorChanged: (error) => setState(() => _passwordError = error),
              ),
              SizedBox(height: AppStyles.heightLarge),
              ProfileActionsWidget(user: widget.user, selectedImage: _image),
            ],
          ),
        ),
      ),
    );
  }
}
