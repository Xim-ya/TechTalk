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
  Future<UserDataEntity> getUserData(String uid) async {
    var userData = await _userRemoteDataSource.getUserData(uid);
    print(userData);

    if (userData == null) {
      await createUserData(
        UserDataEntity(uid: uid),
      );

      return getUserData(uid);
    }

    return UserDataEntity.fromModel(userData);
  }

  @override
  Future<bool> isExistNickname(String nickname) {
    return _userRemoteDataSource.isExistNickname(nickname);
  }
}
