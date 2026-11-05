import 'package:get_it/get_it.dart';
import 'package:smart_bk_care/core/security/secure_storage_service.dart';
import 'package:smart_bk_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_bk_care/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_bk_care/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:smart_bk_care/features/screening/domain/repositories/screening_repository.dart';
import 'package:smart_bk_care/features/screening/data/repositories/screening_repository_impl.dart';
import 'package:smart_bk_care/features/screening/presentation/bloc/screening_bloc.dart';
import 'package:smart_bk_care/features/report_case/domain/repositories/report_repository.dart';
import 'package:smart_bk_care/features/report_case/data/repositories/report_repository_impl.dart';
import 'package:smart_bk_care/features/report_case/presentation/bloc/report_bloc.dart';
import 'package:smart_bk_care/features/tele_counseling/domain/repositories/counseling_repository.dart';
import 'package:smart_bk_care/features/tele_counseling/data/repositories/counseling_repository_impl.dart';
import 'package:smart_bk_care/features/tele_counseling/presentation/bloc/counseling_bloc.dart';
import 'package:smart_bk_care/features/education/data/repositories/education_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core Services
  sl.registerLazySingleton<ISecureStorageService>(() => SecureStorageService());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(secureStorage: sl<ISecureStorageService>()),
  );
  sl.registerLazySingleton<ScreeningRepository>(
    () => ScreeningRepositoryImpl(),
  );
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(),
  );
  sl.registerLazySingleton<CounselingRepository>(
    () => CounselingRepositoryImpl(),
  );
  sl.registerLazySingleton<EducationRepository>(
    () => EducationRepositoryImpl(),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc(authRepository: sl<AuthRepository>()));
  sl.registerFactory(() => ScreeningBloc(repository: sl<ScreeningRepository>()));
  sl.registerFactory(() => ReportBloc(repository: sl<ReportRepository>()));
  sl.registerFactory(() => CounselingBloc(repository: sl<CounselingRepository>()));
}
