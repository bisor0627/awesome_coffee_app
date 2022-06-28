import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' as parser show parse;
import 'package:http/http.dart' as http show get, Response;

/*
Each node has it's info + children.
The info is in the form of json and is only rendered at runtime
Nodes are rendered in the order of children...starting with screen 1
*/

class HttpManager {
  HttpManager();

  Future<http.Response> getHttp(String url, {Map<String, String>? keys, Map<String, String>? headers}) async {
    String parseQuery = '';
    if (keys != null) {
      for (var i = 0; i < keys.length; i++) {
        if (i != 0) {
          parseQuery += '&';
        } else {
          parseQuery += '?';
        }
        parseQuery += '${keys.keys.toList()[i]}=${keys.values.toList()[i]}';
      }
    }
    final uri = Uri.parse(url + parseQuery);
    final response = await http.get(uri, headers: {if (headers != null) ...headers});
    return response;
  }

  Document parseDocument(http.Response response) {
    return parser.parse(utf8.decode(response.bodyBytes));
  }

  Map<String, dynamic> parseJson(http.Response response) {
    return jsonDecode(response.body);
  }
}
