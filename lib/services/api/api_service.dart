import '../../helpers/import_helper.dart';

class ApiService {
  static Future<Map<String, dynamic>> fetchQuestion() async {
    var url = Uri.parse(ConstantHelper.apiURL);
    final response = await get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(StringHelper.failToLoadQuestionErrorMessage);
    }
  }
}
