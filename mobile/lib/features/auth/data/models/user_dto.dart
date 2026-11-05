import 'package:smart_bk_care/core/constants/enums.dart';
import 'package:smart_bk_care/features/auth/domain/entities/user_entity.dart';

class UserDto extends UserEntity {
  const UserDto({
    required super.id,
    required super.identityNumber,
    required super.fullName,
    required super.email,
    super.phoneNumber,
    required super.role,
    super.schoolId,
    super.schoolName,
    super.isActive,
    super.gradeClass,
    super.major,
    super.gender,
    super.counselingCertificationNo,
    super.educationBackground,
    super.isAvailable,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      identityNumber: json['identity_number'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      role: UserRole.fromString(json['role'] as String),
      schoolId: json['school_id'] as String?,
      schoolName: json['school_name'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      gradeClass: json['grade_class'] as String?,
      major: json['major'] as String?,
      gender: json['gender'] as String?,
      counselingCertificationNo: json['counseling_certification_no'] as String?,
      educationBackground: json['education_background'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identity_number': identityNumber,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role.toDbValue(),
      'school_id': schoolId,
      'school_name': schoolName,
      'is_active': isActive,
      'grade_class': gradeClass,
      'major': major,
      'gender': gender,
      'counseling_certification_no': counselingCertificationNo,
      'education_background': educationBackground,
      'is_available': isAvailable,
    };
  }
}
