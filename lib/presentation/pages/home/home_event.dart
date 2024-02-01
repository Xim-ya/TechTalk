import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:techtalk/app/router/router.dart';
import 'package:techtalk/core/constants/interview_type.enum.dart';
import 'package:techtalk/features/topic/topic.dart';
import 'package:techtalk/presentation/pages/interview/chat_list/providers/practical_chat_room_list_provider.dart';
import 'package:techtalk/presentation/providers/user/user_info_provider.dart';

mixin class HomeEvent {
  ///
  /// 실전 면접 카드가 클릭 되었을 때
  /// 실전 면접 기록 여부에 따라 라우팅을 다르게 진행
  ///
  Future<void> onPracticalCardTapped(WidgetRef ref) async {
    await EasyLoading.show();

    final hasNotPracticalInterviewRecord =
        !ref.read(userInfoProvider).requireValue!.hasPracticalInterviewRecord;

    if (hasNotPracticalInterviewRecord) {
      final chatRooms = await ref.read(practicalChatRoomListProvider.future);
      if (chatRooms.isEmpty) {
        InterviewTopicSelectRoute(InterviewType.practical).push(ref.context);
      } else {
        ChatListRoute(InterviewType.practical, $extra: chatRooms)
            .push(ref.context);
        unawaited(ref
            .read(userInfoProvider.notifier)
            .storeUserPracticalRecordExistInfo());
      }
    } else {
      ChatListRoute(InterviewType.practical).push(ref.context);
    }

    unawaited(EasyLoading.dismiss());
  }

  void onTapNewTopicInterview() {
    InterviewTopicSelectRoute(InterviewType.singleTopic)
        .push(rootNavigatorKey.currentContext!);
  }

  Future<void> onTapGoToInterviewRoomListPage(
    WidgetRef ref, {
    required TopicEntity topic,
  }) async {
    // final chatRooms = await ref.read(
    //     interviewRoomsProvider(InterviewType.singleTopic, topic.id).future);
    // if (chatRooms.isEmpty) {
    //   QuestionCountSelectPageRoute(
    //     InterviewType.singleTopic,
    //     $extra: [topic],
    //   ).push(ref.context);
    // } else {
    //   ChatListPageRoute(InterviewType.singleTopic, topicId: topic.id)
    //       .push(rootNavigatorKey.currentContext!);
    // }
  }
}
