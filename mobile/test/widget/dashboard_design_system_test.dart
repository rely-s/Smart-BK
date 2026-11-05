import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bk_care/core/constants/enums.dart';
import 'package:smart_bk_care/core/di/injection.dart';
import 'package:smart_bk_care/core/theme/app_theme.dart';
import 'package:smart_bk_care/features/auth/domain/entities/user_entity.dart';
import 'package:smart_bk_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:smart_bk_care/features/screening/presentation/bloc/screening_bloc.dart';
import 'package:smart_bk_care/features/report_case/presentation/bloc/report_bloc.dart';
import 'package:smart_bk_care/features/tele_counseling/presentation/bloc/counseling_bloc.dart';
import 'package:smart_bk_care/features/dashboard/presentation/screens/main_shell_screen.dart';

void main() {
  setUp(() async {
    await initDependencies();
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('Dashboard UI Design System Conformance (DESIGN.md & Stitch)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;

    final authBloc = sl<AuthBloc>();
    final screeningBloc = sl<ScreeningBloc>();
    final reportBloc = sl<ReportBloc>();
    final counselingBloc = sl<CounselingBloc>();

    authBloc.emit(Authenticated(const UserEntity(
      id: 'e28bbd91-382a-4389-a541-11910cf90011',
      identityNumber: '0071234567',
      fullName: 'Fajri Pratama',
      email: 'fajri.pratama@siswa.sumbar.belajar.id',
      phoneNumber: '081267890123',
      role: UserRole.student,
      schoolId: 'a11bbd91-382a-4389-a541-11910cf90001',
      schoolName: 'SMAN 1 Padang',
      isActive: true,
      gradeClass: 'XI-F2',
      major: 'Fase F (Kurikulum Merdeka)',
      gender: 'Laki-laki',
    )));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<ScreeningBloc>.value(value: screeningBloc),
          BlocProvider<ReportBloc>.value(value: reportBloc),
          BlocProvider<CounselingBloc>.value(value: counselingBloc),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MainShellScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Header elements
    expect(find.text('Halo, Fajri! 👋'), findsOneWidget);
    expect(find.text('SMAN 1 Padang • XI-F2'), findsOneWidget);
    expect(find.text('Siswa'), findsOneWidget);

    // 2. Search bar per DESIGN.md
    expect(find.text('Cari topik konseling, artikel, atau panduan...'), findsOneWidget);

    // 3. Category Chips
    expect(find.text('Semua Layanan'), findsOneWidget);
    expect(find.text('Curhat & Chat'), findsOneWidget);

    // 4. Hero Sanctuary Card
    expect(find.text('Aman & Rahasia'), findsOneWidget);
    expect(find.text('Ruang Bimbingan & Konseling Digital'), findsOneWidget);
    expect(find.text('100% Bebas Stigma'), findsOneWidget);
    expect(find.text('3 Guru BK Online'), findsOneWidget);

    // 5. 2-Column Feature Service Grid (6 Services per DESIGN.md domain tokens)
    expect(find.text('Curhat & Konsultasi'), findsOneWidget);
    expect(find.text('Chat, voice, atau video bersama Guru BK'), findsOneWidget);

    expect(find.text('Skrining Mandiri'), findsOneWidget);
    expect(find.text('Deteksi kecemasan & stres non-klinis (GAD-7)'), findsOneWidget);

    expect(find.text('Laporkan Kasus'), findsOneWidget);
    expect(find.text('Aduan aman, 100% anonim & anti-perundungan'), findsOneWidget);

    expect(find.text('Literasi Jiwa'), findsOneWidget);
    expect(find.text('Artikel, podcast & nilai Adat Basandi Syarak'), findsOneWidget);

    expect(find.text('Jadwal Konseling'), findsOneWidget);
    expect(find.text('Booking sesi temu & pengingat konseling'), findsOneWidget);

    expect(find.text('Komunitas Sebaya'), findsOneWidget);
    expect(find.text('Forum diskusi & saling dukung sesama siswa'), findsOneWidget);

    // 6. Crisis / Alert Button per DESIGN.md Section 1
    expect(find.text('Pusat Perlindungan Darurat & Anti-Bullying'), findsOneWidget);
    expect(find.text('Lapor Perundungan / Krisis Sekarang'), findsOneWidget);

    // 7. Bottom Navigation Bar (5 slots per DESIGN.md Section 7)
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Konseling'), findsOneWidget);
    expect(find.text('Edukasi'), findsOneWidget);
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
