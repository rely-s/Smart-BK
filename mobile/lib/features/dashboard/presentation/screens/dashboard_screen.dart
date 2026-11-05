import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Dashboard Screen Smart BK Care (Beranda)
/// Didesain dengan estetika modern, natural, dan human-crafted:
/// - Tipografi berbobot dengan hierarki visual yang jelas.
/// - Palet warna terkontrol dan berkelas (tidak norak/generik).
/// - Micro-interaction: Mood Tracker harian ("Bagaimana suasana hatimu hari ini?") interaktif.
/// - Student Sanctuary Hero Card berlatar putih bersih dengan siluet Gonjong Minang yang anggun.
/// - Fitur layanan konseling dengan kartu taktil responsif.
/// - Pojok Inspirasi Pelajar Minang dengan dialog bacaan reflektif.
/// - Sidebar Drawer dan dialog interaktif komunitas.
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

  // State mood harian interaktif
  int? _selectedMoodIndex;

  final List<_MoodItem> _moods = const [
    _MoodItem(emoji: '😊', label: 'Senang', feedback: 'Energi positifmu berharga! Terus jaga ritme belajar dan istirahatmu ya.'),
    _MoodItem(emoji: '😌', label: 'Tenang', feedback: 'Kondisi emosi yang stabil adalah fondasi terbaik untuk fokus hari ini.'),
    _MoodItem(emoji: '😐', label: 'Biasa', feedback: 'Hari yang santai juga baik. Luangkan waktu sejenak untuk hal yang kamu sukai.'),
    _MoodItem(emoji: '😟', label: 'Cemas', feedback: 'Wajar merasa cemas. Tarik napas perlahan, Guru BK siap mendengarkan tanpa menghakimi.'),
    _MoodItem(emoji: '😔', label: 'Lelah', feedback: 'Tubuh dan pikiranmu butuh jeda. Jangan ragu beristirahat atau bercerita ke Guru BK.'),
  ];

  // Rekomendasi pencarian cepat
  final List<_SearchSuggestion> _allSuggestions = const [
    _SearchSuggestion(
      label: 'Curhat dengan Guru BK',
      icon: Icons.chat_bubble_rounded,
      target: _SearchTarget.counseling,
    ),
    _SearchSuggestion(
      label: 'Cek Kecemasan Ujian',
      icon: Icons.psychology_rounded,
      target: _SearchTarget.screening,
    ),
    _SearchSuggestion(
      label: 'Reservasi Konseling Tatap Muka',
      icon: Icons.event_rounded,
      target: _SearchTarget.counseling,
    ),
    _SearchSuggestion(
      label: 'Lapor Perundungan Anonim',
      icon: Icons.shield_rounded,
      target: _SearchTarget.report,
    ),
    _SearchSuggestion(
      label: 'Modul Mengatasi Stres',
      icon: Icons.menu_book_rounded,
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
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: _buildCustomHeader(context),
            drawer: _buildSidebarDrawer(context, user),
            body: GestureDetector(
              onTap: () {
                if (_searchFocusNode.hasFocus) {
                  _searchFocusNode.unfocus();
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.isStudent) ...[
                      // 1. Student Sanctuary Hero Card
                      _buildStudentSanctuaryHeroCard(user),
                      const SizedBox(height: 16),

                      // 2. Interactive Daily Mood Check-In
                      _buildMoodCheckInWidget(),
                      const SizedBox(height: 16),

                      // 3. Search Bar Modern
                      _buildSearchBar(),
                      const SizedBox(height: 20),

                      // 4. Layanan Bimbingan Konseling Grid
                      _buildServicesSection(),
                      const SizedBox(height: 20),

                      // 5. Inspirasi Pelajar Minang Banner
                      _buildInspirasiMinangBanner(),
                    ] else ...[
                      // Counselor View
                      _buildCounselorHeroCard(user),
                      const SizedBox(height: 16),
                      _buildCounselorOverview(),
                    ],
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Color(0xFFF8FAFC),
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF0F52BA)),
          ),
        );
      },
    );
  }

  // ==========================================
  // 1. HEADER MODERN & BERSIH
  // ==========================================
  PreferredSizeWidget _buildCustomHeader(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      automaticallyImplyLeading: false,
      titleSpacing: 18,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: const Color(0xFFE2E8F0),
          height: 1.0,
        ),
      ),
      title: Row(
        children: [
          // Drawer Menu Button
          Builder(
            builder: (ctx) => InkWell(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  size: 20,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Logo Gradient
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003C90), Color(0xFF0F52BA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003C90).withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Judul Smart BK Care & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Flexible(
                      child: Text(
                        'Smart BK Care',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F52BA),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'SUMATERA BARAT',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                    letterSpacing: 1.0,
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
          padding: const EdgeInsets.only(right: 18),
          child: InkWell(
            onTap: widget.onNavigateToNotification,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: Color(0xFF475569),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE11D48),
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
  // 2. STUDENT SANCTUARY HERO CARD
  // ==========================================
  Widget _buildStudentSanctuaryHeroCard(UserEntity user) {
    final firstName = user.fullName.split(' ').first;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Siluet Watermark Minang Halus
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.04,
              child: CustomPaint(
                size: const Size(130, 100),
                painter: _MinangGonjongSilhouettePainter(color: const Color(0xFF003C90)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ruang Aman Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Ruang Aman Siswa ${user.schoolName ?? "SMA Negeri 1 Padang"}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Sapaan Ramah
                Text(
                  'Halo, $firstName! 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Pertanyaan Empatik
                const Text(
                  'Ada hal yang mengganjal atau ingin kamu ceritakan hari ini? Guru BK siap mendengarkan tanpa menghakimi.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),

                // Note Perlindungan Privasi
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 13,
                        color: Color(0xFF0F52BA),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Kerahasiaan data dijamin & terlindungi kode etik konseling',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
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
  // 3. INTERACTIVE DAILY MOOD CHECK-IN
  // ==========================================
  Widget _buildMoodCheckInWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Bagaimana perasaanmu saat ini?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Refleksi Hari Ini',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_moods.length, (index) {
              final mood = _moods[index];
              final isSelected = _selectedMoodIndex == index;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedMoodIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF0F52BA) : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            mood.emoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mood.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF003C90) : const Color(0xFF64748B),
                            ),
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
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite_rounded, size: 16, color: Color(0xFF0F52BA)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _moods[_selectedMoodIndex!].feedback,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF1E3A8A),
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
    );
  }

  // ==========================================
  // 4. SEARCH BAR MODERN & MINIMALIS
  // ==========================================
  Widget _buildSearchBar() {
    final filtered = _allSuggestions.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(
                Icons.search_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Cari info materi, curhat, atau jadwal konseling...',
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF94A3B8)),
                  onPressed: () => _searchController.clear(),
                  visualDensity: VisualDensity.compact,
                ),
              IconButton(
                icon: const Icon(Icons.tune_rounded, size: 18, color: Color(0xFF64748B)),
                onPressed: widget.onNavigateToEducation,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),

        if (_isSearchActive && _searchQuery.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                if (filtered.isNotEmpty)
                  ...filtered.map(
                    (s) => InkWell(
                      onTap: () => _handleSuggestionTap(s.target),
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Row(
                          children: [
                            Icon(s.icon, size: 18, color: const Color(0xFF0F52BA)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                s.label,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
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
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
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
  // 5. GRID LAYANAN BIMBINGAN KONSELING
  // ==========================================
  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Layanan Bimbingan Konseling',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
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
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 12,
                    color: Color(0xFF0F52BA),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Terlindungi & Rahasia',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F52BA),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Grid 6 Kartu Layanan (2 Kolom)
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                title: 'Curhat & Konseling',
                subtitle: 'Chat, voice, video',
                cta: 'Mulai sesi',
                icon: Icons.chat_bubble_rounded,
                iconColor: const Color(0xFF0F52BA),
                bgColor: const Color(0xFFEFF6FF),
                onTap: widget.onNavigateToCounseling,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildServiceCard(
                title: 'Tes Kesehatan Mental',
                subtitle: 'Refleksi mandiri',
                cta: 'Cek kondisi',
                icon: Icons.psychology_rounded,
                iconColor: const Color(0xFF4F46E5),
                bgColor: const Color(0xFFEEF2FF),
                onTap: widget.onNavigateToScreening,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                title: 'Lapor Kasus',
                subtitle: 'Aman & anonim',
                cta: 'Laporkan',
                icon: Icons.shield_rounded,
                iconColor: const Color(0xFFE11D48),
                bgColor: const Color(0xFFFFF1F2),
                onTap: widget.onNavigateToReport,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildServiceCard(
                title: 'Materi Edukasi',
                subtitle: 'Artikel & tips remaja',
                cta: 'Buka modul',
                icon: Icons.menu_book_rounded,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFFFBEB),
                onTap: widget.onNavigateToEducation,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                title: 'Jadwal Konseling',
                subtitle: 'Reservasi sesi',
                cta: 'Pilih waktu',
                icon: Icons.event_rounded,
                iconColor: const Color(0xFF059669),
                bgColor: const Color(0xFFECFDF5),
                onTap: widget.onNavigateToCounseling,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildServiceCard(
                title: 'Komunitas Siswa',
                subtitle: 'Ruang berbagi sebaya',
                cta: 'Gabung circle',
                icon: Icons.groups_rounded,
                iconColor: const Color(0xFF0891B2),
                bgColor: const Color(0xFFECFEFF),
                onTap: _showCommunityDialog,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required String cta,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    cta,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: iconColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 14,
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
  // 6. BANNER INSPIRASI PELAJAR MINANG
  // ==========================================
  Widget _buildInspirasiMinangBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F52BA), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F52BA).withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Siluet Jam Gadang
          Positioned(
            right: 4,
            bottom: -6,
            child: Opacity(
              opacity: 0.12,
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
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'INSPIRASI PELAJAR MINANG',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
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
                      fontSize: 16,
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
                      color: Color(0xFFDBEAFE),
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
                    InkWell(
                      onTap: _showStoryDialog,
                      borderRadius: BorderRadius.circular(9999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Baca Kisah Fajar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003C90),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF003C90)),
                          ],
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 15,
                          color: Color(0xFF34D399),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Konselor Berlisensi',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFDBEAFE),
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
  // 7. DIALOG: KISAH FAJAR
  // ==========================================
  void _showStoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'INSPIRASI PELAJAR MINANG',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003C90),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kisah Fajar: “Cerita Itu Kekuatan”',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(ctx).pop(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFF1F5F9), height: 20),
                const Text(
                  '“Dulu, menjelang ujian kenaikan kelas dan pemilihan jurusan kuliah, saya sering begadang semalaman karena takut gagal. Pikiran saya penuh dengan ekspektasi orang tua dan rasa takut tertinggal oleh teman-teman.”',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.5),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: const Text(
                    '“Saya kira datang ke Ruang BK itu hanya untuk siswa yang bermasalah. Ternyata anggapan itu salah besar.”',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003C90),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '“Bersama Ibu Rahmi Yunita di Ruang BK SMAN 1 Padang, saya belajar mengurai kecemasan saya satu per satu. Beliau tidak pernah menghakimi, melainkan membimbing saya menemukan gaya belajar yang tepat dan memetakan minat karir saya secara realistis.”',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.5),
                ),
                const SizedBox(height: 10),
                const Text(
                  '“Kini saya merasa jauh lebih percaya diri menghadapi ujian. Jangan ragu bercerita, karena membuka perasaan bukanlah tanda kelemahan, melainkan awal dari kekuatanmu.”',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.5),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      widget.onNavigateToCounseling();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003C90),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_rounded, size: 16),
                        SizedBox(width: 8),
                        Text('Mulai Cerita dengan Guru BK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 8. DIALOG: KOMUNITAS SISWA
  // ==========================================
  void _showCommunityDialog() {
    showDialog(
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
              badgeBg: const Color(0xFFDBEAFE),
              badgeColor: const Color(0xFF003C90),
            ),
            _CommunityCircle(
              id: 'circle-2',
              name: 'Sahabat Upstander Anti-Bullying',
              members: '890 Siswa',
              desc: 'Komunitas pelajar SMA/SMK se-Sumbar yang berkomitmen menciptakan iklim sekolah aman, inklusif, dan bebas perundungan.',
              badge: 'Sosial & Perlindungan',
              badgeBg: const Color(0xFFD1FAE5),
              badgeColor: const Color(0xFF065F46),
            ),
            _CommunityCircle(
              id: 'circle-3',
              name: 'Ruang Bernapas & Manajemen Stres',
              members: '1.150 Siswa',
              desc: 'Saling bertukar cerita ringan, tips istirahat produktif, serta musik dan hobi pereda penat sekolah.',
              badge: 'Kesejahteraan',
              badgeBg: const Color(0xFFFEF3C7),
              badgeColor: const Color(0xFF92400E),
            ),
          ];

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(20),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Komunitas Siswa Minang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Circle Berbagi Sebaya Terpantau BK',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.of(ctx).pop(),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    ...circles.map((c) {
                      final isJoined = _joinedCircles.contains(c.id);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isJoined ? const Color(0xFF0F52BA) : const Color(0xFFE2E8F0),
                            width: isJoined ? 1.5 : 1.0,
                          ),
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
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      color: c.badgeColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  c.members,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.desc,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.4),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
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
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isJoined ? const Color(0xFFEFF6FF) : Colors.white,
                                  foregroundColor: const Color(0xFF003C90),
                                  side: BorderSide(
                                    color: isJoined ? const Color(0xFF003C90) : const Color(0xFFCBD5E1),
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  visualDensity: VisualDensity.compact,
                                ),
                                child: Text(
                                  isJoined ? '✓ Tergabung dalam Circle' : '+ Gabung Circle',
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
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
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // 9. SIDEBAR DRAWER
  // ==========================================
  Widget _buildSidebarDrawer(BuildContext context, UserEntity user) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF003C90), Color(0xFF0F52BA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: 0.12,
                      child: CustomPaint(
                        size: const Size(100, 50),
                        painter: _MinangGonjongSilhouettePainter(),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.volunteer_activism_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Smart BK Care',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  Text(
                                    'SUMATERA BARAT',
                                    style: TextStyle(
                                      color: Color(0xFFBFDBFE),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
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
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    user.schoolName ?? 'SMA Negeri 1 Padang',
                                    style: const TextStyle(
                                      color: Color(0xFFBFDBFE),
                                      fontSize: 10.5,
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
                                color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(color: const Color(0xFF6EE7B7).withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, color: Color(0xFF6EE7B7), size: 6),
                                  SizedBox(width: 4),
                                  Text(
                                    'Aktif',
                                    style: TextStyle(
                                      color: Color(0xFFD1FAE5),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FITUR LAYANAN BK',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          '6 Layanan',
                          style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildDrawerItem(
                    icon: Icons.psychology_rounded,
                    iconColor: const Color(0xFF0284C7),
                    bgColor: const Color(0xFFF0F9FF),
                    title: 'Skrining Perasaan',
                    subtitle: 'Deteksi cemas, stres & suasana hati',
                    badge: '3 Topik',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToScreening();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.forum_rounded,
                    iconColor: const Color(0xFF003C90),
                    bgColor: const Color(0xFFEFF6FF),
                    title: 'Ruang Sesi Chat',
                    subtitle: 'Konseling privat & terenkripsi BK',
                    badge: 'Online',
                    isBadgePulse: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToCounseling();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_month_rounded,
                    iconColor: const Color(0xFF0D9488),
                    bgColor: const Color(0xFFF0FDFA),
                    title: 'Reservasi Konseling',
                    subtitle: 'Jadwal tatap muka / daring resmi',
                    badge: 'Dispensasi',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToCounseling();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.shield_rounded,
                    iconColor: const Color(0xFFE11D48),
                    bgColor: const Color(0xFFFFF1F2),
                    title: 'Lapor Rahasia',
                    subtitle: 'Pengaduan perundungan 100% aman',
                    badge: 'Anonim',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToReport();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.menu_book_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    bgColor: const Color(0xFFF5F3FF),
                    title: 'Edukasi & Literasi',
                    subtitle: 'Video, modul, artikel & podcast',
                    badge: 'Modul Gratis',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToEducation();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFFFBEB),
                    title: 'Analitik Sumbar',
                    subtitle: 'Data psikososial 19 Kab/Kota',
                    badge: 'Dinas Sumbar',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showInfographicsDialog();
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFF1F5F9), height: 1),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'MENU LAINNYA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  _buildSimpleDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Beranda Utama',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _buildSimpleDrawerItem(
                    icon: Icons.supervisor_account_rounded,
                    title: 'Dashboard Guru BK',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showRoleSwitcherDialog(context);
                    },
                  ),
                  _buildSimpleDrawerItem(
                    icon: Icons.account_circle_rounded,
                    title: 'Profil & Identitas Siswa',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToProfile();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required String badge,
    bool isBadgePulse = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isBadgePulse ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(9999),
                          border: isBadgePulse
                              ? Border.all(color: const Color(0xFFA7F3D0))
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isBadgePulse) ...[
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 3),
                            ],
                            Text(
                              badge,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isBadgePulse
                                    ? const Color(0xFF047857)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF64748B)),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfographicsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Arsitektur Smart BK Care',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFF1F5F9), height: 16),
              const Text(
                'Ekosistem Bimbingan Konseling Digital Provinsi Sumatera Barat mengintegrasikan:',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 10),
              _buildBulletPoint('19 Cabang Dinas Pendidikan Kabupaten/Kota se-Sumbar'),
              _buildBulletPoint('Portal Terenkripsi Guru BK & Konselor Bersertifikat'),
              _buildBulletPoint('Saluran Pelaporan Perundungan 100% Terlindungi ABKIN'),
              _buildBulletPoint('Integrasi Nilai Filosofi Minangkabau "Adat Basandi Syarak"'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003C90),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }

  void _showRoleSwitcherDialog(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final state = authBloc.state;
    if (state is! Authenticated) return;

    final currentRole = state.user.role;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Simulasi Peran Pengguna',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih peran untuk menguji antarmuka pengguna sesuai hak akses:',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              _buildRoleOption(
                ctx,
                authBloc,
                title: 'Siswa SMA Negeri 1 Padang',
                subtitle: 'Akses santuari konseling, skrining, edukasi, lapor aduan anonim',
                icon: Icons.school_rounded,
                role: UserRole.student,
                isSelected: currentRole == UserRole.student,
              ),
              const SizedBox(height: 8),
              _buildRoleOption(
                ctx,
                authBloc,
                title: 'Guru BK / Konselor Sekolah',
                subtitle: 'Manajemen kasus, jadwal tatap muka, asesmen klinis, chat siswa',
                icon: Icons.psychology_rounded,
                role: UserRole.bkTeacher,
                isSelected: currentRole == UserRole.bkTeacher,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleOption(
    BuildContext context,
    AuthBloc authBloc, {
    required String title,
    required String subtitle,
    required IconData icon,
    required UserRole role,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        authBloc.add(SwitchRoleEvent(role));
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF003C90) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF003C90) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF003C90) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF003C90), size: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // VIEW MODE: GURU BK
  // ==========================================
  Widget _buildCounselorHeroCard(UserEntity user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003C90), Color(0xFF0F52BA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Text(
                  'PORTAL GURU BK AKTIF',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                user.schoolName ?? 'SMAN 1 Padang',
                style: const TextStyle(color: Color(0xFFDBEAFE), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Selamat Bertugas, ${user.fullName}!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ruang pantau kesehatan mental siswa & penanganan aduan terenkripsi.',
            style: TextStyle(fontSize: 12, color: Color(0xFFDBEAFE)),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Antrean Layanan BK',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF131B2E)),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCounselorStatCard('3', 'Aduan Masuk', 'Perlu asesmen awal', const Color(0xFFFFF1F2), const Color(0xFFE11D48)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCounselorStatCard('5', 'Sesi Konseling', 'Hari ini', const Color(0xFFEFF6FF), const Color(0xFF003C90)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounselorStatCard(String count, String label, String sub, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: textCol.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textCol)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: textCol)),
          Text(sub, style: TextStyle(fontSize: 10.5, color: textCol.withValues(alpha: 0.8))),
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
  final String emoji;
  final String label;
  final String feedback;

  const _MoodItem({
    required this.emoji,
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
