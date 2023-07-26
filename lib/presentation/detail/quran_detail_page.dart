import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_quran_id/data/model/source/remote_data_source.dart';
import 'package:my_quran_id/domain/quran_repository.dart';

import 'bloc/quran_detail_bloc.dart';

class QuranDetailPage extends StatelessWidget {
  const QuranDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int number = ModalRoute.of(context)?.settings.arguments as int;

    return BlocProvider(
      create: (context) =>
          QuranDetailBloc(QuranRepository(RemoteDataSourceImpl()))
            ..add(LoadQuranDetail(number)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail Surah')),
        body: BlocBuilder<QuranDetailBloc, QuranDetailState>(
          builder: (context, state) {
            if (state is QuranDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuranDetailSuccess) {
              return ListView.builder(
                itemCount: state.quranDetail.verses?.length,
                itemBuilder: (context, index) {
                  final data = state.quranDetail.verses?[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${data?.verseNumber}'),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            '${data?.arabic}',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
