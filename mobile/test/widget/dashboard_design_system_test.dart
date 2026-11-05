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

  testWidgets('Dashboard UI matches https://smart-bk-care-sumatera-barat.ai.studio', (WidgetTester tester) async {
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
      schoolName: 'SMA Negeri 1 Padang',
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
    expect(find.text('Smart BK Care'), findsOneWidget);
    expect(find.text('SUMATERA BARAT'), findsOneWidget);

    // 2. Student Sanctuary Hero Card
    expect(find.text('Ruang Aman Siswa SMA Negeri 1 Padang'), findsOneWidget);
    expect(find.text('Halo, Fajri! 👋'), findsOneWidget);
    expect(
      find.text('Ada hal yang mengganjal atau ingin kamu ceritakan hari ini? Guru BK siap mendengarkan tanpa menghakimi.'),
      findsOneWidget,
    );
    expect(
      find.text('Kerahasiaan data dijamin & terlindungi kode etik konseling'),
      findsOneWidget,
    );

    // 3. Search bar per AI Studio
    expect(find.text('Cari info materi, curhat, atau jadwal konseling...'), findsOneWidget);

    // 4. Section Layanan Bimbingan Konseling & Badge
    expect(find.text('Layanan Bimbingan Konseling'), findsOneWidget);
    expect(find.text('Terlindungi & Rahasia'), findsOneWidget);

    // 5. 2-Column Feature Service Grid (6 Services per AI Studio)
    expect(find.text('Curhat & Konseling'), findsOneWidget);
    expect(find.text('Chat, voice, video'), findsOneWidget);
    expect(find.text('Mulai sesi'), findsOneWidget);

    expect(find.text('Tes Kesehatan Mental'), findsOneWidget);
    expect(find.text('Refleksi mandiri'), findsOneWidget);
    expect(find.text('Cek kondisi'), findsOneWidget);

    expect(find.text('Lapor Kasus'), findsOneWidget);
    expect(find.text('Aman & anonim'), findsOneWidget);
    expect(find.text('Laporkan'), findsOneWidget);

    expect(find.text('Materi Edukasi'), findsOneWidget);
    expect(find.text('Artikel & tips remaja'), findsOneWidget);
    expect(find.text('Buka modul'), findsOneWidget);

    expect(find.text('Jadwal Konseling'), findsOneWidget);
    expect(find.text('Reservasi sesi'), findsOneWidget);
    expect(find.text('Pilih waktu'), findsOneWidget);

    expect(find.text('Komunitas Siswa'), findsOneWidget);
    expect(find.text('Ruang berbagi sebaya'), findsOneWidget);
    expect(find.text('Gabung circle'), findsOneWidget);

    // 6. Banner Inspirasi Pelajar Minang
    expect(find.text('INSPIRASI PELAJAR MINANG'), findsOneWidget);
    expect(find.text('“Cerita Itu Kekuatan, Bukan Kelemahan”'), findsOneWidget);
    expect(find.text('Baca Kisah Fajar'), findsOneWidget);
    expect(find.text('Konselor Berlisensi'), findsOneWidget);

    // 7. Bottom Navigation Bar (5 slots per AI Studio)
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Konseling'), findsOneWidget);
    expect(find.text('Edukasi'), findsOneWidget);
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
