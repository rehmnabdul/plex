import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:toastification/toastification.dart';

class MessageType {
  static const MessageType info = MessageType(ToastificationType.info);
  static const MessageType success = MessageType(ToastificationType.success);
  static const MessageType error = MessageType(ToastificationType.error);
  static const MessageType warning = MessageType(ToastificationType.warning);
  final ToastificationType type;

  const MessageType(this.type);
}

class MessageStyle {
  static const MessageStyle minimal = MessageStyle(ToastificationStyle.minimal);
  static const MessageStyle fillColored = MessageStyle(ToastificationStyle.fillColored);
  static const MessageStyle flatColored = MessageStyle(ToastificationStyle.flatColored);
  static const MessageStyle flat = MessageStyle(ToastificationStyle.flat);
  static const MessageStyle simple = MessageStyle(ToastificationStyle.simple);
  final ToastificationStyle style;

  const MessageStyle(this.style);
}

PlexColorTokens _messageTokens(BuildContext? context) {
  final BuildContext? ctx = context ?? Get.context;
  if (ctx != null) return PlexThemeData.of(ctx).colors;
  return PlexThemeData.fallback().colors;
}

({Color primary, Color background, Color foreground}) _toastPalette(
  PlexColorTokens colors,
  MessageType type,
) {
  switch (type.type) {
    case ToastificationType.success:
      return (
        primary: colors.statusSuccess,
        background: colors.statusSuccessSoft,
        foreground: colors.statusSuccessInk,
      );
    case ToastificationType.error:
      return (
        primary: colors.statusDanger,
        background: colors.statusDangerSoft,
        foreground: colors.statusDangerInk,
      );
    case ToastificationType.warning:
      return (
        primary: colors.statusWarning,
        background: colors.statusWarningSoft,
        foreground: colors.statusWarningInk,
      );
    case ToastificationType.info:
      return (
        primary: colors.statusInfo,
        background: colors.statusInfoSoft,
        foreground: colors.statusInfoInk,
      );
  }
}

List<BoxShadow> _toastShadow(PlexColorTokens colors) {
  return [
    BoxShadow(
      color: colors.brandInk.withValues(alpha: 0.07),
      blurRadius: 16,
      offset: const Offset(0, 16),
      spreadRadius: 0,
    ),
  ];
}

extension SnackBarUtils on BuildContext {
  ///Use [showMessage] If you are not using [PlexApp], If you are using the [PlexApp] use [showMessage] without context
  String? showMessage(
    String message, {
    String title = "Message",
    Widget? titleWidget,
    Widget? messageWidget,
    MessageType type = MessageType.info,
    MessageStyle style = MessageStyle.flatColored,
    bool autoClose = true,
    int autoCloseDurationSeconds = 5,
    Alignment alignment = Alignment.bottomRight,
    TextDirection textDirection = TextDirection.ltr,
    bool showAnimation = false,
    int animationDurationMillis = 300,
    Widget? customIcon,
  }) {
    if (!mounted) return null;
    final PlexColorTokens colors = _messageTokens(this);
    final palette = _toastPalette(colors, type);
    return toastification.show(
      context: this,
      type: type.type,
      style: style.style,
      autoCloseDuration: autoClose ? Duration(seconds: autoCloseDurationSeconds) : null,
      title: titleWidget ?? Text(title),
      description: messageWidget ?? Text(message),
      alignment: alignment,
      direction: textDirection,
      animationDuration: showAnimation ? Duration(milliseconds: animationDurationMillis) : null,
      animationBuilder: showAnimation
          ? (context, animation, alignment, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }
          : null,
      icon: customIcon,
      primaryColor: palette.primary,
      backgroundColor: palette.background,
      foregroundColor: palette.foreground,
      borderRadius: BorderRadius.circular(PlexRadius.md),
      boxShadow: _toastShadow(colors),
      showProgressBar: autoClose,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) {
          print('Toast ${toastItem.id} close button tapped');
          toastification.dismissById(toastItem.id);
        },
        onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    ).id;
  }

  Future<String?> showMessageDelayed(
    String message, {
    int delayMilliseconds = 100,
    String title = "Message",
    Widget? titleWidget,
    Widget? messageWidget,
    MessageType type = MessageType.info,
    MessageStyle style = MessageStyle.flatColored,
    bool autoClose = true,
    int autoCloseDurationSeconds = 5,
    Alignment alignment = Alignment.bottomRight,
    TextDirection textDirection = TextDirection.ltr,
    bool showAnimation = false,
    int animationDurationMillis = 300,
    Widget? customIcon,
  }) async {
    if (!mounted) return null;
    return Future.delayed(
      Duration(milliseconds: delayMilliseconds),
      () {
        return showMessage(
          message,
          title: title,
          titleWidget: titleWidget,
          messageWidget: messageWidget,
          type: type,
          style: style,
          autoClose: autoClose,
          autoCloseDurationSeconds: autoCloseDurationSeconds,
          alignment: alignment,
          textDirection: textDirection,
          showAnimation: showAnimation,
          animationDurationMillis: animationDurationMillis,
          customIcon: customIcon,
        );
      },
    );
  }

  String? showSnackBar(String message) {
    if (!mounted) return null;
    return showMessage(message);
  }

  hideMessageById(String id) {
    toastification.dismissById(id);
  }

  copyToClipboard(String text, {bool showCopiedInfo = true}) {
    Clipboard.setData(ClipboardData(text: text));
    if (showCopiedInfo) showSnackBar("Text copied on clipboard");
  }
}

