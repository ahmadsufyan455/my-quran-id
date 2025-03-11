import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_quran_id/presentation/detail/cubit/last_read_cubit.dart';
import 'package:my_quran_id/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final lastReadCubit = LastReadCubit();
  await lastReadCubit.loadLastRead();
  initializeDateFormatting('id', null).then((_) {
    runApp(MyApp(lastReadCubit: lastReadCubit));
  });
}

class MyApp extends StatelessWidget {
  final LastReadCubit lastReadCubit;
  const MyApp({super.key, required this.lastReadCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: lastReadCubit)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Nunito',
        ),
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
