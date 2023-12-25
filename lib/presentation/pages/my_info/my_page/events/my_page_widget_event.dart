import 'package:flutter/material.dart';
import 'package:techtalk/core/helper/global_event_key.dart';

mixin class MyPageWidgetEvent {
  ///
  /// [ExpandableWrappedListview]
  /// Wrap위젯이 overflow 되었을 때,
  /// 첫 번째 행의 끝 위치와
  /// 마지막 행의 끝 위치를 구하는 메소드
  ///
  void getListItemPosition(
      List<({String text, GlobalKey key})> itemCollection,
      ValueNotifier<double> firstRowElementY,
      ValueNotifier<double> lastRowElementY,
      double spacing) {
    int firstRowElementCount = 0;
    int lastRowElementCount = 0;
    final firstRowY = itemCollection[0].key.top;
    final lastRowY = itemCollection.last.key.top;

    for (var e in itemCollection) {
      if (e.key.top == firstRowY) {
        firstRowElementY.value += e.key.width;
        firstRowElementCount++;
      } else {
        if (e.key.top == lastRowY) {
          lastRowElementY.value += e.key.width;
          lastRowElementCount++;
        }
      }
    }

    if (firstRowElementCount > 0) {
      firstRowElementY.value += spacing * (firstRowElementCount - 1);
    }

    if (lastRowElementCount > 0) {
      lastRowElementY.value += spacing * (lastRowElementCount - 1);
    }
  }

  ///
  /// [ExpandableWrappedListview]
  /// 상단에 위치한 [Wrap]의 자체 크기를
  /// 확인하여, overflow가 되었는지 계산하는 메소드
  ///
  void getWrapWidgetSize(BuildContext context, ValueNotifier<Size> notifier,
      ValueNotifier<double> originHeight) {
    notifier.value = (context.findRenderObject() as RenderBox).size;
    originHeight.value = notifier.value.height;
  }
}