extension SnackBarUtilsOnObject on Object {
  ///Use [showMessage] without context if you are using [PlexApp]
  String showMessage(
    String message, {
    String title = "Message",
    Widget? titleWidget,
    Widget? messageWidget,
    MessageType type = MessageType.info,
    MessageStyle style = MessageStyle.flatColored,
    bool autoClose = true,
    int autoCloseDurationSeconds = 5,
    Alignment alignment = Alignment.bottomRight,
    TextDirection textDirection = TextDirection.ltr,
    bool showAnimation = false,
    int animationDurationMillis = 300,
    Widget? customIcon,
  }) {
    final PlexColorTokens colors = _messageTokens(null);
    final palette = _toastPalette(colors, type);
    return toastification.show(
      type: type.type,
      style: style.style,
      autoCloseDuration: autoClose ? Duration(seconds: autoCloseDurationSeconds) : null,
      title: titleWidget ?? Text(title),
      description: messageWidget ?? Text(message),
      alignment: alignment,
      direction: textDirection,
      animationDuration: showAnimation ? Duration(milliseconds: animationDurationMillis) : null,
      animationBuilder: showAnimation
          ? (context, animation, alignment, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }
          : null,
      icon: customIcon,
      primaryColor: palette.primary,
      backgroundColor: palette.background,
      foregroundColor: palette.foreground,
      borderRadius: BorderRadius.circular(PlexRadius.md),
      boxShadow: _toastShadow(colors),
      showProgressBar: autoClose,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) {
          print('Toast ${toastItem.id} close button tapped');
          toastification.dismissById(toastItem.id);
        },
        onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    ).id;
  }

  String showMessageError(
    String message, {
    String title = "Message",
    Widget? titleWidget,
    Widget? messageWidget,
    MessageStyle style = MessageStyle.flatColored,
    bool autoClose = true,
    int autoCloseDurationSeconds = 5,
    Alignment alignment = Alignment.bottomRight,
    TextDirection textDirection = TextDirection.ltr,
    bool showAnimation = false,
    int animationDurationMillis = 300,
    Widget? customIcon,
  }) {
    return showMessage(
      message,
      title: title,
      titleWidget: titleWidget,
      messageWidget: messageWidget,
      type: MessageType.error,
      style: style,
      autoClose: autoClose,
      autoCloseDurationSeconds: autoCloseDurationSeconds,
      alignment: alignment,
      textDirection: textDirection,
      showAnimation: autoClose,
      animationDurationMillis: animationDurationMillis,
      customIcon: customIcon,
    );
  }

  String showMessageErrorNoAutoClose(
    String message, {
    String title = "Message",
    Widget? titleWidget,
    Widget? messageWidget,
    MessageStyle style = MessageStyle.flatColored,
    Alignment alignment = Alignment.bottomRight,
    TextDirection textDirection = TextDirection.ltr,
    bool showAnimation = false,
    int animationDurationMillis = 300,
    Widget? customIcon,
  }) {
    return showMessage(
      message,
      title: title,
      titleWidget: titleWidget,
      messageWidget: messageWidget,
      type: MessageType.error,
      style: style,
      autoClose: false,
      alignment: alignment,
      textDirection: textDirection,
      showAnimation: showAnimation,
      animationDurationMillis: animationDurationMillis,
      customIcon: customIcon,
    );
  }

  hideMessageById(String id) {
    toastification.dismissById(id);
  }
}
