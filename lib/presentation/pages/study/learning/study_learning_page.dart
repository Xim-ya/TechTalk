import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:techtalk/core/theme/extension/app_color.dart';
import 'package:techtalk/core/theme/extension/app_text_style.dart';
import 'package:techtalk/presentation/pages/study/learning/study_learning_event.dart';
import 'package:techtalk/presentation/pages/study/learning/widgets/study_controller_bar.dart';
import 'package:techtalk/presentation/pages/study/learning/widgets/study_progress_indicator.dart';
import 'package:techtalk/presentation/pages/study/learning/widgets/study_qna.dart';
import 'package:techtalk/presentation/providers/study/selected_study_topic_provider.dart';
import 'package:techtalk/presentation/providers/study/study_answer_blur_provider.dart';
import 'package:techtalk/presentation/providers/study/study_questions_provider.dart';
import 'package:techtalk/presentation/widgets/base/base_page.dart';
import 'package:techtalk/presentation/widgets/common/common.dart';

class StudyLearningPage extends BasePage {
  const StudyLearningPage({
    super.key,
  });

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) =>
      const _AppBar();

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const _Body();
}

class _AppBar extends StatelessWidget
    with StudyLearningEvent
    implements PreferredSizeWidget {
  const _AppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Consumer(
        builder: (context, ref, child) => Text(
          ref.watch(selectedStudyTopicProvider)!.name,
        ),
      ),
      actions: [
        Text(
          '답안 가리기',
          style: AppTextStyle.alert1.copyWith(
            color: AppColor.of.gray3,
          ),
        ),
        const Gap(8),
        Consumer(
          builder: (context, ref, child) => FlatSwitch(
            value: ref.watch(studyAnswerBlurProvider),
            onTap: (_) => onToggleAnswerBlur(ref),
          ),
        ),
        const Gap(16),
      ],
    );
  }
}

class _Body extends HookConsumerWidget {
  const _Body({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(studyQuestionsProvider);

    return questionsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('$error'),
      ),
      data: (questions) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(24),
            StudyProgressIndicator(),
            Gap(5),
            StudyQnaView(),
            StudyControllerBar(),
          ],
        );
      },
    );
  }
}
