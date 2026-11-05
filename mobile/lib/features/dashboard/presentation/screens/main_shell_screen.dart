import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../tele_counseling/presentation/screens/counseling_hub_screen.dart';
import '../../../education/presentation/screens/education_screen.dart';
import '../../../notification/presentation/screens/notification_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../screening/presentation/screens/screening_hub_screen.dart';
import '../../../report_case/presentation/screens/report_screen.dart';
import 'dashboard_screen.dart';

/// MainShellScreen dengan iOS Human Interface Guidelines (HIG) Tab Bar
/// - Cupertino translucent frosted glass bar (BackdropFilter blur 20px).
/// - Apple hairline top border (0.33pt).
/// - 5 Tab Bar iOS: Beranda, Konseling, Edukasi, Notifikasi, Profil.
/// - Apple SF Symbols (CupertinoIcons) fill saat aktif, outline saat inaktif.
/// - Warna aktif iOS System Blue (#007AFF) & inaktif iOS System Gray (#8E8E93).
/// - Badge notifikasi merah khas Apple (#FF3B30).
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
      _currentIndex = 2; // Beralih langsung ke tab Edukasi
      _isPanicExitActive = true;
    });
  }

  void _openScreening() {
    Navigator.of(context).push(
      CupertinoPageRoute(
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
      CupertinoPageRoute(
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
      backgroundColor: const Color(0xFFF2F2F7), // iOS System Grouped Background
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xE6FFFFFF), // Frosted glass translucent
              border: Border(
                top: BorderSide(
                  color: Color(0x4D3C3C43), // iOS hairline separator (0.33pt)
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 56, // iOS Tab Bar height
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIosTabItem(
                      index: 0,
                      label: 'Beranda',
                      activeIcon: CupertinoIcons.house_fill,
                      inactiveIcon: CupertinoIcons.house,
                    ),
                    _buildIosTabItem(
                      index: 1,
                      label: 'Konseling',
                      activeIcon: CupertinoIcons.chat_bubble_2_fill,
                      inactiveIcon: CupertinoIcons.chat_bubble_2,
                    ),
                    _buildIosTabItem(
                      index: 2,
                      label: 'Edukasi',
                      activeIcon: CupertinoIcons.book_fill,
                      inactiveIcon: CupertinoIcons.book,
                    ),
                    _buildIosTabItem(
                      index: 3,
                      label: 'Notifikasi',
                      activeIcon: CupertinoIcons.bell_fill,
                      inactiveIcon: CupertinoIcons.bell,
                      badgeCount: _unreadNotifications,
                    ),
                    _buildIosTabItem(
                      index: 4,
                      label: 'Profil',
                      activeIcon: CupertinoIcons.person_crop_circle_fill,
                      inactiveIcon: CupertinoIcons.person_crop_circle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIosTabItem({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
    int? badgeCount,
  }) {
    final isSelected = _currentIndex == index;
    const activeColor = Color(0xFF007AFF); // Apple iOS System Blue
    const inactiveColor = Color(0xFF8E8E93); // Apple iOS System Gray

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  size: 22,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: -2,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30), // Apple System Red
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
