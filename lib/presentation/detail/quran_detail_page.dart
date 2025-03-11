import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_quran_id/domain/quran_repository.dart';
import 'package:my_quran_id/presentation/detail/cubit/audio_cubit.dart';
import 'package:my_quran_id/presentation/widgets/detail_item_surah.dart';

import 'bloc/quran_detail_bloc.dart';

class QuranDetailPage extends StatefulWidget {
  const QuranDetailPage({super.key});

  @override
  State<QuranDetailPage> createState() => _QuranDetailPageState();
}

class _QuranDetailPageState extends State<QuranDetailPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final number = args['number'] as int;
    final name = args['name'] as String;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  QuranDetailBloc(QuranRepository())
                    ..add(LoadQuranDetail(number)),
        ),
        BlocProvider(create: (context) => AudioCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(name)),
        body: BlocBuilder<QuranDetailBloc, QuranDetailState>(
          builder: (context, state) {
            if (state is QuranDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuranDetailSuccess) {
              final data = state.quranDetail;
              return Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 257,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(
                                      4,
                                      6,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                'assets/svgs/detail_surah.svg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      data.latinName,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data.mean,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 34,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data.origin.toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 4,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${data.numberOfVerse} Ayat'
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    SvgPicture.asset(
                                      'assets/svgs/bismillah.svg',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder:
                            (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              child: Divider(
                                color: Color(0XFFBBC4CE),
                                thickness: 1,
                              ),
                            ),
                        itemCount: state.quranDetail.verses.length,
                        itemBuilder: (context, index) {
                          final data = state.quranDetail.verses[index];
                          return DetailItemSurah(data: data, index: index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is QuranDetailError) {
              return Center(child: Text(state.error));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
