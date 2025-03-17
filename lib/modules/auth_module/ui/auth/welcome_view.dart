import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/sign_in_layout.dart';
import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/sign_up_layout.dart';
import 'package:bloc_chatapp/modules/auth_module/ui/auth/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:bloc_chatapp/commons/export_commons.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with TickerProviderStateMixin {
  ///with TickerProviderStateMixin to use AnimationController
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppStyles.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppStyles.heightLarge),
                Text(
                  'Welcome to Chat App!',
                  style: TextStyle(fontSize: AppStyles.textLarge, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: kToolbarHeight),
                SizedBox(
                  height: AppStyles.heightXLarge,
                  child: TabBarWidget(tabController: tabController),
                ),
                const SizedBox(height: AppStyles.heightLarge),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6, // Ekranın %60'ı kadar yükseklik

                  child: Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [SignInView(), SignUpView()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
