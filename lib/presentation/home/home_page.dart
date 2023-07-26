import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_quran_id/data/model/source/remote_data_source.dart';
import 'package:my_quran_id/domain/quran_repository.dart';

import 'bloc/quran_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuranBloc(
        QuranRepository(
          RemoteDataSourceImpl(),
        ),
      )..add(LoadQuran()),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Quran ID')),
        body: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            if (state is QuranLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is QuranSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final data = state.quran[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: data.number,
                      ),
                      child: Text(data.latinName!),
                    ),
                  );
                },
                itemCount: state.quran.length,
              );
            } else if (state is QuranError) {
              return Center(child: Text(state.error));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
