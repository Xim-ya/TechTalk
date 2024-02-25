import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder(this.context, this.child, {super.key});

  final BuildContext context;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          EasyLoading.init()(context, child);
          // 태블릿 디바이스일 경우
          return Stack(
            children: [
              Container(
                color: Colors.black, // 검정색 배경
              ),
              Center(
                child: SizedBox(
                  width: 375, // 가운데 화면의 너비
                  height: 812, // 가운데 화면의 높이
                  child: child,
                ),
              ),
            ],
          );
        } else {
          // 태블릿 디바이스가 아닐 경우
          return EasyLoading.init()(context, child); // Easy 로딩 컨텐츠스트 초기화
        }
      },
    );
  }
}
