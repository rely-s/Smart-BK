import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';

class UserEntity extends Equatable {
  final String id;
  final String identityNumber; // NISN untuk siswa, NUPTK untuk Guru BK, NIP untuk dinas
  final String fullName;
  final String email;
  final String? phoneNumber;
  final UserRole role;
  final String? schoolId;
  final String? schoolName;
  final bool isActive;

  // Student specific details
  final String? gradeClass;
  final String? major;
  final String? gender;

  // Counselor specific details
  final String? counselingCertificationNo;
  final String? educationBackground;
  final bool isAvailable;

  const UserEntity({
    required this.id,
    required this.identityNumber,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.schoolId,
    this.schoolName,
    this.isActive = true,
    this.gradeClass,
    this.major,
    this.gender,
    this.counselingCertificationNo,
    this.educationBackground,
    this.isAvailable = true,
  });

  bool get isStudent => role == UserRole.student;
  bool get isCounselor => role == UserRole.bkTeacher;

  @override
  List<Object?> get props => [
        id,
        identityNumber,
        fullName,
        email,
        phoneNumber,
        role,
        schoolId,
        schoolName,
        isActive,
        gradeClass,
        major,
        gender,
        counselingCertificationNo,
        educationBackground,
        isAvailable,
      ];
}

