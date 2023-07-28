import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran_id/data/model/source/remote_data_source.dart';
import 'package:my_quran_id/domain/quran_repository.dart';

import 'bloc/quran_detail_bloc.dart';

class QuranDetailPage extends StatelessWidget {
  const QuranDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final number = args['number'] as int;
    final name = args['name'] as String;

    return BlocProvider(
      create: (context) =>
          QuranDetailBloc(QuranRepository(RemoteDataSourceImpl()))
            ..add(LoadQuranDetail(number)),
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
                                      data.latinName!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data.mean!,
                                      style: GoogleFonts.poppins(
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
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data.origin!.toUpperCase(),
                                          style: GoogleFonts.poppins(
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
                                            color:
                                                Colors.white.withOpacity(0.3),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${data.numberOfVerse} Ayat'
                                              .toUpperCase(),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    SvgPicture.asset(
                                        'assets/svgs/bismillah.svg'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          child: Divider(
                            color: Color(0XFFBBC4CE),
                            thickness: 1,
                          ),
                        ),
                        itemCount: state.quranDetail.verses!.length,
                        itemBuilder: (context, index) {
                          final data = state.quranDetail.verses?[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Color(0XFF863ED5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            data!.verseNumber.toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svgs/play.svg'),
                                          const SizedBox(width: 16),
                                          SvgPicture.asset(
                                            'assets/svgs/bookmark.svg',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  '${data.arabic}',
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: GoogleFonts.amiri(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: const Color(0XFF240F4F),
                                    height: 2.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    data.translation!,
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: const Color(0XFF240F4F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
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
