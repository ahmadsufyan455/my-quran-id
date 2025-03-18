import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_quran_id/helper.dart';
import 'package:my_quran_id/presentation/prayer/cubit/prayer_cubit.dart';

class PrayerTimePage extends StatelessWidget {
  const PrayerTimePage({super.key});

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
              return PrayerTimesList(state: state);
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

  const PrayerTimesList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PrayerCubit>().fetchPrayerTimes();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
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
                ),
              ),
              const SizedBox(height: 20),
              PrayerTile(
                title: "Subuh",
                time: state.prayerTimes.fajrStartTime!,
              ),
              PrayerTile(
                title: "Dzuhur",
                time: state.prayerTimes.dhuhrStartTime!,
              ),
              PrayerTile(title: "Ashar", time: state.prayerTimes.asrStartTime!),
              PrayerTile(
                title: "Maghrib",
                time: state.prayerTimes.maghribStartTime!,
              ),
              PrayerTile(title: "Isya", time: state.prayerTimes.ishaStartTime!),
            ],
          ),
        ),
      ),
    );
  }
}

class PrayerTile extends StatelessWidget {
  final String title;
  final DateTime time;

  const PrayerTile({super.key, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(
        "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
