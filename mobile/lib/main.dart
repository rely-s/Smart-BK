import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/screening/presentation/bloc/screening_bloc.dart';
import 'features/report_case/presentation/bloc/report_bloc.dart';
import 'features/tele_counseling/presentation/bloc/counseling_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Service Locator & Dependensi
  await initDependencies();

  runApp(const SmartBkCareApp());
}

class SmartBkCareApp extends StatefulWidget {
  const SmartBkCareApp({super.key});

  @override
  State<SmartBkCareApp> createState() => _SmartBkCareAppState();
}

class _SmartBkCareAppState extends State<SmartBkCareApp> {
  late final AuthBloc _authBloc;
  late final ScreeningBloc _screeningBloc;
  late final ReportBloc _reportBloc;
  late final CounselingBloc _counselingBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(CheckAuthStatusEvent());
    _screeningBloc = sl<ScreeningBloc>();
    _reportBloc = sl<ReportBloc>();
    _counselingBloc = sl<CounselingBloc>();
    _router = AppRouter.createRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _screeningBloc.close();
    _reportBloc.close();
    _counselingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<ScreeningBloc>.value(value: _screeningBloc),
        BlocProvider<ReportBloc>.value(value: _reportBloc),
        BlocProvider<CounselingBloc>.value(value: _counselingBloc),
      ],
      child: MaterialApp.router(
        title: 'Smart BK Care',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
