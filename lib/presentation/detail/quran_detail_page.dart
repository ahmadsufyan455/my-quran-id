import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_quran_id/constant.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/domain/quran_repository.dart';
import 'package:my_quran_id/main.dart';
import 'package:my_quran_id/presentation/detail/cubit/audio_cubit.dart';
import 'package:my_quran_id/presentation/detail/cubit/last_read_cubit.dart';
import 'package:my_quran_id/presentation/widgets/detail_item_surah.dart';
import 'package:my_quran_id/routes.dart';

import 'bloc/quran_detail_bloc.dart';

class QuranDetailPage extends StatefulWidget {
  final int number;
  final String name;
  final bool isFromLastRead;
  const QuranDetailPage({
    super.key,
    required this.number,
    required this.name,
    required this.isFromLastRead,
  });

  @override
  State<QuranDetailPage> createState() => _QuranDetailPageState();
}

class _QuranDetailPageState extends State<QuranDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {}; // Store keys for each item
  bool _showNextSurahButton = false;

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!_showNextSurahButton && widget.number != 114) {
        setState(() {
          _showNextSurahButton = true;
        });
      }
    } else {
      if (_showNextSurahButton) {
        setState(() {
          _showNextSurahButton = false;
        });
      }
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    Future.delayed(const Duration(milliseconds: 500), _scrollToLastRead);
    super.initState();
  }

  void _scrollToLastRead() async {
    if (widget.isFromLastRead) {
      await context.read<LastReadCubit>().loadLastRead();
      if (!mounted) return;
      final lastReadIndex = context.read<LastReadCubit>().state.lastReadIndex;
      if (_itemKeys.containsKey(lastReadIndex)) {
        final key = _itemKeys[lastReadIndex];
        final contextWidget = key?.currentContext;
        if (contextWidget != null) {
          if (!contextWidget.mounted) return;
          Scrollable.ensureVisible(
            contextWidget,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  QuranDetailBloc(QuranRepository())
                    ..add(LoadQuranDetail(widget.number)),
        ),
        BlocProvider(create: (context) => AudioCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: BlocBuilder<QuranDetailBloc, QuranDetailState>(
          builder: (context, state) {
            if (state is QuranDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuranDetailSuccess) {
              final data = state.quranDetail;
              return _buildContent(
                data: data,
                scrollController: _scrollController,
                itemKeys: _itemKeys,
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

  Widget _buildHeader(QuranDetail data) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 257,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(4, 6),
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
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${data.numberOfVerse} Ayat'.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SvgPicture.asset('assets/svgs/bismillah.svg'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent({
    required QuranDetail data,
    required ScrollController scrollController,
    required Map<int, GlobalKey> itemKeys,
  }) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildHeader(data),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder:
                  (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Divider(color: greyColor, thickness: 1),
                  ),
              itemCount: data.verses.length,
              itemBuilder: (context, index) {
                itemKeys[index] = GlobalKey();
                return DetailItemSurah(
                  itemKey: itemKeys[index]!,
                  data: data.verses[index],
                  surah: data.latinName,
                  number: data.number,
                  index: index,
                );
              },
            ),
            if (_showNextSurahButton)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final nextNumber = widget.number + 1;
                  if (nextNumber <= 114) {
                    final nextSurahName = surahNames[nextNumber - 1];

                    Navigator.pushReplacementNamed(
                      context,
                      RouteName.detail.name,
                      arguments: {'number': nextNumber, 'name': nextSurahName},
                    );
                  }
                },
                label: const Text(
                  'Next Surah',
                  style: TextStyle(fontSize: 16, color: lightColor),
                ),
                icon: const Icon(Icons.skip_next_rounded, color: lightColor),
              ),
          ],
        ),
      ),
    );
  }
}
