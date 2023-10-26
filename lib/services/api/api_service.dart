import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/helpers/string_helper.dart';

class ApiService {
  static Future<Map<String, dynamic>> fetchQuestion() async {
    var url = Uri.parse(StringHelper.apiURL);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(StringHelper.failToLoadQuestionErrorMessage);
    }
  }
}
