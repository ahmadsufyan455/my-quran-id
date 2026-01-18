import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_quran_id/constant.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/presentation/detail/cubit/audio_cubit.dart';
import 'package:my_quran_id/presentation/detail/cubit/last_read_cubit.dart';

class DetailItemSurah extends StatelessWidget {
  final Verse data;
  final String surah;
  final int index;
  final int number;

  const DetailItemSurah({
    super.key,
    required this.data,
    required this.surah,
    required this.index,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
            decoration: BoxDecoration(
              color: darkerGreyColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: purpleColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      data.verseNumber.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: lightColor,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        context.read<AudioCubit>().playAudio(
                          data.audio.audio,
                          index,
                        );
                      },
                      child: BlocConsumer<AudioCubit, AudioState>(
                        listener: (context, state) {
                          if (state is NoInternet) {
                            Fluttertoast.showToast(
                              msg: state.message,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 14.0,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is AudioPlay && state.index == index) {
                            return SvgPicture.asset(
                              'assets/svgs/pause.svg',
                              colorFilter: const ColorFilter.mode(
                                purpleColor,
                                BlendMode.srcIn,
                              ),
                            );
                          }
                          return SvgPicture.asset(
                            'assets/svgs/play.svg',
                            colorFilter: const ColorFilter.mode(
                              purpleColor,
                              BlendMode.srcIn,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        context.read<LastReadCubit>().saveLastRead(
                          index,
                          data.arabic,
                          surah,
                          data.verseNumber,
                          number,
                        );
                      },
                      child: BlocBuilder<LastReadCubit, LastReadState>(
                        builder: (context, state) {
                          if (state.lastReadIndex != null &&
                              state.lastReadIndex == index &&
                              state.lastReadSurah == surah) {
                            return const Icon(
                              Icons.bookmark_rounded,
                              color: purpleColor,
                            );
                          }
                          return const Icon(
                            Icons.bookmark_outline_rounded,
                            color: purpleColor,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            data.arabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 26,
              color: lightColor,
              height: 2.5,
              wordSpacing: 3.0,
              fontFamily: 'Lpmq',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data.translation,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
