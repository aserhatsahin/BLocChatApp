import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/sign_in_form_widget.dart';
import 'package:flutter/cupertino.dart';

class SignInLayout extends StatefulWidget {
  const SignInLayout({super.key});
  @override
  State<SignInLayout> createState() => _SignInLayoutState();
}

class _SignInLayoutState extends State<SignInLayout> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signInRequired = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: SignInFormWidget(
        signInRequired: signInRequired,
        emailController: emailController,
        passwordController: passwordController,
      ),
    );
  }
}
