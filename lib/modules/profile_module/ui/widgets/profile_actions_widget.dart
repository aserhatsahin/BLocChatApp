import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/commons/widgets/submit_button_widget.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/modules/profile_module/bloc/profile_change_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileActionsWidget extends StatelessWidget {
  final UserModel user;
  final dynamic selectedImage; // Kaldırabilirsin, artık kullanılmıyor

  const ProfileActionsWidget({super.key, required this.user, this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppStyles.heightLarge),
        SubmitButton(
          onTap: () {
            context.read<ProfileChangeBloc>().add(const LogoutRequested());
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
