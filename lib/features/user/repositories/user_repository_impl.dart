import 'package:firebase_auth/firebase_auth.dart';
import 'package:techtalk/core/utils/result.dart';
import 'package:techtalk/features/chat/chat.dart';
import 'package:techtalk/features/user/data/remote/user_remote_data_source.dart';
import 'package:techtalk/features/user/entities/user_data_entity.dart';
import 'package:techtalk/features/user/repositories/user_repository.dart';

final class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(
    this._userRemoteDataSource,
  );

  final UserRemoteDataSource _userRemoteDataSource;

  @override
  Future<void> createUserData(UserDataEntity data) async {
    await _userRemoteDataSource.createUserData(data.toModel());
  }

  @override
  Future<UserDataEntity?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    var userData = await _userRemoteDataSource.getUserData(uid);

    if (userData == null) {
      return null;
    }

    return UserDataEntity.fromModel(userData);
  }

  @override
  Future<Result<bool>> isExistNickname(String nickname) async {
    try {
      final result = await _userRemoteDataSource.isExistNickname(nickname);

      return Result.success(result);
    } catch (e) {
      return Result.failure(Exception(e));
    }
  }

  @override
  Future<Result<List<InterviewTopic>>> getUserTopicList() async {
    try {
      const userLocalId = '2FXrROIad2RSKt37NA8tciQx7e53'; // TEMP
      final response = await _userRemoteDataSource.getUserData(userLocalId);

      final topicIds = response?.topicIds ?? [];

      final result = topicIds.map(InterviewTopic.getTopicById).toList();

      return Result.success(result);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
