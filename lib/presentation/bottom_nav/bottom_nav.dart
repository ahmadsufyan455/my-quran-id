import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_quran_id/constant.dart';
import 'package:my_quran_id/presentation/bottom_nav/cubit/bottom_nav_cubit.dart';
import 'package:my_quran_id/presentation/home/home_page.dart';
import 'package:my_quran_id/presentation/prayer/prayer_time_page.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  final List<Widget> pages = [const HomePage(), const PrayerTimePage()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: pages[currentIndex],
            bottomNavigationBar: _buildNavigationBar(
              context,
              currentIndex,
              theme,
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Build Navigation Bar
  Widget _buildNavigationBar(
    BuildContext context,
    int currentIndex,
    ThemeData theme,
  ) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: theme.colorScheme.primary,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? purpleColor
                : greyColor,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
      child: NavigationBar(
        indicatorColor: Colors.transparent,
        backgroundColor: darkerGreyColor,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) =>
            context.read<BottomNavCubit>().changeTab(index),
        destinations: _buildNavigationDestinations(),
      ),
    );
  }

  /// 🔹 Build Navigation Destinations
  List<NavigationDestination> _buildNavigationDestinations() {
    return [
      _buildNavItem('assets/svgs/quran.svg', 'Qur\'an'),
      _buildNavItem('assets/svgs/prayer.svg', 'Jadwal Sholat'),
    ];
  }

  /// 🔹 Build Individual Navigation Item
  NavigationDestination _buildNavItem(String iconPath, String label) {
    return NavigationDestination(
      selectedIcon: SvgPicture.asset(
        iconPath,
        colorFilter: const ColorFilter.mode(purpleColor, BlendMode.srcIn),
      ),
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}
