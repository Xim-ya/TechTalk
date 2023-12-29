import 'dart:async';
import 'dart:io';

import 'package:techtalk/core/utils/base/base_use_case.dart';
import 'package:techtalk/core/utils/result.dart';
import 'package:techtalk/features/user/entities/user_data_entity.dart';
import 'package:techtalk/features/user/repositories/user_repository.dart';
import 'package:techtalk/presentation/pages/my_info/profile_setting/profile_setting_page.dart';

///
/// 유저 정보를 수정하는 useCase
/// [ProfileSettingPage] 영역에서 사용됨
///
class EditUserProfileUseCase extends BaseUseCase<
    ({UserDataEntity user, File? imageFile}), Result<void>> {
  EditUserProfileUseCase(this._repository);

  final UserRepository _repository;

  @override
  FutureOr<Result<void>> call(
      ({File? imageFile, UserDataEntity user}) request) async {
    UserDataEntity user;

    user = request.user;

    /// 전달 받은 이미지 파일이 있다면
    /// database store에 이미지를 저장하고 url 주소를 반환
    if (request.imageFile != null) {
      final response =
          await _repository.uploadImgFileAndGetUrl(request.imageFile!);
      final imgUrl = response.getOrThrow();
      user = request.user.copyWith(profileImgUrl: imgUrl);
      print('url : $imgUrl');
    }

    print('에임스 : ${user.profileImgUrl}');
    return _repository.updateUserData(user);
  }
}
