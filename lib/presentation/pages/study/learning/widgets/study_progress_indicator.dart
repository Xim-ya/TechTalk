import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:techtalk/core/theme/extension/app_color.dart';
import 'package:techtalk/core/theme/extension/app_text_style.dart';
import 'package:techtalk/presentation/providers/study/current_study_question_index_provider.dart';
import 'package:techtalk/presentation/providers/study/study_questions_provider.dart';

class StudyProgressIndicator extends ConsumerWidget {
  const StudyProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentStudyQuestionIndexProvider);
    final questionCount = ref.watch(studyQuestionsProvider).requireValue.length;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${current + 1}',
            style: AppTextStyle.body3.copyWith(
              color: AppColor.of.brand3,
            ),
          ),
          Text(
            ' / $questionCount 문항',
            style: AppTextStyle.body3.copyWith(
              color: AppColor.of.gray3,
            ),
          ),
        ],
      ),
    );
  }
}
