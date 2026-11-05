import 'package:smart_bk_care/core/constants/enums.dart';
import 'package:smart_bk_care/features/education/domain/entities/education_entity.dart';

abstract class EducationRepository {
  Future<List<EducationalContentEntity>> getPublishedContents({String? categoryTag});
  Future<EducationalContentEntity> getContentById(String id);
}

class EducationRepositoryImpl implements EducationRepository {
  static final List<EducationalContentEntity> _mockContents = [
    EducationalContentEntity(
      id: 'edu-001',
      title: 'Harmoni Jiwa: Menghubungkan Syarak dan Pengendalian Diri Remaja Minang',
      type: ContentType.article,
      contentBody: '''
### Memaknai Ketenangan dari Nilai Luhur Minangkabau

Remaja Minangkabau hidup dalam perpaduan falsafah luhur Adat Basandi Syarak, Syarak Basandi Kitabullah. Dalam menghadapi kecemasan akademik dan dinamika sosial:

1. Duduak Meraut Ranjo, Tagak Meninjau Jarak: Mengajarkan kita untuk selalu melatih kesadaran diri (mindfulness), tenang mengamati situasi sebelum bereaksi secara emosional.
2. Kato Nan Ampek: Fondasi komunikasi asertif yang melindungi kita dari perundungan verbal tanpa harus membalas dengan kekerasan kata-kata.
3. Kekuatan Doa & Regulasi Diri: Menggabungkan ikhtiar manajemen stres modern dengan ibadah reflektif sebagai sumber ketenangan batin.
''',
      tags: const ['budaya', 'mindfulness', 'relaksasi'],
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      authorName: 'Tim Bimbingan Konseling Sumatera Barat',
    ),
    EducationalContentEntity(
      id: 'edu-002',
      title: 'Panduan Praktis Melawan Cyberbullying Tanpa Takut',
      type: ContentType.article,
      contentBody: '''
### Kenali Hak Perlindunganmu di Ranah Digital

Perundungan siber (cyberbullying) bukan hal yang harus kamu tanggung sendirian. Bila kamu atau sahabatmu mengalaminya:

* Amankan Bukti: Simpan tangkapan layar percakapan, tautan akun, dan waktu kejadian.
* Jangan Membalas dengan Nada Serupa: Pembalasan sering kali mengaburkan pokok masalah dan memperparah eskalasi.
* Gunakan Fitur Pelaporan Rahasia: Fitur Laporkan Kasus di aplikasi Smart BK Care menjamin 100% anonimitasmu terlindungi dari intimidasi.
* Bicaralah dengan Guru BK: Konselor sekolah siap menjadi pendengar aman tanpa menghakimimu.
''',
      tags: const ['anti-bullying', 'keamanan-digital', 'hukum'],
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      authorName: 'Dinas Pendidikan & ABKIN Sumbar',
    ),
    EducationalContentEntity(
      id: 'edu-003',
      title: 'Teknik Pernapasan 4-7-8 untuk Meredakan Serangan Panik',
      type: ContentType.infographic,
      contentBody: '''
### Langkah Cepat Mengatur Sistem Saraf Simpatik:

1. Tarik napas perlahan melalui hidung selama 4 detik.
2. Tahan napas dengan nyaman di rongga dada selama 7 detik.
3. Hembuskan napas perlahan melalui bibir mengerucut selama 8 detik.
4. Ulangi siklus ini 4 hingga 5 kali sampai detak jantung kembali stabil.
''',
      tags: const ['relaksasi', 'panik', 'ujian'],
      publishedAt: DateTime.now().subtract(const Duration(days: 8)),
      authorName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
    ),
  ];

  @override
  Future<List<EducationalContentEntity>> getPublishedContents({String? categoryTag}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (categoryTag != null && categoryTag.isNotEmpty) {
      return _mockContents.where((c) => c.tags.contains(categoryTag.toLowerCase())).toList();
    }
    return _mockContents;
  }

  @override
  Future<EducationalContentEntity> getContentById(String id) async {
    return _mockContents.firstWhere(
      (c) => c.id == id,
      orElse: () => _mockContents.first,
    );
  }
}
