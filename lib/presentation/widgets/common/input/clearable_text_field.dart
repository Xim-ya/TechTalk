import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:techtalk/core/theme/extension/app_color.dart';

class ClearableTextField extends HookWidget {
  const ClearableTextField({
    super.key,
    this.focusNode,
    this.controller,
    this.initialValue,
    this.style,
    this.inputDecoration,
    this.onClear,
    this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.activeSuffixIcon = true,
    this.autoFocus = false,
    this.inputFormatters,
    this.keyboardType,
  });

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? initialValue;
  final TextStyle? style;
  final InputDecoration? inputDecoration;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool enabled;
  final bool autoFocus;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  /// 우측 아이콘을 활성화할지 여부
  final bool activeSuffixIcon;

  /// 클리어 아이콘을 눌렀을 때 실행할 콜백
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final controller =
        this.controller ?? useTextEditingController(text: initialValue);
    final isFieldEmpty = useListenableSelector(
      controller,
      () => controller.text.isEmpty,
    );
    var inputDecoration = this.inputDecoration ?? const InputDecoration();
    inputDecoration = inputDecoration.copyWith(
      suffixIcon: activeSuffixIcon && !isFieldEmpty
          ? _buildClearIcon(controller)
          : null,
    );

    return TextField(
      focusNode: focusNode,
      controller: controller,
      autofocus: autoFocus,
      enabled: enabled,
      obscureText: obscureText,
      style: style,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: inputDecoration,
      onChanged: onChanged,
    );
  }

  Widget _buildClearIcon(TextEditingController controller) {
    return IconButton(
      onPressed: onClear ??
          () {
            controller.clear();
          },
      icon: FaIcon(
        FontAwesomeIcons.solidCircleXmark,
        size: 16.r,
        color: AppColor.of.gray2,
      ),
    );
  }
}
