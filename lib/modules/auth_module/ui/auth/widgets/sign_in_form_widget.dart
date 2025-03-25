import 'package:bloc_chatapp/commons/widgets/submit_button_widget.dart';
import 'package:bloc_chatapp/globals/styles/strings.dart';
import 'package:bloc_chatapp/modules/auth_module/bloc/authentication_bloc.dart';
import 'package:bloc_chatapp/modules/chat_list_module/ui/messages_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc_chatapp/commons/export_commons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// HomePage ekledik

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
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatListPage()),
          );
        } else if (state is AuthenticationFailure) {
          setState(() {
            _errorMsg = state.errorMessage;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMsg!)));
        }
      },
      child: Form(
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
                  if (val!.isEmpty) return 'Please enter your email';
                  if (!emailRexExp.hasMatch(val)) return 'Please enter a valid email';
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
                  if (val!.isEmpty) return 'Please fill in this field';
                  return null;
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
              ),
            ),
            const SizedBox(height: AppStyles.heightLarge),
            !widget.signInRequired
                ? BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: AppStyles.heightXLarge,
                      child: SubmitButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthenticationBloc>().add(
                              SignInRequested(
                                widget.emailController.text,
                                widget.passwordController.text,
                              ),
                            );
                          }
                        },
                        colors: [
                          AppColors.primary,
                          AppColors.accent,
                          AppColors.secondary,
                          AppColors.darkBackground,
                        ],
                        child:
                            state is AuthenticationLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppStyles.textMedium,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    );
                  },
                )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

extension on AuthenticationFailure {
  String? get errorMessage => null;
}
