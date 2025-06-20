import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_quran_id/constant.dart';
import 'package:my_quran_id/helper.dart';
import 'package:my_quran_id/presentation/prayer/cubit/prayer_countdown_cubit.dart';
import 'package:my_quran_id/presentation/prayer/cubit/prayer_cubit.dart';

class PrayerTimePage extends StatefulWidget {
  const PrayerTimePage({super.key});

  @override
  State<PrayerTimePage> createState() => _PrayerTimePageState();
}

class _PrayerTimePageState extends State<PrayerTimePage> {
  String nearestTime = 'Subuh';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerCubit()..fetchPrayerTimes(),
      child: Scaffold(
        body: BlocBuilder<PrayerCubit, PrayerState>(
          builder: (context, state) {
            if (state is PrayerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PrayerLoaded) {
              final prayerTimes = state.prayerTimes;
              final prayers = [
                {'name': 'Subuh', 'time': prayerTimes.fajrStartTime},
                {'name': 'Dzuhur', 'time': prayerTimes.dhuhrStartTime},
                {'name': 'Ashar', 'time': prayerTimes.asrStartTime},
                {'name': 'Maghrib', 'time': prayerTimes.maghribStartTime},
                {'name': 'Isya', 'time': prayerTimes.ishaStartTime},
              ];
              return PrayerTimesList(state: state, prayers: prayers);
            } else if (state is PrayerError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Unknown state"));
          },
        ),
      ),
    );
  }
}

class PrayerTimesList extends StatelessWidget {
  final PrayerLoaded state;
  final List<Map<String, dynamic>> prayers;

  const PrayerTimesList({
    super.key,
    required this.state,
    required this.prayers,
  });

  @override
  Widget build(BuildContext context) {
    final upcomingLabel = Helper.getNearestPrayer(prayers, DateTime.now());
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PrayerCubit>().fetchPrayerTimes();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.4,
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/masjid.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(color: Colors.black.withValues(alpha: 0.4)),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hari ini',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          '${Helper.getToday()}, ${Helper.getDate()} / ${Helper.getHijrDate()}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text(
              state.cityName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: greyColor,
              ),
            ),
            const SizedBox(height: 8),
            PrayerCountdownText(prayers: prayers),
            const SizedBox(height: 20),
            PrayerTile(
              title: "Subuh",
              time: state.prayerTimes.fajrStartTime!,
              hasColor: upcomingLabel == 'Subuh',
            ),
            PrayerTile(
              title: "Dzuhur",
              time: state.prayerTimes.dhuhrStartTime!,
              hasColor: upcomingLabel == 'Dzuhur',
            ),
            PrayerTile(
              title: "Ashar",
              time: state.prayerTimes.asrStartTime!,
              hasColor: upcomingLabel == 'Ashar',
            ),
            PrayerTile(
              title: "Maghrib",
              time: state.prayerTimes.maghribStartTime!,
              hasColor: upcomingLabel == 'Maghrib',
            ),
            PrayerTile(
              title: "Isya",
              time: state.prayerTimes.ishaStartTime!,
              hasColor: upcomingLabel == 'Isya',
            ),
          ],
        ),
      ),
    );
  }
}

class PrayerTile extends StatelessWidget {
  final String title;
  final DateTime time;
  final bool hasColor;

  const PrayerTile({
    super.key,
    required this.title,
    required this.time,
    this.hasColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: hasColor ? purpleColor.withValues(alpha: 0.3) : null,
      title: Text(title, style: const TextStyle(color: greyColor)),
      trailing: Text(
        "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: lightColor,
        ),
      ),
    );
  }
}

class PrayerCountdownText extends StatelessWidget {
  final List<Map<String, dynamic>> prayers;

  const PrayerCountdownText({Key? key, required this.prayers})
    : super(key: key);

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrayerCountdownCubit(prayers),
      child: BlocBuilder<PrayerCountdownCubit, PrayerCountdownState>(
        builder: (context, state) {
          return Text(
            '${_formatDuration(state.countdown)} menuju waktu ${state.label}',
            style: const TextStyle(fontSize: 18, color: greyColor),
          );
        },
      ),
    );
  }
}
