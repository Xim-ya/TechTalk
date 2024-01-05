import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:techtalk/core/constants/job_group.enum.dart';
import 'package:techtalk/features/user/entities/user_data_entity.dart';

part 'user_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserDataModel {
  UserDataModel({
    required this.uid,
    this.profileImgUrl,
    this.nickname,
    this.jobGroupIds,
    this.topicIds,
  });

  final String uid;
  final String? profileImgUrl;
  final String? nickname;
  final List<String>? jobGroupIds;
  final List<String>? topicIds;

  factory UserDataModel.fromEntity(UserDataEntity entity) {
    return UserDataModel(
      uid: entity.uid,
      profileImgUrl: entity.profileImgUrl,
      nickname: entity.nickname,
      jobGroupIds: entity.jobGroups.map((e) => e.id).toList(),
      topicIds: entity.topicIds,
    );
  }

  UserDataEntity toEntity() {
    return UserDataEntity(
      uid: uid,
      nickname: nickname,
      jobGroupIds: jobGroupIds?.map((e) => JobGroup.getById(e)).toList(),
      topicIds: topicIds,
      profileImgUrl: profileImgUrl,
    );
  }

  factory UserDataModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) =>
      UserDataModel.fromJson(snapshot.data()!);

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return _$UserDataModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}
