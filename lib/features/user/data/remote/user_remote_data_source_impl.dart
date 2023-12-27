import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:techtalk/core/constants/firestore_collection.enum.dart';
import 'package:techtalk/core/models/exception/custom_exception.dart';
import 'package:techtalk/features/user/data/models/user_data_model.dart';
import 'package:techtalk/features/user/user.dart';
import 'package:uuid/uuid.dart';

final class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /// firestore에 저장된 users 컬렉션을 조회한다
  CollectionReference<UserDataModel> get _usersCollection => _firestore
      .collection(FirestoreCollection.users.name)
      .withConverter<UserDataModel>(
        fromFirestore: (snapshot, _) => UserDataModel.fromFirestore(snapshot),
        toFirestore: (value, _) => value.toFirestore(),
      );

  /// [data.uid]를 키로 가지는 도큐먼트를 조회한다
  DocumentReference<UserDataModel> _userDoc(String uid) =>
      _usersCollection.doc(uid);

  /// [uid]를 키로 가지는 데이터가 있는지 여부
  Future<bool> _isExistUserData(String uid) async =>
      (await _userDoc(uid).get()).exists;

  Future<bool> _isExistNickname(
    String uid,
    String nickname,
  ) async {
    final userSnapshot = await _userDoc(uid).get();
    final userNickname = userSnapshot.get('nickname');

    final isNicknameExist = await _usersCollection
        .where(
          'nickname',
          isEqualTo: nickname,
        )
        .count()
        .get()
        .then(
          (value) => value.count > 0,
        );

    return isNicknameExist && userNickname != nickname;
  }

  @override
  Future<void> createUserData(String uid) async {
    if (await _isExistUserData(uid)) {
      throw const AlreadyExistUserDataException();
    }

    await _userDoc(uid).set(
      UserDataModel(uid: uid),
    );
  }

  @override
  Future<void> updateUserData(UserDataEntity data) async {
    if (!await _isExistUserData(data.uid)) {
      throw const NoUserDataException();
    }

    if (data.nickname != null &&
        await _isExistNickname(data.uid, data.nickname!)) {
      throw AlreadyExistNicknameException();
    }

    await _userDoc(data.uid).update(
      UserDataModel.fromEntity(data).toFirestore(),
    );
  }

  @override
  Future<UserDataModel?> getUserData(String uid) async {
    if (!await _isExistUserData(uid)) {
      return null;
    }

    final snapshot = await _userDoc(uid).get();

    return snapshot.data();
  }

  @override
  Future<void> deleteUserData(String uid) async {
    await _userDoc(uid).delete();
  }

  @override
  Future<String> uploadImgFileAndGetUrl(File imageFile) async {
    final storageRef = _firebaseStorage
        .ref('profileImage')
        .child(FirebaseAuth.instance.currentUser?.uid ?? const Uuid().v1());
    final snapshot = await storageRef.putFile(imageFile);
    final String imgUrl = await snapshot.ref.getDownloadURL();
    return imgUrl;
  }
}
