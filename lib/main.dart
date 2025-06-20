import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_quran_id/constant.dart';
import 'package:my_quran_id/presentation/detail/cubit/last_read_cubit.dart';
import 'package:my_quran_id/presentation/detail/cubit/scroll_cubit.dart';
import 'package:my_quran_id/routes.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
List<String?> surahNames = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  final config = ClarityConfig(
    projectId: dotenv.env['CLARITY_ID'] ?? '',
    logLevel: kDebugMode ? LogLevel.Debug : LogLevel.None,
  );
  final lastReadCubit = LastReadCubit();
  await lastReadCubit.loadLastRead();
  initializeDateFormatting('id', null).then((_) {
    runApp(
      ClarityWidget(
        clarityConfig: config,
        app: BlocProvider(
          create: (context) => ScrollCubit(),
          child: MyApp(lastReadCubit: lastReadCubit),
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  final LastReadCubit lastReadCubit;
  const MyApp({super.key, required this.lastReadCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lastReadCubit,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        theme: themeData,
        initialRoute: RouteName.bottomNav.name,
        routes: routes,
      ),
    );
  }
}
