import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_quran_id/domain/quran_repository.dart';
import 'package:my_quran_id/helper.dart';
import 'package:my_quran_id/presentation/detail/cubit/last_read_cubit.dart';
import 'package:my_quran_id/presentation/widgets/list_item_surah.dart';

import 'bloc/quran_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuranBloc(QuranRepository())..add(LoadQuran()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<QuranBloc, QuranState>(
            builder: (context, state) {
              if (state is QuranLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is QuranSuccess) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: SvgPicture.asset(
                              'assets/svgs/welcome.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Helper.getToday(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  Helper.getHijrDate(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                BlocBuilder<LastReadCubit, LastReadState>(
                                  builder: (context, lastReadState) {
                                    if (lastReadState.lastReadSurah != null &&
                                        lastReadState.verseNumber != null) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.book_rounded,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'Terakhir dibaca',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${lastReadState.lastReadSurah} - Ayat ${lastReadState.verseNumber}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder:
                            (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Divider(
                                color: Color(0XFFBBC4CE),
                                thickness: 1,
                              ),
                            ),
                        itemBuilder: (context, index) {
                          final data = state.quran[index];
                          return ListItemSurah(
                            data: data,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: {
                                  'number': data.number,
                                  'name': data.latinName,
                                },
                              ).then((_) {
                                if (!context.mounted) return;
                                context.read<LastReadCubit>().loadLastRead();
                              });
                            },
                          );
                        },
                        itemCount: state.quran.length,
                      ),
                    ),
                  ],
                );
              } else if (state is QuranError) {
                return Center(child: Text(state.error));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
