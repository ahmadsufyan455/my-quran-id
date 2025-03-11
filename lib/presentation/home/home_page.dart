import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_quran_id/data/model/source/remote_data_source.dart';
import 'package:my_quran_id/domain/quran_repository.dart';
import 'package:my_quran_id/helper.dart';

import 'bloc/quran_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              QuranBloc(QuranRepository(RemoteDataSourceImpl()))
                ..add(LoadQuran()),
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
                          return GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: {
                                    'number': data.number,
                                    'name': data.latinName,
                                  },
                                ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/images/bg_number.png',
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            data.number.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0XFF240F4F),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.latinName!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0XFF240F4F),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                data.origin!.toUpperCase(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Color(0XFF8789A3),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Container(
                                                width: 4,
                                                height: 4,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0XFFBBC4CE),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '${data.numberOfVerse} Ayat'
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Color(0XFF8789A3),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28,
                                      color: Color(0XFF863ED5),
                                      fontFamily: 'Lpmq',
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                            ),
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
