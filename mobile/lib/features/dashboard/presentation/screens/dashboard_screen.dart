import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Dashboard Screen Smart BK Care (Beranda)
/// Mengimplementasikan Apple iOS Human Interface Guidelines (HIG) secara komprehensif:
/// - iOS System Grouped Background (#F2F2F7) dan Inset Grouped Card (#FFFFFF).
/// - iOS Cupertino Icons (SF Symbols style).
/// - iOS Large Title Navigation Bar dengan hairline divider.
/// - iOS Cupertino Search Bar dengan rounded corners.
/// - Interactive Daily Mood Pulse berbasis iOS segmented controls.
/// - Apple App Store "Today" style featured story banner.
/// - iOS ActionSheet / Modal Sheet dialogs.
class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToCounseling;
  final VoidCallback onNavigateToEducation;
  final VoidCallback onNavigateToScreening;
  final VoidCallback onNavigateToReport;
  final VoidCallback onNavigateToNotification;
  final VoidCallback onNavigateToProfile;

  const DashboardScreen({
    super.key,
    required this.onNavigateToCounseling,
    required this.onNavigateToEducation,
    required this.onNavigateToScreening,
    required this.onNavigateToReport,
    required this.onNavigateToNotification,
    required this.onNavigateToProfile,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchActive = false;
  String _searchQuery = '';

  int? _selectedMoodIndex;

  final List<_MoodItem> _moods = const [
    _MoodItem(
      icon: CupertinoIcons.sun_max_fill,
      tint: Color(0xFFFF9500),
      label: 'Senang',
      feedback: 'Energi positifmu berharga! Rawat terus suasana hatimu hari ini.',
    ),
    _MoodItem(
      icon: CupertinoIcons.sparkles,
      tint: Color(0xFF34C759),
      label: 'Tenang',
      feedback: 'Kondisi emosi yang stabil adalah fondasi terbaik untuk fokus dan berkarya.',
    ),
    _MoodItem(
      icon: CupertinoIcons.equal_circle_fill,
      tint: Color(0xFF007AFF),
      label: 'Biasa',
      feedback: 'Hari yang santai juga baik. Luangkan jeda sejenak untuk hal yang kamu sukai.',
    ),
    _MoodItem(
      icon: CupertinoIcons.cloud_bolt_fill,
      tint: Color(0xFF5856D6),
      label: 'Cemas',
      feedback: 'Wajar merasa cemas. Tarik napas perlahan, Guru BK siap mendengarkan tanpa menghakimi.',
    ),
    _MoodItem(
      icon: CupertinoIcons.moon_fill,
      tint: Color(0xFF8E8E93),
      label: 'Lelah',
      feedback: 'Tubuh dan pikiranmu butuh jeda. Jangan ragu beristirahat atau bercerita ke Guru BK.',
    ),
  ];

  final List<_SearchSuggestion> _allSuggestions = const [
    _SearchSuggestion(
      label: 'Curhat dengan Guru BK',
      icon: CupertinoIcons.chat_bubble_2_fill,
      target: _SearchTarget.counseling,
    ),
    _SearchSuggestion(
      label: 'Cek Kecemasan Ujian',
      icon: CupertinoIcons.waveform_path_ecg,
      target: _SearchTarget.screening,
    ),
    _SearchSuggestion(
      label: 'Reservasi Konseling Tatap Muka',
      icon: CupertinoIcons.calendar,
      target: _SearchTarget.counseling,
    ),
    _SearchSuggestion(
      label: 'Lapor Perundungan Anonim',
      icon: CupertinoIcons.shield_fill,
      target: _SearchTarget.report,
    ),
    _SearchSuggestion(
      label: 'Modul Mengatasi Stres',
      icon: CupertinoIcons.book_fill,
      target: _SearchTarget.education,
    ),
  ];

  final Set<String> _joinedCircles = {'circle-1'};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
        _isSearchActive = _searchQuery.isNotEmpty || _searchFocusNode.hasFocus;
      });
    });
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchActive = _searchQuery.isNotEmpty || _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSuggestionTap(_SearchTarget target) {
    _searchFocusNode.unfocus();
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
    });

    switch (target) {
      case _SearchTarget.counseling:
        widget.onNavigateToCounseling();
        break;
      case _SearchTarget.screening:
        widget.onNavigateToScreening();
        break;
      case _SearchTarget.report:
        widget.onNavigateToReport();
        break;
      case _SearchTarget.education:
        widget.onNavigateToEducation();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            backgroundColor: const Color(0xFFF2F2F7), // Apple iOS System Grouped Background
            appBar: _buildIosHeader(context),
            drawer: _buildIosDrawer(context, user),
            body: GestureDetector(
              onTap: () {
                if (_searchFocusNode.hasFocus) {
                  _searchFocusNode.unfocus();
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(), // iOS signature bouncing scroll
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.isStudent) ...[
                      // 1. Student Sanctuary Card (iOS Inset Grouped)
                      _buildIosStudentSanctuaryCard(user),
                      const SizedBox(height: 16),

                      // 2. Interactive Daily Mood Check-In (iOS Style)
                      _buildIosMoodCheckIn(),
                      const SizedBox(height: 16),

                      // 3. iOS Search Bar
                      _buildIosSearchBar(),
                      const SizedBox(height: 20),

                      // 4. Layanan Bimbingan Konseling Grid (iOS App Store Grid)
                      _buildIosServicesSection(),
                      const SizedBox(height: 20),

                      // 5. Inspirasi Pelajar Minang (Apple "Today" Card)
                      _buildIosInspirasiMinangBanner(),
                    ] else ...[
                      // Counselor Portal View
                      _buildIosCounselorCard(user),
                      const SizedBox(height: 16),
                      _buildIosCounselorOverview(),
                    ],
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Color(0xFFF2F2F7),
          body: Center(
            child: CupertinoActivityIndicator(radius: 14),
          ),
        );
      },
    );
  }

  // ==========================================
  // 1. iOS APP BAR & NAVIGATION HEADER
  // ==========================================
  PreferredSizeWidget _buildIosHeader(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF2F2F7).withValues(alpha: 0.94),
      elevation: 0,
      scrolledUnderElevation: 0.5,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          color: const Color(0x263C3C43), // iOS hairline separator (0.33pt)
          height: 0.5,
        ),
      ),
      title: Row(
        children: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
                ),
                child: const Icon(
                  CupertinoIcons.line_horizontal_3,
                  size: 18,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Smart BK Care',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                    letterSpacing: -0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'SUMATERA BARAT',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8E8E93),
                    letterSpacing: 0.8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: widget.onNavigateToNotification,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.bell_fill,
                    size: 18,
                    color: Color(0xFF1C1C1E),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. iOS INSET GROUPED CARD: STUDENT SANCTUARY
  // ==========================================
  Widget _buildIosStudentSanctuaryCard(UserEntity user) {
    final firstName = user.fullName.split(' ').first;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18), // iOS continuous squircle
        border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000), // iOS ultra subtle elevation
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Siluet Watermark Minang
          Positioned(
            right: -8,
            bottom: -8,
            child: Opacity(
              opacity: 0.035,
              child: CustomPaint(
                size: const Size(120, 95),
                painter: _MinangGonjongSilhouettePainter(color: const Color(0xFF007AFF)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // iOS Green Status Badge Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EE),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF34C759), // iOS System Green
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Ruang Aman Siswa ${user.schoolName ?? "SMA Negeri 1 Padang"}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF248A3D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Greeting Headline
                Text(
                  'Halo, $firstName! 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF000000),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                const Text(
                  'Ada hal yang mengganjal atau ingin kamu ceritakan hari ini? Guru BK siap mendengarkan tanpa menghakimi.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3C3C43), // iOS Secondary Label
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),

                // Jaminan Privasi iOS
                const Row(
                  children: [
                    Icon(
                      CupertinoIcons.lock_shield_fill,
                      size: 14,
                      color: Color(0xFF007AFF),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Kerahasiaan data dijamin & terlindungi kode etik konseling',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8E8E93),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. iOS DAILY MOOD CHECK-IN
  // ==========================================
  Widget _buildIosMoodCheckIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'BAGAIMANA SUASANA HATIMU?',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8E8E93), // iOS Grouped Header
                    letterSpacing: 0.6,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Refleksi Hari Ini',
                style: TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 8,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: List.generate(_moods.length, (index) {
                  final mood = _moods[index];
                  final isSelected = _selectedMoodIndex == index;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMoodIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFEBF5FF) : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFE5E5EA),
                              width: isSelected ? 1.5 : 0.5,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF007AFF)
                                      : mood.tint.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  mood.icon,
                                  size: 15,
                                  color: isSelected ? Colors.white : mood.tint,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                mood.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF48484A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              if (_selectedMoodIndex != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _moods[_selectedMoodIndex!].icon,
                        size: 18,
                        color: _moods[_selectedMoodIndex!].tint,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _moods[_selectedMoodIndex!].feedback,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1C1C1E),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. iOS CUPERTINO SEARCH BAR
  // ==========================================
  Widget _buildIosSearchBar() {
    final filtered = _allSuggestions.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE3E3E8), // Apple System Gray 5
            borderRadius: BorderRadius.circular(10), // iOS Search Field Radius
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.search,
                color: Color(0xFF8E8E93),
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF000000),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Cari info materi, curhat, atau jadwal konseling...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8E8E93),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () => _searchController.clear(),
                  child: const Icon(CupertinoIcons.clear_circled_solid, size: 16, color: Color(0xFF8E8E93)),
                ),
            ],
          ),
        ),

        // iOS Dropdown List
        if (_isSearchActive && _searchQuery.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Text(
                    'HASIL PENCARIAN CEPAT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8E8E93),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                if (filtered.isNotEmpty)
                  ...filtered.map(
                    (s) => GestureDetector(
                      onTap: () => _handleSuggestionTap(s.target),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(s.icon, size: 18, color: const Color(0xFF007AFF)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                s.label,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1C1C1E),
                                ),
                              ),
                            ),
                            const Icon(CupertinoIcons.chevron_right, size: 14, color: Color(0xFFC7C7CC)),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        'Tidak ada menu terkait. Ketuk tombol konseling untuk bertanya langsung.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ==========================================
  // 5. iOS GRID LAYANAN BIMBINGAN KONSELING
  // ==========================================
  Widget _buildIosServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // iOS Grouped Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Layanan Bimbingan Konseling',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF5FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.lock_shield_fill,
                    size: 12,
                    color: Color(0xFF007AFF),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Terlindungi & Rahasia',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Grid 6 Kartu (2 Kolom)
        Row(
          children: [
            Expanded(
              child: _buildIosServiceCard(
                title: 'Curhat & Konseling',
                subtitle: 'Chat, voice, video',
                cta: 'Mulai sesi',
                icon: CupertinoIcons.chat_bubble_2_fill,
                iconColor: const Color(0xFF007AFF), // iOS Blue
                bgColor: const Color(0xFFEBF5FF),
                onTap: widget.onNavigateToCounseling,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIosServiceCard(
                title: 'Tes Kesehatan Mental',
                subtitle: 'Refleksi mandiri',
                cta: 'Cek kondisi',
                icon: CupertinoIcons.waveform_path_ecg,
                iconColor: const Color(0xFF5856D6), // iOS Indigo
                bgColor: const Color(0xFFEFEFFD),
                onTap: widget.onNavigateToScreening,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildIosServiceCard(
                title: 'Lapor Kasus',
                subtitle: 'Aman & anonim',
                cta: 'Laporkan',
                icon: CupertinoIcons.shield_fill,
                iconColor: const Color(0xFFFF3B30), // iOS Red
                bgColor: const Color(0xFFFFEBEA),
                onTap: widget.onNavigateToReport,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIosServiceCard(
                title: 'Materi Edukasi',
                subtitle: 'Artikel & tips remaja',
                cta: 'Buka modul',
                icon: CupertinoIcons.book_fill,
                iconColor: const Color(0xFFFF9500), // iOS Orange
                bgColor: const Color(0xFFFFF4E5),
                onTap: widget.onNavigateToEducation,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildIosServiceCard(
                title: 'Jadwal Konseling',
                subtitle: 'Reservasi sesi',
                cta: 'Pilih waktu',
                icon: CupertinoIcons.calendar,
                iconColor: const Color(0xFF34C759), // iOS Green
                bgColor: const Color(0xFFEBF9EE),
                onTap: widget.onNavigateToCounseling,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIosServiceCard(
                title: 'Komunitas Siswa',
                subtitle: 'Ruang berbagi sebaya',
                cta: 'Gabung circle',
                icon: CupertinoIcons.person_3_fill,
                iconColor: const Color(0xFF30B0C7), // iOS Teal
                bgColor: const Color(0xFFEAF8FB),
                onTap: _showIosCommunityDialog,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIosServiceCard({
    required String title,
    required String subtitle,
    required String cta,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 8,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // iOS Squircle App-Icon Badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 19),
                ),
                const Icon(
                  CupertinoIcons.chevron_forward,
                  size: 13,
                  color: Color(0xFFC7C7CC),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1E),
                height: 1.2,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8E8E93),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    cta,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 12,
                  color: iconColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 6. APPLE "TODAY" STYLE FEATURED CARD
  // ==========================================
  Widget _buildIosInspirasiMinangBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Apple Midnight Slate
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            bottom: -6,
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(
                size: const Size(100, 120),
                painter: _JamGadangSilhouettePainter(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'INSPIRASI PELAJAR MINANG',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF93C5FD),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                const SizedBox(
                  width: 240,
                  child: Text(
                    '“Cerita Itu Kekuatan, Bukan Kelemahan”',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                const SizedBox(
                  width: 240,
                  child: Text(
                    'Konseling membantu kamu menata pikiran dan melangkah pasti menuju masa depan gemilang.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    GestureDetector(
                      onTap: _showIosStoryDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Baca Kisah Fajar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(CupertinoIcons.arrow_right, size: 13, color: Color(0xFF0F172A)),
                          ],
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          size: 15,
                          color: Color(0xFF34C759), // iOS Green
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Konselor Berlisensi',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. iOS ACTION SHEET / MODAL STORY DIALOG
  // ==========================================
  void _showIosStoryDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // iOS Drag Grabber
              Center(
                child: Container(
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D1D6),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF5FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'INSPIRASI PELAJAR MINANG',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF007AFF),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5E5EA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(CupertinoIcons.xmark, size: 14, color: Color(0xFF8E8E93)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Kisah Fajar: “Cerita Itu Kekuatan”',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const Divider(color: Color(0xFFE5E5EA), height: 20),
              const Text(
                '“Dulu, menjelang ujian kenaikan kelas dan pemilihan jurusan kuliah, saya sering begadang semalaman karena takut gagal. Pikiran saya penuh dengan ekspektasi orang tua dan rasa takut tertinggal oleh teman-teman.”',
                style: TextStyle(fontSize: 13, color: Color(0xFF3C3C43), height: 1.45),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '“Saya kira datang ke Ruang BK itu hanya untuk siswa yang bermasalah. Ternyata anggapan itu salah besar.”',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF007AFF),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '“Bersama Ibu Rahmi Yunita di Ruang BK SMAN 1 Padang, saya belajar mengurai kecemasan saya satu per satu. Beliau tidak pernah menghakimi, melainkan membimbing saya menemukan gaya belajar yang tepat dan memetakan minat karir saya secara realistis.”',
                style: TextStyle(fontSize: 13, color: Color(0xFF3C3C43), height: 1.45),
              ),
              const SizedBox(height: 10),
              const Text(
                '“Kini saya merasa jauh lebih percaya diri menghadapi ujian. Jangan ragu bercerita, karena membuka perasaan bukanlah tanda kelemahan, melainkan awal dari kekuatanmu.”',
                style: TextStyle(fontSize: 13, color: Color(0xFF3C3C43), height: 1.45),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  borderRadius: BorderRadius.circular(14),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    widget.onNavigateToCounseling();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.chat_bubble_2_fill, size: 16),
                      SizedBox(width: 8),
                      Text('Mulai Cerita dengan Guru BK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 8. iOS MODAL DIALOG: KOMUNITAS SISWA
  // ==========================================
  void _showIosCommunityDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final circles = [
            _CommunityCircle(
              id: 'circle-1',
              name: 'Pejuang SNBP & Kampus Impian',
              members: '1.420 Siswa',
              desc: 'Ruang sharing tips lolos perguruan tinggi negeri, analisis nilai rapor, dan manajemen ambisi sehat.',
              badge: 'Akademik',
              badgeBg: const Color(0xFFEBF5FF),
              badgeColor: const Color(0xFF007AFF),
            ),
            _CommunityCircle(
              id: 'circle-2',
              name: 'Sahabat Upstander Anti-Bullying',
              members: '890 Siswa',
              desc: 'Komunitas pelajar SMA/SMK se-Sumbar yang berkomitmen menciptakan iklim sekolah aman, inklusif, dan bebas perundungan.',
              badge: 'Sosial & Perlindungan',
              badgeBg: const Color(0xFFE8F8EE),
              badgeColor: const Color(0xFF248A3D),
            ),
            _CommunityCircle(
              id: 'circle-3',
              name: 'Ruang Bernapas & Manajemen Stres',
              members: '1.150 Siswa',
              desc: 'Saling bertukar cerita ringan, tips istirahat produktif, serta musik dan hobi pereda penat sekolah.',
              badge: 'Kesejahteraan',
              badgeBg: const Color(0xFFFFF4E5),
              badgeColor: const Color(0xFFFF9500),
            ),
          ];

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D1D6),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Komunitas Siswa Minang',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                          Text(
                            'Circle Berbagi Sebaya Terpantau BK',
                            style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5E5EA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.xmark, size: 14, color: Color(0xFF8E8E93)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFE5E5EA), height: 20),
                  ...circles.map((c) {
                    final isJoined = _joinedCircles.contains(c.id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: c.badgeBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  c.badge,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: c.badgeColor,
                                  ),
                                ),
                              ),
                              Text(
                                c.members,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8E8E93),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            c.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.desc,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF636366), height: 1.35),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              color: isJoined ? Colors.white : const Color(0xFF007AFF),
                              borderRadius: BorderRadius.circular(10),
                              onPressed: () {
                                setModalState(() {
                                  if (isJoined) {
                                    _joinedCircles.remove(c.id);
                                  } else {
                                    _joinedCircles.add(c.id);
                                  }
                                });
                                setState(() {});
                              },
                              child: Text(
                                isJoined ? '✓ Tergabung dalam Circle' : '+ Gabung Circle',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isJoined ? const Color(0xFF007AFF) : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // 9. iOS SIDEBAR DRAWER
  // ==========================================
  Widget _buildIosDrawer(BuildContext context, UserEntity user) {
    return Drawer(
      backgroundColor: const Color(0xFFF2F2F7),
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF007AFF), Color(0xFF0040DD)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(CupertinoIcons.heart_fill, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Smart BK Care',
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'SUMATERA BARAT',
                                style: TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 9.5,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5E5EA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.xmark, size: 14, color: Color(0xFF8E8E93)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF007AFF),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            user.fullName.isNotEmpty
                                ? user.fullName.split(' ').map((e) => e[0]).take(2).join()
                                : 'FR',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user.schoolName ?? 'SMA Negeri 1 Padang',
                                style: const TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F8EE),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: const Text(
                            'Aktif',
                            style: TextStyle(
                              color: Color(0xFF248A3D),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0x4D3C3C43), height: 0.5),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Text(
                      'FITUR LAYANAN BK',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _buildIosDrawerTile(
                          icon: CupertinoIcons.waveform_path_ecg,
                          iconColor: const Color(0xFF5856D6),
                          bgColor: const Color(0xFFEFEFFD),
                          title: 'Skrining Perasaan',
                          subtitle: 'Deteksi cemas, stres & suasana hati',
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onNavigateToScreening();
                          },
                        ),
                        const Divider(color: Color(0xFFE5E5EA), height: 0.5, indent: 54),
                        _buildIosDrawerTile(
                          icon: CupertinoIcons.chat_bubble_2_fill,
                          iconColor: const Color(0xFF007AFF),
                          bgColor: const Color(0xFFEBF5FF),
                          title: 'Ruang Sesi Chat',
                          subtitle: 'Konseling privat & terenkripsi BK',
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onNavigateToCounseling();
                          },
                        ),
                        const Divider(color: Color(0xFFE5E5EA), height: 0.5, indent: 54),
                        _buildIosDrawerTile(
                          icon: CupertinoIcons.calendar,
                          iconColor: const Color(0xFF34C759),
                          bgColor: const Color(0xFFEBF9EE),
                          title: 'Reservasi Konseling',
                          subtitle: 'Jadwal tatap muka / daring resmi',
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onNavigateToCounseling();
                          },
                        ),
                        const Divider(color: Color(0xFFE5E5EA), height: 0.5, indent: 54),
                        _buildIosDrawerTile(
                          icon: CupertinoIcons.shield_fill,
                          iconColor: const Color(0xFFFF3B30),
                          bgColor: const Color(0xFFFFEBEA),
                          title: 'Lapor Rahasia',
                          subtitle: 'Pengaduan perundungan 100% aman',
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onNavigateToReport();
                          },
                        ),
                        const Divider(color: Color(0xFFE5E5EA), height: 0.5, indent: 54),
                        _buildIosDrawerTile(
                          icon: CupertinoIcons.book_fill,
                          iconColor: const Color(0xFFFF9500),
                          bgColor: const Color(0xFFFFF4E5),
                          title: 'Edukasi & Literasi',
                          subtitle: 'Video, modul, artikel & podcast',
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onNavigateToEducation();
                          },
                        ),
                        const Divider(color: Color(0xFFE5E5EA), height: 0.5, indent: 54),
                        _buildIosDrawerTile(
                          icon: CupertinoIcons.chart_bar_alt_fill,
                          iconColor: const Color(0xFF30B0C7),
                          bgColor: const Color(0xFFEAF8FB),
                          title: 'Analitik Sumbar',
                          subtitle: 'Data psikososial 19 Kab/Kota',
                          onTap: () {
                            Navigator.of(context).pop();
                            _showIosInfographicsDialog();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Text(
                      'PENGATURAN & AKUN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _buildIosDrawerTile(
                          icon: CupertinoIcons.person_crop_circle_fill,
                          iconColor: const Color(0xFF007AFF),
                          bgColor: const Color(0xFFEBF5FF),
                          title: 'Profil Siswa',
                          subtitle: 'Detail identitas & status psikososial',
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onNavigateToProfile();
                          },
                        ),
                        const Divider(color: Color(0xFFE5E5EA), height: 0.5, indent: 54),
                        _buildIosDrawerTile(
                          icon: CupertinoIcons.arrow_2_squarepath,
                          iconColor: const Color(0xFF5856D6),
                          bgColor: const Color(0xFFEFEFFD),
                          title: 'Simulasi Peran Pengguna',
                          subtitle: 'Beralih ke tampilan Guru BK',
                          onTap: () {
                            Navigator.of(context).pop();
                            _showIosRoleSwitcherDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosDrawerTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 17),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF8E8E93),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right, size: 14, color: Color(0xFFC7C7CC)),
          ],
        ),
      ),
    );
  }

  void _showIosInfographicsDialog() {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Arsitektur Smart BK Care'),
        content: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Ekosistem Bimbingan Konseling Digital Provinsi Sumatera Barat:\n\n'
            '• 19 Cabang Dinas Pendidikan Kab/Kota\n'
            '• Portal Terenkripsi Guru BK & Konselor\n'
            '• Saluran Pengaduan 100% Terlindungi ABKIN\n'
            '• Nilai Filosofis Adat Basandi Syarak',
            textAlign: TextAlign.left,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  void _showIosRoleSwitcherDialog(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Simulasi Peran Pengguna'),
        message: const Text('Pilih peran untuk menguji antarmuka:'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              authBloc.add(const SwitchRoleEvent(UserRole.student));
              Navigator.of(ctx).pop();
            },
            child: const Text('Siswa SMA Negeri 1 Padang'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              authBloc.add(const SwitchRoleEvent(UserRole.bkTeacher));
              Navigator.of(ctx).pop();
            },
            child: const Text('Guru BK / Konselor Sekolah'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  // ==========================================
  // VIEW MODE: GURU BK (iOS Style)
  // ==========================================
  Widget _buildIosCounselorCard(UserEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF5FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PORTAL GURU BK AKTIF',
                  style: TextStyle(color: Color(0xFF007AFF), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                user.schoolName ?? 'SMAN 1 Padang',
                style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Selamat Bertugas, ${user.fullName}!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ruang pantau kesehatan mental siswa & penanganan aduan terenkripsi.',
            style: TextStyle(fontSize: 12, color: Color(0xFF636366)),
          ),
        ],
      ),
    );
  }

  Widget _buildIosCounselorOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'RINGKASAN ANTREAN BK',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF8E8E93)),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildIosCounselorStatTile('3', 'Aduan Masuk', 'Perlu asesmen awal', const Color(0xFFFF3B30)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildIosCounselorStatTile('5', 'Sesi Konseling', 'Hari ini', const Color(0xFF007AFF)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIosCounselorStatTile(String count, String label, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF000000))),
          Text(sub, style: const TextStyle(fontSize: 10.5, color: Color(0xFF8E8E93))),
        ],
      ),
    );
  }
}

