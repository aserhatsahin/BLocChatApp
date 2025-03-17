import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/sign_up_form_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpLayout extends StatefulWidget {
  const SignUpLayout({super.key});

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signUpRequired = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: SignUpFormWidget(
        signUpRequired: signUpRequired,
        emailController: emailController,
        nameController: nameController,
        passwordController: passwordController,
      ),
    );
  }
}
