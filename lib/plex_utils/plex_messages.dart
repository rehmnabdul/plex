import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

extension SnackBarUtils on BuildContext {
  ///Use [showMessage] If you are not using [PlexApp], If you are using the [PlexApp] use [showMessage] without context
  showMessage(
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
    if (!mounted) return;
    toastification.show(
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
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
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
    );
  }

  showMessageDelayed(
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
  }) {
    if (!mounted) return;
    Future.delayed(
      Duration(milliseconds: delayMilliseconds),
      () {
        showMessage(
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

  showSnackBar(String message) {
    if (!mounted) return;
    showMessage(message);
    return;
  }

  copyToClipboard(String text, {bool showCopiedInfo = true}) {
    Clipboard.setData(ClipboardData(text: text));
    if (showCopiedInfo) showSnackBar("Text copied on clipboard");
  }
}

extension SnackBarUtilsOnObject on Object {
  ///Use [showMessage] without context if you are using [PlexApp]
  showMessage(
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
    toastification.show(
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
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
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
    );
  }

  showMessageError(
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
    showMessage(
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

  showMessageErrorNoAutoClose(
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
    showMessage(
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
}
