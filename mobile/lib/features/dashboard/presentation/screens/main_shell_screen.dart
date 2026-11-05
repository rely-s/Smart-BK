import 'package:flutter/material.dart';
import '../../../tele_counseling/presentation/screens/counseling_hub_screen.dart';
import '../../../education/presentation/screens/education_screen.dart';
import '../../../notification/presentation/screens/notification_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../screening/presentation/screens/screening_hub_screen.dart';
import '../../../report_case/presentation/screens/report_screen.dart';
import 'dashboard_screen.dart';

/// MainShellScreen dengan 5 Slot Navigasi Bawah
/// Mengimplementasikan 100% spesifikasi antarmuka visual https://smart-bk-care-sumatera-barat.ai.studio:
/// - 5 Tab Navigasi: Beranda, Konseling, Edukasi, Notifikasi, Profil.
/// - Highlight kapsul aktif soft blue (Color(0xFFEFF6FF)) dengan ikon & teks Color(0xFF003C90).
/// - Indikator badge titik merah untuk notifikasi baru.
/// - Border-top Color(0xFFE2E8F0) dengan latar belakang putih murni.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;
  bool _isPanicExitActive = false;
  int _unreadNotifications = 2;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
      _isPanicExitActive = false;
      if (index == 3) {
        _unreadNotifications = 0;
      }
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
        onNavigateToNotification: () => _onTabSelected(3),
        onNavigateToProfile: () => _onTabSelected(4),
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
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0F003C90),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  label: 'Beranda',
                  icon: Icons.home_rounded,
                  unselectedIcon: Icons.home_outlined,
                ),
                _buildNavItem(
                  index: 1,
                  label: 'Konseling',
                  icon: Icons.chat_bubble_rounded,
                  unselectedIcon: Icons.chat_bubble_outline_rounded,
                ),
                _buildNavItem(
                  index: 2,
                  label: 'Edukasi',
                  icon: Icons.menu_book_rounded,
                  unselectedIcon: Icons.menu_book_outlined,
                ),
                _buildNavItem(
                  index: 3,
                  label: 'Notifikasi',
                  icon: Icons.notifications_rounded,
                  unselectedIcon: Icons.notifications_outlined,
                  badgeCount: _unreadNotifications,
                ),
                _buildNavItem(
                  index: 4,
                  label: 'Profil',
                  icon: Icons.person_rounded,
                  unselectedIcon: Icons.person_outline_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData unselectedIcon,
    int? badgeCount,
  }) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelected(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    isSelected ? icon : unselectedIcon,
                    size: 20,
                    color: isSelected ? const Color(0xFF003C90) : const Color(0xFF94A3B8),
                  ),
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: -1,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF003C90) : const Color(0xFF94A3B8),
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
