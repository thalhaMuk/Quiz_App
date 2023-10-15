import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> fetchQuestion() async {
    var url = Uri.parse("https://marcconrad.com/uob/smile/api.php");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load question');
    }
  }
}
