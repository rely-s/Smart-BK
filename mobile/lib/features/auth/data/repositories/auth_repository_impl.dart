import 'dart:convert';
import '../../../../core/constants/enums.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ISecureStorageService _secureStorage;
  static const String _userSessionKey = 'smart_bk_user_session';

  // Master akun mock yang sesuai dengan skema basis data PostgreSQL Smart BK Care
  static final List<UserDto> _mockUsers = [
    const UserDto(
      id: 'e28bbd91-382a-4389-a541-11910cf90011',
      identityNumber: '0071234567',
      fullName: 'Fajri Pratama',
      email: 'fajri.pratama@siswa.sumbar.belajar.id',
      phoneNumber: '081267890123',
      role: UserRole.student,
      schoolId: 'a11bbd91-382a-4389-a541-11910cf90001',
      schoolName: 'SMAN 1 Padang',
      isActive: true,
      gradeClass: 'XI-F2',
      major: 'Fase F (Kurikulum Merdeka)',
      gender: 'Laki-laki',
    ),
    const UserDto(
      id: 'e28bbd91-382a-4389-a541-11910cf90022',
      identityNumber: '198504122010012015',
      fullName: 'Dra. Rahmi Fadilah, M.Pd., Kons.',
      email: 'rahmi.fadilah@guru.sumbar.belajar.id',
      phoneNumber: '081374561234',
      role: UserRole.bkTeacher,
      schoolId: 'a11bbd91-382a-4389-a541-11910cf90001',
      schoolName: 'SMAN 1 Padang',
      isActive: true,
      counselingCertificationNo: 'ABKIN-SB-2018-0912',
      educationBackground: 'S2 Bimbingan & Konseling Universitas Negeri Padang',
      isAvailable: true,
    ),
    const UserDto(
      id: 'e28bbd91-382a-4389-a541-11910cf90033',
      identityNumber: '1371051203750001',
      fullName: 'Hendra Syahputra, S.T. (Wali Siswa)',
      email: 'hendra.syahputra@gmail.com',
      phoneNumber: '081166778899',
      role: UserRole.parent,
      schoolId: 'a11bbd91-382a-4389-a541-11910cf90001',
      schoolName: 'SMAN 1 Padang',
      isActive: true,
    ),
  ];

  AuthRepositoryImpl({required ISecureStorageService secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<UserEntity> login({
    required String identityNumberOrEmail,
    required String password,
  }) async {
    // Simulasi delay jaringan realistis (400ms)
    await Future.delayed(const Duration(milliseconds: 400));

    final query = identityNumberOrEmail.trim().toLowerCase();
    final matched = _mockUsers.where((u) =>
        u.identityNumber.toLowerCase() == query ||
        u.email.toLowerCase() == query);

    if (matched.isNotEmpty) {
      final user = matched.first;
      await _secureStorage.write(_userSessionKey, jsonEncode(user.toJson()));
      return user;
    }

    // Default fallback untuk demo login fleksibel
    final defaultUser = _mockUsers.first;
    await _secureStorage.write(_userSessionKey, jsonEncode(defaultUser.toJson()));
    return defaultUser;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final rawJson = await _secureStorage.read(_userSessionKey);
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final map = jsonDecode(rawJson) as Map<String, dynamic>;
        return UserDto.fromJson(map);
      } catch (_) {
        return null;
      }
    }
    // Jika belum login, gunakan Siswa sebagai inisial default demo
    return _mockUsers.first;
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(_userSessionKey);
  }

  @override
  Future<UserEntity> switchDemoRole(UserRole targetRole) async {
    final target = _mockUsers.firstWhere(
      (u) => u.role == targetRole,
      orElse: () => _mockUsers.first,
    );
    await _secureStorage.write(_userSessionKey, jsonEncode(target.toJson()));
    return target;
  }
}
