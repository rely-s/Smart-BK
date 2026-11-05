import '../entities/user_entity.dart';
import '../../../../core/constants/enums.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String identityNumberOrEmail,
    required String password,
  });

  Future<UserEntity?> getCurrentUser();

  Future<void> logout();

  Future<UserEntity> switchDemoRole(UserRole targetRole);
}

