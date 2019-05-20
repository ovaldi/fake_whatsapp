import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fake_path_provider/fake_path_provider.dart';
import 'package:fake_whatsapp/fake_whatsapp.dart';
import 'package:path/path.dart' as path;

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (Object error, StackTrace stack) {
    print(error);
    print(stack);
  });

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Whatsapp _whatsapp = Whatsapp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Whatsapp Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('环境检查'),
            onTap: () async {
              String content =
                  'whatsapp: ${await _whatsapp.isWhatsappInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('文字分享'),
            onTap: () {
              _whatsapp.shareText(
                text: 'Share Text!',
              );
            },
          ),
          ListTile(
            title: const Text('图片分享'),
            onTap: () async {
              AssetImage timg = const AssetImage('images/icon/timg.jpeg');
              AssetBundleImageKey key =
                  await timg.obtainKey(createLocalImageConfiguration(context));
              ByteData timgData = await key.bundle.load(key.name);
              Directory saveDir = await PathProvider.getDocumentsDirectory();
              File saveFile = File('${saveDir.path}${path.separator}timg.jpeg');
              if (!saveFile.existsSync()) {
                saveFile.createSync(recursive: true);
                saveFile.writeAsBytesSync(timgData.buffer.asUint8List(),
                    flush: true);
              }
              await _whatsapp.shareImage(
                imageUri: Uri.file(saveFile.path),
              );
            },
          ),
          ListTile(
            title: const Text('网页分享'),
            onTap: () {
              _whatsapp.shareWebpage(
                text: '分享链接：',
                webpageUrl: 'https://www.baidu.com/',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTips(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}
