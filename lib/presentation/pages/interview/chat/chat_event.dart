import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:techtalk/core/services/dialog_service.dart';
import 'package:techtalk/core/services/toast_service.dart';
import 'package:techtalk/presentation/providers/interview/chat_history_of_room_provider.dart';
import 'package:techtalk/presentation/providers/interview/interview_progress_state_provider.dart';
import 'package:techtalk/presentation/providers/interview/selected_interview_room_provider.dart';
import 'package:techtalk/presentation/widgets/common/common.dart';
import 'package:techtalk/presentation/widgets/common/dialog/app_dialog.dart';

abstract class _ChatEvent {
  /// 채팅 입력창이 전송 되었을 때
  Future<void> onChatFieldSubmitted(
    WidgetRef ref, {
    required String message,
    required TextEditingController textEditingController,
    required ScrollController scrollController,
  });

  /// 앱바 뒤로 가기 버튼이 클릭 되었을 때
  void onAppbarBackBtnTapped(BuildContext context);
}

mixin class ChatEvent implements _ChatEvent {
  ///
  /// - 유저 채팅 응답 추가
  /// - 유저 채팅 응답
  /// - 입력된 채팅 state 초기화
  /// - 스크롤 포지션 맨 아래로 변경
  ///
  @override
  Future<void> onChatFieldSubmitted(
    WidgetRef ref, {
    required String message,
    required TextEditingController textEditingController,
    required ScrollController scrollController,
  }) async {
    if (message.isEmpty) {
      return ToastService.show(
        NormalToast(message: '답변을 입력해 주세요'),
      );
    }
    final room = ref.read(selectedInterviewRoomProvider).requireValue;
    ref
        .read(interviewProgressStateProvider(room).notifier)
        .changeState(InterviewProgress.interviewerReplying);

    textEditingController.clear();
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceIn,
    );

    await ref
        .read(chatHistoryOfRoomProvider(room).notifier)
        .addUserChatResponse(message: message);
    await ref
        .read(chatHistoryOfRoomProvider(room).notifier)
        .respondToUserAnswer(userAnswer: message);
  }

  @override
  void onAppbarBackBtnTapped(BuildContext context) {
    DialogService.show(
      dialog: AppDialog.dividedBtn(
        title: '알림',
        subTitle: '정말 면접을 종료하시겠어요?',
        description: '나중에 면접을 이어서 진행할 수 있습니다',
        leftBtnContent: '취소',
        rightBtnContent: '확인',
        onRightBtnClicked: () {
          context
            ..pop()
            ..pop();
        },
        onLeftBtnClicked: () {
          context.pop();
        },
      ),
    );
  }
}
