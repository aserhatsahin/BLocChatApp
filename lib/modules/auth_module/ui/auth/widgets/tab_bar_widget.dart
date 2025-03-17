

import 'package:flutter/material.dart';

import 'package:bloc_chatapp/commons/export_commons.dart';

class TabBarWidget extends StatelessWidget {
  final TabController tabController;
  const TabBarWidget({super.key, required this.tabController});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: tabController,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          labelColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.tab, // SADECE SEÇİLİ OLAN SEKMEYİ ÇİZ
          indicatorWeight: 3.5, // Çizginin kalınlığı
          indicatorPadding: EdgeInsets.zero, //sekmenin tamaminin altini kaplamasi
          indicatorColor: AppColors.primary,
          tabs: [
            Padding(
              padding: EdgeInsets.all(AppStyles.marginSmall),
              child: Text('Sign In', style: TextStyle(fontSize: AppStyles.textMedium)),
            ),
            Padding(
              padding: EdgeInsets.all(AppStyles.marginSmall),
              child: Text('Sign Up', style: TextStyle(fontSize: AppStyles.textMedium)),
            ),
          ],
        ),
       
      ],
    );
  }
}
