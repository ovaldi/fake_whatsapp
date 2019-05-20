import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Whatsapp {
  static const String _METHOD_ISWHATSAPPINSTALLED = 'isWhatsappInstalled';
  static const String _METHOD_SHARETEXT = 'shareText';
  static const String _METHOD_SHAREIMAGE = 'shareImage';
  static const String _METHOD_SHAREWEBPAGE = 'shareWebpage';

  static const String _ARGUMENT_KEY_TEXT = 'text';
  static const String _ARGUMENT_KEY_IMAGEURI = 'imageUri';
  static const String _ARGUMENT_KEY_WEBPAGEURL = 'webpageUrl';

  final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/fake_whatsapp');

  /// 检测微信是否已安装
  Future<bool> isWhatsappInstalled() async {
    return (await _channel.invokeMethod(_METHOD_ISWHATSAPPINSTALLED)) as bool;
  }

  /// 分享 - 文本
  Future<void> shareText({
    @required String text,
  }) {
    return _channel.invokeMethod(
      _METHOD_SHARETEXT,
      <String, dynamic>{
        _ARGUMENT_KEY_TEXT: text,
      },
    );
  }

  /// 分享 - 图片
  Future<void> shareImage({
    String title,
    String description,
    @required Uri imageUri,
  }) {}

  /// 分享 - 网页
  Future<void> shareWebpage({
    String title,
    String description,
    @required String webpageUrl,
  }) {}
}
