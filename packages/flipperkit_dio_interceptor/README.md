# flipperkit_dio_interceptor

[![pub package](https://img.shields.io/pub/v/flipperkit_dio_interceptor.svg)](https://pub.dartlang.org/packages/flipperkit_dio_interceptor)

English | [简体中文](./README.zh_CN.md)

> `flutter_flipperkit` already supports global interception of network requests (all requests based on `HttpClient` API can be intercepted), if you do not set the network plugin `useHttpOverrides` parameter to false, you do not need to use this interceptor.

## Getting Started

### Prerequisites

Before starting make sure you have:

- Installed [flutter_flipperkit](https://github.com/leanflutter/flutter_flipperkit)
- Installed [dio](https://github.com/flutterchina/dio)

### Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  flipperkit_dio_interceptor: ^0.1.0
```

You can install packages from the command line:

```bash
$ flutter packages get
```

### Usage

```dart
import 'package:dio/dio.dart';
import 'package:flipperkit_dio_interceptor/flipperkit_dio_interceptor.dart';

void sendRequest() async {
  Dio dio = new Dio();
  dio.interceptors.add(FlipperKitDioInterceptor());
  Response response = dio.get("https://example.com");
}
```

## License

```
MIT License

Copyright (c) 2021 LiJianying <lijy91@foxmail.com>

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
