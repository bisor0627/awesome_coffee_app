import 'dart:async';
import 'dart:convert';
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' as parser show parse;
import 'package:http/http.dart' as http show get;

/*
Each node has it's info + children.
The info is in the form of json and is only rendered at runtime
Nodes are rendered in the order of children...starting with screen 1
*/

class HttpManager {
  late final String url;
  String? userAgent;
  late Document data;
  HttpManager(this.url, {String? userAgent});

  Future<Document> init() async {
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: {if (userAgent != null) 'User-Agent': userAgent ?? ''});
    final document = parser.parse(utf8.decode(response.bodyBytes));
    return document;
  }
}
