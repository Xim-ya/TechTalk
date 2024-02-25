import 'dart:async';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:techtalk/core/constants/stored_topic.dart';
import 'package:techtalk/core/helper/list_extension.dart';
import 'package:techtalk/core/helper/string_extension.dart';
import 'package:techtalk/core/services/snack_bar_service.dart';
import 'package:techtalk/features/chat/chat.dart';
import 'package:techtalk/presentation/pages/interview/chat/providers/chat_qnas_provider.dart';
import 'package:techtalk/presentation/pages/interview/chat/providers/selected_chat_room_provider.dart';
import 'package:techtalk/presentation/providers/user/user_info_provider.dart';

part 'chat_message_history_internal_event.dart';
part 'chat_message_history_provider.g.dart';

@riverpod
class ChatMessageHistory extends _$ChatMessageHistory {
  @override
  FutureOr<List<ChatMessageEntity>> build() async {
    final room = ref.read(selectedChatRoomProvider);
    final getChatList = switch (room.progressState) {
      ChatRoomProgress.initial => () async {
          await _showIntroAndQuestionMessages();
          return <ChatMessageEntity>[];
        },
      ChatRoomProgress.ongoing || ChatRoomProgress.completed => () async {
          final response = await getChatMessageHistoryUseCase(room.id);
          return response.fold(
            onSuccess: (chatCollection) {
              ref
                  .read(chatQnasProvider.notifier)
                  .arrangeQnasInOrder(chatCollection.progressQnaIds);
              return chatCollection.chatHistories;
            },
            onFailure: (e) {
              log(e.toString());

              throw e;
            },
          );
        },
    };

    return getChatList();
  }

  ///
  /// 유저의 채팅 답변 이후 인터뷰 진행 프로세스 단계를 실행시킴
  /// 인터뷰 진행 프로세스는 크게 4가지 프로세스로 구성됨.
  /// 1) 유저의 답변 채팅 메세지 추가
  /// 2) 유저의 답변 정답 여부 확인
  /// 3) 유저 답변에 대한 피드백 채팅 전달
  /// 4) 피드백 채팅이 전달된 이후 가이드 채팅과 다음 질문 채팅을 전달
  ///
  Future<void> proceedInterviewStep(String message) async {
    await addUserMessage(message).then(handleFeedbackProgress);
  }

  ///
  /// 1) 유저의 답변 채팅 메세지 추가
  ///
  Future<AnswerChatMessageEntity> addUserMessage(String message) async {
    final answeredQuestion = state.requireValue
            .firstWhere((chat) => chat is QuestionChatMessageEntity)
        as QuestionChatMessageEntity;
    final answerChat = AnswerChatMessageEntity.initial(
      message: message,
      qnaId: answeredQuestion.qnaId,
    );

    await showMessage(
      message: answerChat,
    );

    return answerChat;
  }

  ///
  /// 유저의 면접 질문 대답에 응답.
  /// 아래와 같은 이벤트를 실행시킴
  /// 2) 유저의 답변 정답 여부 확인
  /// 3) 유저 답변에 대한 피드백 채팅 전달
  /// 4) 피드백 채팅이 전달된 이후 가이드 채팅과 다음 질문 채팅을 전달
  ///
  Future<void> handleFeedbackProgress(
      AnswerChatMessageEntity userAnswer) async {
    late AnswerChatMessageEntity resolvedUserAnswer;
    late bool isAnswerCorrect;
    final room = ref.read(selectedChatRoomProvider);
    final qna =
        ref.read(chatQnasProvider.notifier).getQnaById(userAnswer.qnaId);
    /*final feedbackChat*/
    final response = getAnswerFeedBackUseCase.call(
      (
        qna: qna,
        checkAnswer: ({required isCorrect}) async {
          /// 2) 유저의 답변 정답 여부 확인
          resolvedUserAnswer =
              await _updateUserAnswerState(isCorrect: isCorrect);
          isAnswerCorrect = isCorrect;
        },
        question: state.requireValue
            .firstWhere((chat) => chat.type.isQuestionMessage)
            .message
            .value,
        userAnswer: userAnswer.message.value,
        onFeedBackCompleted: (String feedback) async {
          /// 4) 피드백 채팅이 전달된 이후 가이드 채팅과 다음 질문 채팅을 전달
          final isCompleted =
              ref.read(selectedChatRoomProvider.notifier).isLastQuestion();

          String guideMessage = isCompleted ? '면접이 종료 되었습니다' : '다음 질문을 드리겠습니다';

          final feedbackChat = FeedbackChatMessageEntity.createStatic(
            message: feedback,
            timestamp: DateTime.now(),
          );

          late QuestionChatMessageEntity nextQuestionChat;
          late GuideChatMessageEntity guideChat;

          if (!isCompleted) {
            final qna = _getNewQna();

            if (room.type.isPractical) {
              guideMessage =
                  '다음 ${StoredTopics.getById(qna.id.getFirstPartOfSpliited).text} 질문을 드리겠습니다.';
            }
            guideChat = GuideChatMessageEntity.createStatic(
              message: guideMessage,
              timestamp: DateTime.now(),
            );
            nextQuestionChat = QuestionChatMessageEntity.createStatic(
              qnaId: qna.qna.id,
              message: qna.qna.question,
              timestamp: DateTime.now(),
            );
          }

          await Future.wait([
            _uploadMessage([
              if (!isCompleted) nextQuestionChat,
              guideChat,
              feedbackChat,
              resolvedUserAnswer,
            ]).then(
              (_) => ref
                  .read(selectedChatRoomProvider.notifier)
                  .updateProgressInfo(
                      isCorrect: isAnswerCorrect,
                      lastChatMessage:
                          isCompleted ? guideChat : nextQuestionChat),
            ),
            showMessage(
              message: guideChat.overwriteToStream(),
              onDone: () async {
                if (!isCompleted) {
                  await showMessage(
                      message: nextQuestionChat.overwriteToStream());
                }
              },
            )
          ]);
        },
      ),
    );

    await response.fold(
      onSuccess: (feedbackStreamedChat) async {
        /// 3) 유저 답변에 대한 피드백 채팅 전달
        await showMessage(
          message: FeedbackChatMessageEntity(
            message: feedbackStreamedChat,
          ),
        );
      },
      onFailure: (e) {
        _rollbackToPreviousChatStep();
        SnackBarService.showSnackBar(
            '정답 여부를 판별하는 과정에서 오류가 발생했습니다. 잠시후 다시 시도해주세요.');
      },
    );
  }

  ///
  /// 가장 마지막으로 보낸진 [ReceivedChatEntity] 데이터 여부
  /// 하나의 질문 단위로 섹션이 구분
  ///
  /// ex)
  /// [ReceivedChatEntity](N) - [ReceivedChatEntity](Y) - [AnswerChatMessageEntity]
  /// [ReceivedChatEntity](N) - [ReceivedChatEntity](Y) - [AnswerChatMessageEntity] - [ReceivedChatEntity](N) - [ReceivedChatEntity](Y)
  ///
  bool isLastReceivedChatInEachQuestion({required int index}) {
    final chatList = state.requireValue;

    if (index != 0 && state.requireValue[index - 1].type.isSentMessage) {
      return true;
    }

    if (index == 0 && chatList.first.type.isReceivedMessage) {
      return true;
    }

    return false;
  }
}