enum _SearchTarget {
  counseling,
  screening,
  report,
  education,
}

class _MoodItem {
  final IconData icon;
  final Color tint;
  final String label;
  final String feedback;

  const _MoodItem({
    required this.icon,
    required this.tint,
    required this.label,
    required this.feedback,
  });
}

class _SearchSuggestion {
  final String label;
  final IconData icon;
  final _SearchTarget target;

  const _SearchSuggestion({
    required this.label,
    required this.icon,
    required this.target,
  });
}

class _CommunityCircle {
  final String id;
  final String name;
  final String members;
  final String desc;
  final String badge;
  final Color badgeBg;
  final Color badgeColor;

  const _CommunityCircle({
    required this.id,
    required this.name,
    required this.members,
    required this.desc,
    required this.badge,
    required this.badgeBg,
    required this.badgeColor,
  });
}

class _MinangGonjongSilhouettePainter extends CustomPainter {
  final Color color;

  _MinangGonjongSilhouettePainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.05, h * 0.85);
    path.quadraticBezierTo(w * 0.30, h * 0.75, w * 0.45, h * 0.40);
    path.quadraticBezierTo(w * 0.50, h * 0.15, w * 0.50, h * 0.05);
    path.quadraticBezierTo(w * 0.50, h * 0.15, w * 0.55, h * 0.40);
    path.quadraticBezierTo(w * 0.70, h * 0.75, w * 0.95, h * 0.85);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MinangGonjongSilhouettePainter oldDelegate) => oldDelegate.color != color;
}

class _JamGadangSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.42, h);
    path.lineTo(w * 0.42, h * 0.55);
    path.lineTo(w * 0.36, h * 0.55);
    path.lineTo(w * 0.36, h * 0.46);
    path.lineTo(w * 0.40, h * 0.46);
    path.lineTo(w * 0.40, h * 0.33);
    path.lineTo(w * 0.34, h * 0.33);
    path.lineTo(w * 0.34, h * 0.25);
    path.lineTo(w * 0.45, h * 0.17);
    path.lineTo(w * 0.48, h * 0.04);
    path.lineTo(w * 0.50, 0);
    path.lineTo(w * 0.52, h * 0.04);
    path.lineTo(w * 0.55, h * 0.17);
    path.lineTo(w * 0.66, h * 0.25);
    path.lineTo(w * 0.66, h * 0.33);
    path.lineTo(w * 0.60, h * 0.33);
    path.lineTo(w * 0.60, h * 0.46);
    path.lineTo(w * 0.64, h * 0.46);
    path.lineTo(w * 0.64, h * 0.55);
    path.lineTo(w * 0.58, h * 0.55);
    path.lineTo(w * 0.58, h);
    path.close();

    canvas.drawPath(path, paint);

    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.50, h * 0.32), w * 0.05, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
