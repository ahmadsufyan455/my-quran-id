import 'package:flutter/material.dart';
import 'package:my_quran_id/presentation/detail/quran_detail_page.dart';
import 'package:my_quran_id/presentation/home/home_page.dart';

final routes = {
  '/': (context) => const HomePage(),
  '/detail': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return QuranDetailPage(
      number: args?['number'] as int? ?? 0,
      name: args?['name'] as String? ?? '',
      isFromLastRead: args?['isFromLastRead'] as bool? ?? false,
    );
  },
};
