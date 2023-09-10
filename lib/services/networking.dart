import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkRequester {
  static get(String url) async {
    String? rawData;
    dynamic data;

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        rawData = await response.body;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      if (rawData == null) return null;
      data = jsonDecode(rawData);
      return data;
    }
  }
}
