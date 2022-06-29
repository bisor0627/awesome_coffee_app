import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http show get, Response;
import 'package:awesome_cafe/global/model/address_model.dart';
import 'package:awesome_cafe/global/model/cafe_model.dart';
import 'package:awesome_cafe/global/provider/parent_provider.dart';
import 'package:awesome_cafe/global/utils/http_manager.dart';
import 'package:awesome_cafe/global/utils/keys.dart';
import 'package:awesome_cafe/global/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' show Document;
import 'package:latlng/latlng.dart';

class CafeProvider extends ParentProvider {
  String? body;
  Future pushCafe() async {}
  List<CafeModel?> cafeList = [];
  List<LatLng> markers = [];
  Future getCafe() async {
    try {
      setStateBusy();

      Document? data = HttpManager().parseDocument(
          await HttpManager().getHttp('https://raw.githubusercontent.com/utilForever/awesome-cafe/main/README.md'));

      if (data.body?.innerHtml != null) {
        String inner = data.body?.innerHtml ?? '';

        // setStateIdle();

        sliceACafe(inner.substring(inner.indexOf('## 지역'), inner.indexOf('## 도움을 주신 분들'))).forEach((element) {
          cafeList.add(sliceACafeSpec(element));
        });
        await getMarker();
        setStateIdle();
      }

      // return true;
    } catch (e) {
      setStateError();
      // return false;
    }
  }

  Future getMarker() async {
    for (var i = 0; i < cafeList.length; i++) {
      if (cafeList[i]?.location != null) {
        try {
          Map<String, dynamic> location = HttpManager().parseJson(
              await HttpManager().getHttp('https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode', keys: {
            'query': cafeList[i]!.location,
          }, headers: {
            'X-NCP-APIGW-API-KEY-ID': k_NCP_APIGW_ID,
            'X-NCP-APIGW-API-KEY': k_NCP_APIGW_KEY
          }));
          cafeList[i]?.address = AddresssModel.fromMap(location['addresses'][0]);
          // markers.add();
        } catch (e) {
          debugPrint(e.toString());
          break;
        }
      }
    }
  }
}
