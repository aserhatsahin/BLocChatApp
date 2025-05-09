import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/commons/widgets/submit_button_widget.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/modules/profile_module/bloc/profile_change_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileActionsWidget extends StatelessWidget {
  final UserModel user;
  final XFile? selectedImage;

  const ProfileActionsWidget({super.key, required this.user, required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (selectedImage != null)
          SubmitButton(
            onTap: () {
              context.read<ProfileChangeBloc>().add(
                UpdateProfilePictureRequested(user: user, filePath: selectedImage!.path),
              );
            },
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.darkBackground,
              AppColors.white,
            ],
            child: Text(
              'Upload Picture',
              style: AppStyles.bodyText.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(height: AppStyles.heightLarge),
        SubmitButton(
          onTap: () {
            context.read<ProfileChangeBloc>().add(LogoutRequested());
          },
          colors: [AppColors.darkGrey, AppColors.grey, AppColors.black, AppColors.darkBackground],
          child: Text(
            'Log out',
            style: AppStyles.bodyText.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
