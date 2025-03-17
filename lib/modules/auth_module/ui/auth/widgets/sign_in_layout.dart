import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/sign_in_form_widget.dart';
import 'package:flutter/cupertino.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});
  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
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
