import 'dart:async';

import 'package:awesome_cafe/global/model/cafe_model.dart';
import 'package:awesome_cafe/global/provider/parent_provider.dart';
import 'package:awesome_cafe/global/utils/http_manager.dart';
import 'package:awesome_cafe/global/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' show Document;

class CafeProvider extends ParentProvider {
  String? body;
  List<String> items = [];
  Future pushCafe() async {}
  List<CafeModel?> cafeList = [];
  Future getCafe() async {
    try {
      setStateBusy();

      Document? data =
          await HttpManager().getHtml('https://raw.githubusercontent.com/utilForever/awesome-cafe/main/README.md');

      if (data.body?.innerHtml != null) {
        String inner = data.body?.innerHtml ?? '';

        items = sliceACafe(inner.substring(inner.indexOf('## 지역'), inner.indexOf('## 도움을 주신 분들')));

        setStateIdle();

        items.forEach((element) {
          debugPrint(element);
          cafeList.add(sliceACafeSpec(element));
        });
      }
      // return true;
    } catch (e) {
      // return false;
    }
  }
}
