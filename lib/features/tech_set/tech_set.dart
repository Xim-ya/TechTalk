import 'package:techtalk/app/di/locator.dart';
import 'package:techtalk/features/tech_set/tech_set.dart';
import 'package:techtalk/features/tech_set/usecases/get_searched_skills.dart';

export 'data/local/tech_set_local_data_source.dart';
export 'data/remote/tech_set_data_source.dart';
export 'entities/job_entity.dart';
export 'repositories/tech_set_repository.dart';
export 'usecases/get_jobs_use_case.dart';

final techSetRemoteDataSource = locator<TechSetDataSource>();
final techSetLocalDataSource = locator<TechSetLocalDataSource>();

final techSetRepository = locator<TechSetRepository>();
final getJobsUseCase = locator<GetJobsUseCase>();
final getSearchedSkills = locator<GetSearchedSkills>();
