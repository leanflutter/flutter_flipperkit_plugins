# flipperkit_sqflite_driver

[![pub package](https://img.shields.io/pub/v/flipperkit_sqflite_driver.svg)](https://pub.dartlang.org/packages/flipperkit_sqflite_driver)

[English](./README.md) | 简体中文

## 快速开始

### 必备条件

开始之前确保你已安装：

- 已安装 [flutter_flipperkit](https://github.com/blankapp/flutter_flipperkit)
- 已安装 [flipper-plugin-reduxinspector](https://github.com/blankapp/flipper-plugin-reduxinspector)
- 已安装 [redux](https://github.com/johnpryan/redux.dart)

### 安装

添加以下内容到包的 pubspec.yaml 文件中：

```yaml
dependencies:
  flipperkit_sqflite_driver: ^0.0.2
```

您可以通过命令行安装软件包：

```bash
$ flutter packages get
```

### 用法

```dart
import 'package:flipperkit_sqflite_driver/flipperkit_sqflite_driver.dart';

void main() async {
  FlipperClient flipperClient = FlipperClient.getDefault();

  flipperClient.addPlugin(new FlipperDatabaseBrowserPlugin(SqfliteDriver('simple_todo.db')));
  flipperClient.start();

  runApp(MyApp());
}
```

## 许可证

```
MIT License

Copyright (c) 2019 JianyingLi <lijy91@foxmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
