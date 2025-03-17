import 'package:bloc_chatapp/commons/widgets/submit_button_widget.dart';
import 'package:bloc_chatapp/globals/styles/strings.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:bloc_chatapp/commons/export_commons.dart';

class SignInFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool signInRequired;

  const SignInFormWidget({
    super.key,
    required this.signInRequired,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  final _formKey = GlobalKey<FormState>();

  String? _errorMsg;

  bool obscurePassword = true;

  IconData iconPassword = CupertinoIcons.eye_fill;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,

      child: Column(
        children: [
          const SizedBox(height: AppStyles.heightLarge),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: InputTextField(
              controller: widget.emailController,
              hintText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(CupertinoIcons.mail_solid),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter your email';
                } else if (!emailRexExp.hasMatch(val)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: AppStyles.heightMedium),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: InputTextField(
              controller: widget.passwordController,
              hintText: 'Password',
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(CupertinoIcons.lock_fill),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please fill in this field';
                } else if (!passwordRexExp.hasMatch(val)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                    if (obscurePassword) {
                      iconPassword = CupertinoIcons.eye_fill;
                    } else {
                      iconPassword = CupertinoIcons.eye_slash_fill;
                    }
                  });
                },
                icon: Icon(iconPassword),
              ),
            ),
          ),
          const SizedBox(height: AppStyles.heightLarge),
          !widget.signInRequired
              ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: AppStyles.heightXLarge,
                child: SubmitButton(
                  onTap: () {},
                  colors: [
                    AppColors.primary,
                    AppColors.accent,
                    AppColors.secondary,
                    AppColors.darkBackground,
                  ],
                  child: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppStyles.textMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // child: TextButton(
                //   onPressed: () {},
                //   style: TextButton.styleFrom(
                //     elevation: 3.0,
                //     backgroundColor: AppColors.primary,
                //     foregroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                //   ),
                //   child: const Padding(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: AppStyles.paddingMedium,
                //       vertical: AppStyles.paddingSmall,
                //     ),
                //     child: Text(
                //       'Sign In',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: AppStyles.textMedium,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // ),
              )
              : CircularProgressIndicator(),
        ],
      ),
    );
  }
}
