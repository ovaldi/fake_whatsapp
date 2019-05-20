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

  static const String _SCHEME_FILE = 'file';

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
    assert(text != null && text.isNotEmpty);
    return _channel.invokeMethod(
      _METHOD_SHARETEXT,
      <String, dynamic>{
        _ARGUMENT_KEY_TEXT: text,
      },
    );
  }

  /// 分享 - 图片
  Future<void> shareImage({
    @required Uri imageUri,
  }) {
    assert(imageUri != null && imageUri.isScheme(_SCHEME_FILE));
    return _channel.invokeMethod(
      _METHOD_SHAREIMAGE,
      <String, dynamic>{
        _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
      },
    );
  }

  /// 分享 - 网页
  Future<void> shareWebpage({
    String text,
    @required String webpageUrl,
  }) {
    assert(webpageUrl != null && webpageUrl.isNotEmpty);
    Map<String, dynamic> map = <String, dynamic>{
//      _ARGUMENT_KEY_TEXT: text,
      _ARGUMENT_KEY_WEBPAGEURL: webpageUrl,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (text != null && text.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_TEXT, () => text);
    }
    return _channel.invokeMethod(_METHOD_SHAREWEBPAGE, map);
  }
}
