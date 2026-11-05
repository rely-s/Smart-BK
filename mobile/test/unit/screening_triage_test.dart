import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bk_care/core/constants/enums.dart';
import 'package:smart_bk_care/features/screening/data/repositories/screening_repository_impl.dart';

void main() {
  group('Screening Triage & Scoring Engine Unit Tests', () {
    late ScreeningRepositoryImpl repository;

    setUp(() {
      repository = ScreeningRepositoryImpl();
    });

    test('Harus memuat instrumen psikometri (GAD-7, DASS, Well-Being)', () async {
      final instruments = await repository.getInstruments();
      expect(instruments.isNotEmpty, true);
      expect(instruments.any((i) => i.code == 'GAD-7'), true);
      expect(instruments.any((i) => i.code == 'DASS-STRESS'), true);
    });

    test('Skor 0-5 harus menghasilkan kategori LOW tanpa pemicu alert', () async {
      final result = await repository.submitScreening(
        studentUserId: 'student-01',
        instrumentId: 'inst-gad7-001',
        answers: {'q-gad7-1': 1, 'q-gad7-2': 1, 'q-gad7-3': 1}, // Total: 3
      );

      expect(result.totalScore, 3);
      expect(result.calculatedRisk, RiskLevel.low);
      expect(result.alertTriggered, false);
    });

    test('Skor 6-10 harus menghasilkan kategori MODERATE', () async {
      final result = await repository.submitScreening(
        studentUserId: 'student-01',
        instrumentId: 'inst-gad7-001',
        answers: {'q-gad7-1': 2, 'q-gad7-2': 2, 'q-gad7-3': 2, 'q-gad7-4': 2}, // Total: 8
      );

      expect(result.totalScore, 8);
      expect(result.calculatedRisk, RiskLevel.moderate);
      expect(result.alertTriggered, false);
    });

    test('Skor 11-14 harus menghasilkan kategori HIGH dan memicu alert darurat', () async {
      final result = await repository.submitScreening(
        studentUserId: 'student-01',
        instrumentId: 'inst-gad7-001',
        answers: {
          'q-gad7-1': 3,
          'q-gad7-2': 3,
          'q-gad7-3': 3,
          'q-gad7-4': 3,
        }, // Total: 12
      );

      expect(result.totalScore, 12);
      expect(result.calculatedRisk, RiskLevel.high);
      expect(result.alertTriggered, true);
    });

    test('Skor >= 15 harus menghasilkan kategori SEVERE dan memicu alert darurat', () async {
      final result = await repository.submitScreening(
        studentUserId: 'student-01',
        instrumentId: 'inst-gad7-001',
        answers: {
          'q-gad7-1': 3,
          'q-gad7-2': 3,
          'q-gad7-3': 3,
          'q-gad7-4': 3,
          'q-gad7-5': 3,
          'q-gad7-6': 3,
        }, // Total: 18
      );

      expect(result.totalScore, 18);
      expect(result.calculatedRisk, RiskLevel.severe);
      expect(result.alertTriggered, true);
    });
  });
}

