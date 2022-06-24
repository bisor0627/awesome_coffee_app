import 'dart:async';

import 'package:awesome_cafe/global/provider/parent_provider.dart';
import 'package:awesome_cafe/global/utils/http_manager.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' show Document;

class CafeProvider extends ParentProvider {
  String? body;

  Future pushCafe() async {}

  Future getCafe() async {
    try {
      setStateBusy();

      Document? data =
          await HttpManager().getHtml('https://raw.githubusercontent.com/utilForever/awesome-cafe/main/README.md');

      if (data.body?.innerHtml != null) {
        String inner = data.body?.innerHtml ?? '';
        body = inner.substring(inner.indexOf('## 지역'), inner.indexOf('## 도움을 주신 분들'));

        for (var i = 0; i < body!.length; i++) {
          debugPrint(body!.indexOf('#### ').toString());
        }
        setStateIdle();
      }

      // return true;
    } catch (e) {
      // return false;
    }
  }
}
