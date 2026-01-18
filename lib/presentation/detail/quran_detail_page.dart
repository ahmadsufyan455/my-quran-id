import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_quran_id/constant.dart';
import 'package:my_quran_id/data/model/quran_detail_model.dart';
import 'package:my_quran_id/domain/quran_repository.dart';
import 'package:my_quran_id/main.dart';
import 'package:my_quran_id/presentation/detail/cubit/audio_cubit.dart';
import 'package:my_quran_id/presentation/detail/cubit/last_read_cubit.dart';
import 'package:my_quran_id/presentation/detail/cubit/scroll_cubit.dart';
import 'package:my_quran_id/presentation/widgets/detail_item_surah.dart';
import 'package:my_quran_id/routes.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  // Controllers for ScrollablePositionedList
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int? _currentSurahNumber; // Track current surah

  void _onScrollPositionChanged() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final cubit = context.read<ScrollCubit>();

    // Check if we're near the end (last few items are visible)
    final maxIndex = positions
        .map((p) => p.index)
        .reduce((a, b) => a > b ? a : b);
    final isNearEnd = positions.any(
      (p) => p.index == maxIndex && p.itemTrailingEdge <= 1.1,
    );

    if (isNearEnd && widget.number < 114) {
      cubit.showButton();
    } else {
      cubit.hideButton();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSurahNumber = widget.number;
    _itemPositionsListener.itemPositions.addListener(_onScrollPositionChanged);
  }

  void _scrollToLastRead(int totalItems) async {
    if (widget.isFromLastRead) {
      await context.read<LastReadCubit>().loadLastRead();
      if (!mounted) return;
      final lastReadIndex = context.read<LastReadCubit>().state.lastReadIndex;
      if (lastReadIndex != null && lastReadIndex >= 0) {
        // +1 because index 0 is the header
        final targetIndex = lastReadIndex + 1;
        if (targetIndex < totalItems) {
          // Wait a bit for the list to be ready
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) return;
          _itemScrollController.scrollTo(
            index: targetIndex,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(
      _onScrollPositionChanged,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              QuranDetailBloc(QuranRepository())
                ..add(LoadQuranDetail(widget.number)),
        ),
        BlocProvider(create: (context) => AudioCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.number}. ${widget.name}')),
        body: BlocBuilder<QuranDetailBloc, QuranDetailState>(
          builder: (context, state) {
            if (state is QuranDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuranDetailSuccess) {
              final data = state.quranDetail;
              return _buildContent(data: data);
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

  Widget _buildContent({required QuranDetail data}) {
    // Clear state if viewing a different surah
    if (_currentSurahNumber != data.number) {
      _currentSurahNumber = data.number;
    }

    // Total items: 1 header + verses + 1 next button
    final totalItems = 1 + data.verses.length + 1;

    // Trigger scroll to last read after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLastRead(totalItems);
    });

    return ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      itemCount: totalItems,
      itemBuilder: (context, index) {
        // Index 0: Header
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: _buildHeader(data),
          );
        }

        // Last index: Next surah button
        if (index == totalItems - 1) {
          return BlocBuilder<ScrollCubit, bool>(
            builder: (context, showButton) {
              if (!showButton || widget.number >= 114) {
                return const SizedBox.shrink();
              }

              return ElevatedButton.icon(
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
                label: Text(
                  '${surahNames[widget.number + 1 - 1]}',
                  style: const TextStyle(fontSize: 16, color: lightColor),
                ),
                icon: const Icon(Icons.skip_next_rounded, color: lightColor),
              );
            },
          );
        }

        // Verse items (index 1 to totalItems - 2)
        final verseIndex = index - 1; // Adjust for header offset
        return Column(
          children: [
            if (verseIndex > 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Divider(color: greyColor, thickness: 1),
              ),
            DetailItemSurah(
              data: data.verses[verseIndex],
              surah: data.latinName,
              number: data.number,
              index: verseIndex,
            ),
          ],
        );
      },
    );
  }
}
