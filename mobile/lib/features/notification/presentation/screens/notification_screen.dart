import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedFilter = 'semua';

  List<_NotificationItemData> _items = [
    _NotificationItemData(
      id: 1,
      title: 'Sesi Konseling Dikonfirmasi',
      desc:
          'Jadwal tatap muka dengan Ibu Rahmi Yunita hari ini pukul 10:00 WIB di Ruang BK Sekolah. Surat dispensasi digital telah diterbitkan.',
      time: '15 Menit Lalu',
      type: 'konseling',
      unread: true,
      icon: Icons.event_available_rounded,
    ),
    _NotificationItemData(
      id: 2,
      title: 'Pesan Baru dari Ibu Rahmi Yunita',
      desc:
          '“Ibu sangat mengapresiasi keberanian Ananda untuk bercerita. Wajar sekali merasakan kecemasan itu, Nak...”',
      time: '08:33 WIB',
      type: 'konseling',
      unread: true,
      icon: Icons.chat_bubble_rounded,
    ),
    _NotificationItemData(
      id: 3,
      title: 'Pendaftaran Webinar Terkonfirmasi',
      desc:
          'Tiket Webinar Akbar "Menjaga Kesehatan Mental di Era Digital" bersama Dr. Henny M., M.Psi telah aktif.',
      time: 'Kemarin',
      type: 'webinar',
      unread: false,
      icon: Icons.campaign_rounded,
    ),
    _NotificationItemData(
      id: 4,
      title: 'Pengingat Refleksi Berkala',
      desc:
          'Sudah 7 hari sejak refleksi perasaan terakhirmu. Cek kondisimu sejenak untuk evaluasi suasana hati pekan ini.',
      time: '3 Hari Lalu',
      type: 'konseling',
      unread: false,
      icon: Icons.psychology_rounded,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      _items = _items.map((e) => e.copyWith(unread: false)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((e) {
      if (_selectedFilter == 'semua') return true;
      return e.type == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pemberitahuan & Pengingat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Notifikasi layanan bimbingan konseling',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Tandai Dibaca',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF003C90),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs (Semua, Konseling, Webinar)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _buildFilterChip('semua', 'Semua'),
                const SizedBox(width: 8),
                _buildFilterChip('konseling', 'Konseling'),
                const SizedBox(width: 8),
                _buildFilterChip('webinar', 'Webinar'),
              ],
            ),
          ),
          const Divider(color: Color(0xFFE2E8F0), height: 1),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = filtered[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _items = _items.map((e) {
                        if (e.id == item.id) return e.copyWith(unread: false);
                        return e;
                      }).toList();
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: item.unread ? Colors.white : Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.unread ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0),
                        width: item.unread ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: item.unread ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.unread ? const Color(0xFF003C90) : const Color(0xFF64748B),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: item.unread ? FontWeight.w800 : FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item.time,
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.desc,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = key),
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003C90) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}

class _NotificationItemData {
  final int id;
  final String title;
  final String desc;
  final String time;
  final String type;
  final bool unread;
  final IconData icon;

  _NotificationItemData({
    required this.id,
    required this.title,
    required this.desc,
    required this.time,
    required this.type,
    required this.unread,
    required this.icon,
  });

  _NotificationItemData copyWith({bool? unread}) {
    return _NotificationItemData(
      id: id,
      title: title,
      desc: desc,
      time: time,
      type: type,
      unread: unread ?? this.unread,
      icon: icon,
    );
  }
}
