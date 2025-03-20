// import 'dart:developer';

import 'package:bloc_chatapp/commons/widgets/input_text_field.dart';
import 'package:bloc_chatapp/commons/widgets/submit_button_widget.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/globals/styles/strings.dart';
import 'package:bloc_chatapp/modules/auth_module/bloc/authentication_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc_chatapp/commons/export_commons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final bool signUpRequired;

  const SignUpFormWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.signUpRequired,
  });

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: InputTextField(
                controller: widget.emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!emailRexExp.hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: InputTextField(
                controller: widget.passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                onChanged: (val) {
                  setState(() {
                    containsUpperCase = val!.contains(RegExp(r'[A-Z]'));
                    containsLowerCase = val.contains(RegExp(r'[a-z]'));
                    containsNumber = val.contains(RegExp(r'[0-9]'));
                    containsSpecialChar = val.contains(specialCharRexExp);
                    contains8Length = val.length >= 8;
                  });
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                      iconPassword =
                          obscurePassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill;
                    });
                  },
                  icon: Icon(iconPassword),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!passwordRexExp.hasMatch(val)) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "⚈  1 uppercase",
                      style: TextStyle(
                        color: containsUpperCase ? AppColors.darkBackground : AppColors.primary,
                      ),
                    ),
                    Text(
                      "⚈  1 lowercase",
                      style: TextStyle(
                        color: containsLowerCase ? AppColors.darkBackground : AppColors.primary,
                      ),
                    ),
                    Text(
                      "⚈  1 number",
                      style: TextStyle(
                        color: containsNumber ? AppColors.darkBackground : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "⚈  1 special character",
                      style: TextStyle(
                        color: containsSpecialChar ? AppColors.darkBackground : AppColors.primary,
                      ),
                    ),
                    Text(
                      "⚈  8 minimum character",
                      style: TextStyle(
                        color: contains8Length ? AppColors.darkBackground : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: InputTextField(
                controller: widget.nameController,
                hintText: 'Name',
                obscureText: false,
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(CupertinoIcons.person_fill),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (val.length > 30) {
                    return 'Name too long';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            !signUpRequired
                ? BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (BuildContext context, state) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: SubmitButton(
                        onTap: () {
                          UserModel user = UserModel(
                            uid: '',
                            email: widget.emailController.text,
                            username: widget.nameController.text,
                            imageUrl: '',
                          );

                          context.read<AuthenticationBloc>().add(
                            SignUpRequested(user, widget.passwordController.text),
                          );
                        },
                        colors: [
                          AppColors.primary,
                          AppColors.accent,
                          AppColors.secondary,
                          AppColors.darkBackground,
                        ],
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
