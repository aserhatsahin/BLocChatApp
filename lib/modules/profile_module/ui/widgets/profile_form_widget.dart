import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/commons/widgets/input_text_field.dart';
import 'package:bloc_chatapp/commons/widgets/submit_button_widget.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/modules/profile_module/bloc/profile_change_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileFormWidget extends StatelessWidget {
  final UserModel user;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String? usernameError;
  final String? passwordError;
  final Function(String?) onUsernameErrorChanged;
  final Function(String?) onPasswordErrorChanged;

  const ProfileFormWidget({
    Key? key,
    required this.user,
    required this.usernameController,
    required this.passwordController,
    required this.usernameError,
    required this.passwordError,
    required this.onUsernameErrorChanged,
    required this.onPasswordErrorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Username
        InputTextField(
          controller: usernameController,
          hintText: 'New Username',
          obscureText: false,
          keyboardType: TextInputType.text,
          errorMsg: usernameError,
          validator: (value) {
            if (value == null || value.isEmpty) {
              onUsernameErrorChanged('Username cannot be empty');
              return 'Username cannot be empty';
            }
            if (value.length < 3) {
              onUsernameErrorChanged('Username must be at least 3 characters');
              return 'Username must be at least 3 characters';
            }
            onUsernameErrorChanged(null);
            return null;
          },
          onChanged: (_) => onUsernameErrorChanged(null),
        ),
        SizedBox(height: AppStyles.heightLarge),
        // Password
        InputTextField(
          controller: passwordController,
          hintText: 'New Password',
          obscureText: true,
          keyboardType: TextInputType.text,
          errorMsg: passwordError,
          validator: (value) {
            if (value != null && value.isNotEmpty && value.length < 6) {
              onPasswordErrorChanged('Password must be at least 6 characters');
              return 'Password must be at least 6 characters';
            }
            onPasswordErrorChanged(null);
            return null;
          },
          onChanged: (_) => onPasswordErrorChanged(null),
        ),
        SizedBox(height: AppStyles.heightLarge),
        SubmitButton(
          onTap: () {
            final bloc = context.read<ProfileChangeBloc>();
            bool changesMade = false;

            if (usernameController.text != user.username) {
              bloc.add(UpdateUsernameRequested(user: user, newUsername: usernameController.text));
              changesMade = true;
            }

            if (passwordController.text.isNotEmpty) {
              bloc.add(UpdatePasswordRequested(newPassword: passwordController.text));
              changesMade = true;
            }

            if (!changesMade) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No changes to save'), backgroundColor: AppColors.grey),
              );
            }
          },
          colors: [
            AppColors.primary,
            AppColors.secondary,
            AppColors.darkBackground,
            AppColors.white,
          ],
          child: Text(
            'Save',
            style: AppStyles.bodyText.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
