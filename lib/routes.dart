import 'package:flutter/material.dart';
import 'package:my_quran_id/presentation/bottom_nav/bottom_nav.dart';
import 'package:my_quran_id/presentation/detail/quran_detail_page.dart';
import 'package:my_quran_id/presentation/home/home_page.dart';

enum RouteName {
  bottomNav('/'),
  home('/home'),
  detail('/detail');

  final String name;
  const RouteName(this.name);
}

final routes = {
  RouteName.bottomNav.name: (context) => BottomNav(),
  RouteName.home.name: (context) => const HomePage(),
  RouteName.detail.name: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return QuranDetailPage(
      number: args?['number'] as int? ?? 0,
      name: args?['name'] as String? ?? '',
      isFromLastRead: args?['isFromLastRead'] as bool? ?? false,
    );
  },
};
