import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/presentation/detail/cubit/audio_cubit.dart';

class DetailItemSurah extends StatelessWidget {
  final Verse data;
  final int index;
  const DetailItemSurah({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade400.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0XFF863ED5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      data.verseNumber.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
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
                      child: BlocBuilder<AudioCubit, AudioState>(
                        builder: (context, state) {
                          if (state is AudioPlay && state.index == index) {
                            return SvgPicture.asset('assets/svgs/pause.svg');
                          }
                          return SvgPicture.asset('assets/svgs/play.svg');
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SvgPicture.asset('assets/svgs/bookmark.svg'),
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
              fontSize: 24,
              color: Color(0XFF240F4F),
              height: 2.5,
              fontFamily: 'Lpmq',
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
                color: Color(0XFF240F4F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
