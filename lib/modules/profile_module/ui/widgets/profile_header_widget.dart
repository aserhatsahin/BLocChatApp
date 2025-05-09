import 'dart:io';
import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel user;
  final XFile? selectedImage;
  final VoidCallback onPickImage;

  const ProfileHeaderWidget({
    super.key,
    required this.user,
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [AppStyles.boxShadow]),
            child: CircleAvatar(
              radius: AppStyles.borderRadiusXLarge,
              backgroundImage:
                  selectedImage != null
                      ? FileImage(File(selectedImage!.path))
                      : (user.imageUrl.isNotEmpty && user.imageUrl != 'No Image'
                              ? NetworkImage(user.imageUrl)
                              : null)
                          as ImageProvider?,
              backgroundColor: AppColors.grey,
              child:
                  selectedImage == null && (user.imageUrl.isEmpty || user.imageUrl == 'No Image')
                      ? Icon(
                        Icons.person,
                        size: AppStyles.borderRadiusXLarge,
                        color: AppColors.white,
                      )
                      : null,
            ),
          ),
        ),
        SizedBox(height: AppStyles.heightMedium),
        Text(
          'Change Profile Picture',
          style: AppStyles.bodyText.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
