import 'package:get_it/get_it.dart';
import 'package:techtalk/app/di/feature_di_interface.dart';
import 'package:techtalk/features/job/data/remote/job_remote_data_source_impl.dart';
import 'package:techtalk/features/job/job.dart';
import 'package:techtalk/features/job/repositories/job_repository_impl.dart';

final class JobDependencyInjection extends FeatureDependencyInjection {
  @override
  void dataSources() {
    GetIt.I.registerLazySingleton<JobRemoteDataSource>(
      JobRemoteDataSourceImpl.new,
    );
  }

  @override
  void repositories() {
    final jobRemoteDataSource = GetIt.I<JobRemoteDataSource>();

    GetIt.I.registerLazySingleton<JobRepository>(
      () => JobRepositoryImpl(
        jobRemoteDataSource,
      ),
    );
  }

  @override
  void useCases() {
    final jobRepository = GetIt.I<JobRepository>();

    GetIt.I.registerFactory<GetJobGroupListUseCase>(
      () => GetJobGroupListUseCase(
        jobRepository,
      ),
    );
  }
}
