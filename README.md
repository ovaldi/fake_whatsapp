# fake_whatsapp

[![Build Status](https://cloud.drone.io/api/badges/v7lin/fake_whatsapp/status.svg)](https://cloud.drone.io/v7lin/fake_whatsapp)
[![Codecov](https://codecov.io/gh/v7lin/fake_whatsapp/branch/master/graph/badge.svg)](https://codecov.io/gh/v7lin/fake_whatsapp)
[![GitHub Tag](https://img.shields.io/github/tag/v7lin/fake_whatsapp.svg)](https://github.com/v7lin/fake_whatsapp/releases)
[![Pub Package](https://img.shields.io/pub/v/fake_whatsapp.svg)](https://pub.dartlang.org/packages/fake_whatsapp)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/v7lin/fake_whatsapp/blob/master/LICENSE)

A powerful whatsapp plugin for Flutter.

## docs

* [Android](https://faq.whatsapp.com/en/android/28000012?lang=zh_cn)
* [iOS](https://faq.whatsapp.com/iphone/23559013)

## android

````
# 不需要做任何额外接入工作
````

## ios

````
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>whatsapp</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
````

## flutter

* snapshot

* release

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
