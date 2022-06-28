import 'package:awesome_cafe/global/model/address_model.dart';
import 'package:awesome_cafe/global/utils/http_manager.dart';
import 'package:awesome_cafe/global/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart';

void main() {
  group('api test for group', () {
    test('getHttp with parseDocument', () async {
      final HttpManager httpManager = HttpManager();
      Document? data = httpManager.parseDocument(
          await httpManager.getHttp('https://raw.githubusercontent.com/utilForever/awesome-cafe/main/README.md'));
      debugPrint(data.text);
    });
    test('getHttp with parseJson', () async {
      // final HttpManager httpManager = HttpManager();
      Map<String, dynamic> getData = HttpManager()
          .parseJson(await HttpManager().getHttp('https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode', keys: {
        'query': '서울 강남구 역삼로 415',
      }, headers: {
        'X-NCP-APIGW-API-KEY-ID': k_NCP_APIGW_ID,
        'X-NCP-APIGW-API-KEY': k_NCP_APIGW_KEY
      }));
      debugPrint(getData['addresses'].toString());
      AddresssModel testData = AddresssModel.fromMap(getData['addresses'][0]);
      debugPrint(testData.toJson());
    });
  });
}
