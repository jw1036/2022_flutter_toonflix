import 'dart:convert';

import 'package:flutter_toonflix/models/webtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodayToons() async {
    List<WebtoonModel> result = [];
    final url = Uri.parse("$baseUrl/$today");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final toons = jsonDecode(response.body);
      for (var toon in toons) {
        result.add(WebtoonModel.fromJson(toon));
      }
      return result;
    }
    throw Error();
  }
}
