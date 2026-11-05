import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../tele_counseling/presentation/screens/counseling_hub_screen.dart';
import '../../../education/presentation/screens/education_screen.dart';
import '../../../notification/presentation/screens/notification_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../screening/presentation/screens/screening_hub_screen.dart';
import '../../../report_case/presentation/screens/report_screen.dart';
import 'dashboard_screen.dart';

/// MainShellScreen dengan 5 Slot Navigasi Bawah Sesuai Dokumen DESIGN.md
/// Slot: Beranda (Home), Konseling (Counseling), Edukasi (Education), Notifikasi (Alerts), Profil (Profile)
/// Tinggi tepat 64px, latar belakang putih murni #FFFFFF, border-top 1px #F1F5F9,
/// Ikon aktif #0F52BA tebal, inaktif #94A3B8.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;
  bool _isPanicExitActive = false;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
      _isPanicExitActive = false;
    });
  }

  void _triggerPanicExit() {
    setState(() {
      _currentIndex = 2; // Beralih langsung ke tab Edukasi (index 2)
      _isPanicExitActive = true;
    });
  }

  void _openScreening() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScreeningHubScreen(
          onNavigateToCounseling: () {
            Navigator.of(context).pop();
            _onTabSelected(1);
          },
        ),
      ),
    );
  }

  void _openReport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ReportScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        onNavigateToCounseling: () => _onTabSelected(1),
        onNavigateToEducation: () => _onTabSelected(2),
        onNavigateToScreening: _openScreening,
        onNavigateToReport: _openReport,
      ),
      CounselingHubScreen(
        onPanicExitToEducation: _triggerPanicExit,
      ),
      EducationScreen(
        isPanicExitLanding: _isPanicExitActive,
      ),
      const NotificationScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFF1F5F9), width: 1.0),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelected,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent, // Menghilangkan bubble M3 sesuai DESIGN.md
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.forum_outlined),
              selectedIcon: Icon(Icons.forum_rounded, color: AppColors.primary),
              label: 'Konseling',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              selectedIcon: Icon(Icons.auto_stories_rounded, color: AppColors.primary),
              label: 'Edukasi',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications_rounded, color: AppColors.primary),
              label: 'Notifikasi',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
