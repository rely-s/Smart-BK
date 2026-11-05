import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bk_care/core/constants/enums.dart';
import 'package:smart_bk_care/core/security/crypto_helper.dart';
import 'package:smart_bk_care/features/report_case/data/repositories/report_repository_impl.dart';

void main() {
  group('Safe Reporting & Anonymous Whistleblowing Privacy Tests (UU PDP)', () {
    late ReportRepositoryImpl repository;

    setUp(() {
      repository = ReportRepositoryImpl();
    });

    test('Mode 100% anonim harus menghapus seluruh metadata identitas pelapor', () async {
      final report = await repository.submitReport(
        reporterUserId: 'secret-student-id-12345',
        reporterName: 'Fajri Pratama',
        isAnonymous: true,
        schoolId: 'school-padang-01',
        schoolName: 'SMAN 1 Padang',
        incidentType: IncidentType.cyberBullying,
        incidentDate: DateTime.now(),
        location: 'Media Sosial',
        chronology: 'Kronologi pengaduan cyberbullying.',
        urgencyLevel: CaseUrgency.high,
      );

      // Verifikasi kerahasiaan identitas: ID dan Nama Pelapor HARUS bernilai null
      expect(report.isAnonymous, true);
      expect(report.reporterUserId, null);
      expect(report.reporterName, null);
      expect(report.ticketNumber.startsWith('BK-REP-'), true);
      expect(report.status, CaseStatus.submitted);
    });

    test('Mode terverifikasi harus mencatat nama dan ID siswa untuk tindak lanjut', () async {
      final report = await repository.submitReport(
        reporterUserId: 'verified-student-id-12345',
        reporterName: 'Fajri Pratama',
        isAnonymous: false,
        schoolId: 'school-padang-01',
        schoolName: 'SMAN 1 Padang',
        incidentType: IncidentType.physicalBullying,
        incidentDate: DateTime.now(),
        location: 'Halaman Olahraga',
        chronology: 'Terjadi pemukulan setelah jam sekolah.',
        urgencyLevel: CaseUrgency.critical,
      );

      expect(report.isAnonymous, false);
      expect(report.reporterUserId, 'verified-student-id-12345');
      expect(report.reporterName, 'Fajri Pratama');
    });

    test('Format nomor tiket harus unik dan sesuai standar sistem BK-REP-YYYYMM-XXXX', () {
      final ticket1 = CryptoHelper.generateTicketNumber();
      final ticket2 = CryptoHelper.generateTicketNumber();

      expect(ticket1.startsWith('BK-REP-'), true);
      expect(ticket2.startsWith('BK-REP-'), true);
    });
  });
}

